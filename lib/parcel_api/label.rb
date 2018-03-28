module ParcelApi

  # This module provides API requests to label parcels, get existing label details
  # and download labels.

  class Label
    LABEL_URL = '/ParcelLabel/2.0/labels'

    attr_accessor :connection, :labels, :label_request, :label_response

    # Creates a new ParcelApi::Label instance.

    def initialize(connection = nil)
      self.connection ||= connection || ParcelApi::Client.connection
    end

    # Create a label with the specified options
    # @param label_options [Hash]
    # @return Single or array of label objects

    def create(label_options)
      create_label File.join(LABEL_URL, 'domestic'), label_options
    end

    # Create an international label with the specified options
    # @param label_options [Hash]
    # @return Single or array of label objects

    def international_create(label_options)
      create_label File.join(LABEL_URL, 'international', label_options)
    end

    # Get label details
    # @param label_id [String]
    # @return Object of label details

    def details(label_id)
      details_url = File.join(LABEL_URL, "#{label_id}.json")
      response = connection.get details_url
      details = response.parsed.tap {|d| d.delete('success')}
      OpenStruct.new(details)
    end

    # Download label
    # @param label_id [String]
    # @return Object of label

    def download(label_id)
      download_url = File.join(LABEL_URL, "#{label_id}.pdf")
      response = connection.get download_url
      StringIO.new(response.body)
    end

    private

    def create_label(url, label_options)
      self.label_request = {
        body: label_options.to_json.to_ascii,
        headers: { 'Content-Type' => 'application/json' }
      }
      self.label_response = connection.post(url, label_request)
      self.label_response.parsed['labels'].map {|label| OpenStruct.new(label)}.first
    end

  end

end
