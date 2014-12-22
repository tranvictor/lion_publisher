require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'json'

API_VERSION = 'v1.3'
CACHED_API_FILE = "adsense-v1.3.cache"
CREDENTIAL_STORE_FILE = "teensdigest-oauth2.json"

class TrackingsController < ApplicationController
  layout 'trackings'

  before_filter :except => [:show] do
    unless user_signed_in? && current_user.admin?
      redirect_to "/", :notice => "Please login to access this area !"
    end
  end

  def show
    parse_setting()
    if params[:id] != nil
      @publisher = Publisher.find(params[:id])
      if user_signed_in?
        if !current_user.owner?(@publisher) and !current_user.admin?
          return redirect_to "/", :notice => "You don't have permission to access this area"
        end
      else
        return redirect_to "/", :notice => "You don't have permission to access this area"
      end
    else
      @publisher = current_user.publisher
    end
    if @publisher == nil
      return redirect_to "/trackings/admin"
    end
    @tableData = []
    @publisher_domain = @publisher.get_domain
    for row in @reports.data.rows
      domain = row[1]
      if domain == @publisher_domain
        @tableData.push([row[0],
                         "%.0f" % (row[2].to_f * @threshold),
                         "%.0f" % (row[3].to_f * @threshold),
                         "%.2f" % (row[5].to_f * @threshold),
        ])
      end
    end
    if @tableData.size == 0
      @tableData.push([0, 0, 0, 0, 0])
    end
  end

  def admin_show
    parse_setting()
  end

  def update_threshold
    if !current_user.super_admin?
      redirect_to "/", :notice => "You don't have permission to access this area"
    end
    @threshold = params[:tracking][:threshold].to_f
    @tracking_domain = params[:tracking][:domain]
    new_threshold = {'threshold' => @threshold, 'tracking' => @tracking_domain}
    File.open("#{Rails.root}/config/tracking_threshold.yml", 'w') { |f| YAML.dump(new_threshold, f) }
    redirect_to :controller => 'trackings', :action => 'show'
  end

  private
  def parse_setting
    @startDate = params[:startDate]
    @endDate = params[:endDate]
    @pointSize = 2
    if @startDate == nil or @startDate == ""
      @startDate = 'startOfMonth'
    end
    if @endDate == nil or @endDate == ""
      @endDate = 'today'
    end
    if params[:specialRange] == "This month"
      @startDate = "startOfMonth"
      @endDate = "today"
    else
      if params[:specialRange] == "This year"
        @startDate = "startOfYear"
        @endDate = "today"
        @pointSize = 0
      else
        if params[:specialRange] == "Today"
          @startDate = "today"
          @endDate = "today"
          @pointSize = 4
        end
      end
    end
    @reports = generate_report(@startDate, @endDate)
    @tracking_threshold = get_tracking_threshold
    @threshold = @tracking_threshold['threshold'].to_f
    @tracking_domain = @tracking_threshold['tracking']
    @publishers = Publisher.all
    @report_dictionary = {}
    for row in @reports.data.rows
      temp = @report_dictionary[row[1]]
      if temp == nil
        @report_dictionary[row[1]] = {
          :pageview => row[2].to_f,
          :clicks => row[3].to_f,
          :rpm => row[4].to_f,
          :earning => row[5].to_f,
          :cpc => row[6].to_f,
          :page_ctr => row[7].to_f,
          :number => 1
        }
      else
        temp[:pageview] += row[2].to_f
        temp[:clicks] += row[3].to_f
        temp[:rpm] += row[4].to_f
        temp[:earning] += row[5].to_f
        temp[:cpc] += row[6].to_f
        temp[:page_ctr] += row[7].to_f
        temp[:number] += 1
      end
    end
  end

  def generate_report(startDate, endDate)
    client = Google::APIClient.new(:application_name => 'Ruby AdSense sample',
                                   :application_version => '1.0.0')
    temp = nil
    if File.exist? CREDENTIAL_STORE_FILE
      File.open(CREDENTIAL_STORE_FILE, "r") do |f|
        temp = JSON.load(f)
        if temp["authorization_uri"].class != String
          temp["authorization_uri"] = "https://accounts.google.com/o/oauth2/auth"
        end
        if temp["token_credential_uri"].class != String
          temp["token_credential_uri"] = "https://accounts.google.com/o/oauth2/token"
        end
      end
      File.open(CREDENTIAL_STORE_FILE, "w") do |f|
        f.write(temp.to_json)
      end
    end
    file_storage = Google::APIClient::FileStorage.new(CREDENTIAL_STORE_FILE)
    if file_storage.authorization.nil?
      client_secrets = Google::APIClient::ClientSecrets.load
      # The InstalledAppFlow is a helper class to handle the OAuth 2.0 installed
      # application flow, which ties in with FileStorage to store credentials
      # between runs.
      flow = Google::APIClient::InstalledAppFlow.new(
        :client_id => client_secrets.client_id,
        :client_secret => client_secrets.client_secret,
        :scope => ['https://www.googleapis.com/auth/adsense.readonly']
      )
      client.authorization = flow.authorize(file_storage)
    else
      client.authorization = file_storage.authorization
    end

    adsense = nil
    # Load cached discovered API, if it exists. This prevents retrieving the
    # discovery document on every run, saving a round-trip to the discovery
    # service.
    if File.exists? CACHED_API_FILE
      File.open(CACHED_API_FILE) do |file|
        adsense = Marshal.load(file)
      end
    else
      adsense = client.discovered_api('adsense', API_VERSION)
      File.open(CACHED_API_FILE, 'w') do |file|
        Marshal.dump(adsense, file)
      end
    end
    client.execute(
      :api_method => adsense.reports.generate,
      :parameters => {'startDate' => startDate, 'endDate' => endDate,
                      'metric' => ['PAGE_VIEWS',
                                   'CLICKS',
                                   'PAGE_VIEWS_RPM',
                                   'EARNINGS',
                                   'COST_PER_CLICK',
                                   'PAGE_VIEWS_CTR'
                                  ],
                      'dimension' => ['DATE', 'DOMAIN_NAME'],
                      'sort' => ['+DATE']})
  end
end
