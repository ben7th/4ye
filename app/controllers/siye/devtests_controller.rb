module Siye
  module VideoActions
    def video
      respond_to do |format|
        format.json { _video_json }
        format.xml  { _video_xml }
        format.html { _video_html }
      end
    end

    def _video_html
      video_url = params[:url]
      if video_url.present?
        fetcher = VideoFetcher::YoukuM3U8.new video_url
        @title = fetcher.video_title
        @formats = fetcher.video_formats
        @current_format = _current_format
      end
    end

    def _video_xml
      video_url = params[:url]
      fetcher = VideoFetcher::YoukuM3U8.new video_url
      @data = fetcher.files_data
      @current_format = _current_format
    end

    def _current_format
      return params[:vformat] if params[:vformat].present?
      return @formats.last
    end

    def _video_json
      if params[:url].blank?
        # 无间道
        video_url = 'http://v.youku.com/v_show/id_XNTY0ODE0MzU2.html'

        # 少女时代_Mr.Mr._Music Video
        # video_url = 'http://v.youku.com/v_show/id_XNjc5MTAyMDky.html'
      else
        video_url = params[:url]
      end

      fetcher = VideoFetcher::YoukuM3U8.new video_url

      render :json => {
        :youku_url => fetcher.url,
        :video_id => fetcher.video_id,
        :video_api_url => fetcher.video_api_url,
        :info => {
          :video_title => fetcher.video_title,
          :video_image => fetcher.video_image,
          :video_formats => fetcher.video_formats,
          :files_data => fetcher.files_data
        }
      }
    end
  end

  module AliyunActions
    def aliyun
      verb = 'GET'
      @sign_url = _sign_url 'GET', '4ye-video', '/test/视频解析器-100.mp4'
    end

    def _sign_url(method, bucket_name, object_path)
      @aliyun_access_id  = ''
      @aliyun_access_key = ''

      @expires = (Time.now + 2.hours).to_i
      @path = "/#{bucket_name}#{object_path}"

      @string_to_sign = "#{method}\n\n\n#{@expires}\n#{@path}"

      digest = OpenSSL::Digest::Digest.new('sha1')
      h = OpenSSL::HMAC.digest(digest, @aliyun_access_key, @string_to_sign)
      @sign = Base64.encode64(h).strip # 多一个 \n 所以要 strip 一下
      @sign = CGI::escape @sign

      "http://#{bucket_name}.oss-cn-qingdao.aliyuncs.com#{object_path}" +
      "?Expires=#{@expires}" +
      "&OSSAccessKeyId=#{@aliyun_access_id}" +
      "&Signature=#{@sign}"
    end
  end

  class DevtestsController < ApplicationController
    include VideoActions
    include AliyunActions
  end
end