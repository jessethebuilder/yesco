class ListingsController < ApplicationController
  # include ActionController::Live

  def index
    render_index_json
    # respond_to do |format|
    #   format.json redirect_to 'http://google.com'
    #   # render_index_json
    # end
  end

  private

  def render_index_json
    set_headers
    response.status = 200
    self.response.body = all_listings
  end

  def set_headers
    set_file_headers
    set_streaming_headers
  end

  def set_file_headers
    file_name = "yelp_#{Time.now.to_i}.json"
    headers["Content-Type"] = "text/json"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end

  def set_streaming_headers
    headers['X-Accel-Buffering'] = 'no'
    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
  end

  def all_listings
    # @listings = Listing.all
    Enumerator.new do |enum|
      # Listing.all.find_each(:batch_size => 100) do |l|
      Listing.where(:zip => '10001').each do |l|
        enum << l.build
      end
      # @listings.find_in_batches(1){ |l| enum << l.jbuild }
      # sleep 5
    end
  end
    # response.headers['Content-Type'] = 'text/event-stream'
    # response.stream.write '['

  #   headers['X-Accel-Buffering'] = 'no' # Stop NGINX from buffering
  #   headers["Cache-Control"] = "no-cache" # Stop downstream caching
  #   headers["Transfer-Encoding"] = "chunked" # Chunked response header
  #   headers.delete("Content-Length") # See one line above
  #
  #     self.response_body = Enumerator.new do |lines|
  #       Listing.find_each do |l|
  #         lines << l.name
  #       end
  #     end
  #     # response.stream.write l.name
  #     # raw = l.jbuild
  #       # response.stream.write
  #       # pretty = ENV['WRITE_PRETTY_JSON'] == 'true' ? true : false
  #       # json = pretty ? JSON.pretty_generate(JSON.parse(raw)) : raw
  #       # response.stream.write json
  #   # end
  #   # response.stream.write ']'
  #
  # ensure
  #   response.stream.close
  # end
end
