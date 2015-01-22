require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'json'

class Publisher < ActiveRecord::Base

  PROPERTY_OPTIONS = ['Paypal', 'US Checks', 'US Bank Transfer',
                      'Foreign Bank Transfer', 'Google Wallet']
  CURRENCY_OPTIONS = ['Local Currency', 'US Dollar']

  API_VERSION = 'v1.3'
  CACHED_API_FILE = "adsense-v1.3.cache"
  CREDENTIAL_STORE_FILE = "teensdigest-oauth2.json"
  CLIENT_SECRETS = "client_secrets.json"
  CLIENT_SECRET_BACKUP = "client_secrets_backup.json"
  CACHED_API_FILE_BACKUP = "adsense-v1.3-backup.cache"
  CREDENTIAL_STORE_FILE_BACKUP = "teensdigest-oauth2-backup.json"

  attr_accessor :from, :to

  # attr_accessible :code, :from, :to, :paypal_email, :name, :address,
  #   :bank_account, :user_id, :checks_address, :checks_city, :checks_state,
  #   :checks_zipcode, :bank_bank_name, :bank_account_number, :bank_routing_number,
  #   :foreign_swift_code, :foreign_account_number, :foreign_irc_code,
  #   :foreign_iban_code, :payment_method, :payment, :foreign_bank_name,
  #   :foreign_branch_sort_code, :foreign_address, :foreign_currency,
  #   :google_wallet_email, :real_currency

  #:bank_account is for foreign bank address
  #:foreign_account_number is for foreign bank name
  #:foreign_bank_name is for foreign account number

  self.per_page = 10
  paginates_per 10

  has_many :clicks, dependent: :destroy
  has_many :visitors, dependent: :destroy
  has_many :page_views, dependent: :destroy
  has_many :ad_clicks, dependent: :destroy
  belongs_to :user

  validates :code, uniqueness: true

  class << self
    def generate_report_dictionary(startDate, endDate)
      reports, length = generate_report(startDate, endDate)
      report_dictionary = {}
      if length == 0
        reports, length = generate_report(
          startDate, endDate,
          Publisher::CREDENTIAL_STORE_FILE_BACKUP,
          Publisher::CLIENT_SECRET_BACKUP,
          Publisher::CACHED_API_FILE_BACKUP)
      end
      for row in reports
        temp = report_dictionary[row[1]]
        if temp == nil
          report_dictionary[row[1]] = {
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
      for domain in report_dictionary.keys
        if report_dictionary[domain][:pageview] <= 1000
          report_dictionary[domain][:rpm] = 0
          report_dictionary[domain][:cpc] = 0
          report_dictionary[domain][:page_ctr] = 0
        end
      end
      return report_dictionary, reports
    end

    private
    def generate_report(
      startDate, endDate,
      credential_store_file = Publisher::CREDENTIAL_STORE_FILE,
      client_secrets = Publisher::CLIENT_SECRETS,
      cached_api_file = Publisher::CACHED_API_FILE)

      client = Google::APIClient.new(
        :application_name=>'Ruby AdSense for teensdigest',
        :application_version => '1.0.0')
      temp = nil
      if File.exist? credential_store_file
        File.open(credential_store_file, "r") do |f|
          temp = JSON.load(f)
          if temp["authorization_uri"].class != String
            temp["authorization_uri"] =
              "https://accounts.google.com/o/oauth2/auth"
          end
          if temp["token_credential_uri"].class != String
            temp["token_credential_uri"] =
              "https://accounts.google.com/o/oauth2/token"
          end
        end
        File.open(credential_store_file, "w") do |f|
          f.write(temp.to_json)
        end
      end
      file_storage = Google::APIClient::FileStorage.new(credential_store_file)
      if file_storage.authorization.nil?
        client_secrets = Google::APIClient::ClientSecrets.load client_secrets
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
      if File.exists? cached_api_file
        File.open(cached_api_file) do |file|
          adsense = Marshal.load(file)
        end
      else
        adsense = client.discovered_api('adsense', Publisher::API_VERSION)
        File.open(cached_api_file, 'w') do |file|
          Marshal.dump(adsense, file)
        end
      end
      result = client.execute(
        :api_method => adsense.reports.generate,
        :parameters => {
          'startDate' => startDate,
          'endDate' => endDate,
          'metric' => ['PAGE_VIEWS',
                       'CLICKS',
                       'PAGE_VIEWS_RPM',
                       'EARNINGS',
                       'COST_PER_CLICK',
                       'PAGE_VIEWS_CTR'],
          'dimension' => ['DATE', 'DOMAIN_NAME'],
          'sort' => ['+DATE']})
      puts result.data.rows.class, result.data.rows.length
      return result.data.rows, result.data.rows.length
    end
  end

  def get_domain
    if self.user != nil and self.user.super_admin?
      return get_tracking_threshold['tracking']
    end
    return self.id != 520 ?
      "aff#{self.code.to_s}.teensdigest.com": "news.teensdigest.com"
  end

  private
  def get_tracking_threshold
    return YAML.load_file("#{Rails.root}/config/tracking_threshold.yml")
  end
end
