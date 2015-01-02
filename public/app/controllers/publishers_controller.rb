require 'json'

class PublishersController < ApplicationController
  layout 'trackings'

  before_filter :except => [:show, :edit, :update] do
    unless user_signed_in? && current_user.admin?
      redirect_to "/", :notice => "Please login to access this area!"
    end
  end
  before_filter :login_status, :only => [:show]
  caches_action :show, :cache_path => Proc.new { |c| c.params },
                :expires_in => 30.minute

  def index
    parse_setting()
  end

  def generate_publisher_sheet
    parse_setting()
    respond_to do |format|
      format.xlsx
    end
  end

  def show
    parse_setting()
    if @publisher == nil
      return redirect_to "/trackings/admin"
    end
    @tableData = []
    @publisher_domain = @publisher.get_domain
    if @report_dictionary != nil &&
      @report_dictionary.key?(@publisher_domain)
      for row in @data_rows
        domain = row[1]
        if domain == @publisher_domain
          @tableData.push([row[0],
                           "%.0f" % (row[2].to_f * @threshold),
                           "%.0f" % (row[3].to_f * @threshold),
                           "%.2f" % (row[5].to_f * @threshold),
          ])
        end
      end
    end
    if @tableData.size == 0
      @tableData.push([0, 0, 0, 0, 0])
    end
  end

  def update_threshold
    if !current_user.super_admin?
      redirect_to "/", :notice => "You don't have permission to access this area"
    end
    @threshold = params[:tracking][:threshold].to_f
    @tracking_domain = params[:tracking][:domain]
    new_threshold = {'threshold' => @threshold, 'tracking' => @tracking_domain}
    File.open("#{Rails.root}/config/tracking_threshold.yml", 'w') {
      |f| YAML.dump(new_threshold, f) }
    redirect_to :controller => 'publishers', :action => 'index'
  end

  def new
    @publishers = Publisher.select(:code).map {
      |n| sprintf("%04d", n.code.to_i)
    }
    @selected_code = 1
    @selected_code += 1 while @publishers.include? sprintf("%04d", @selected_code)
    @publisher = Publisher.new
  end

  def create
    @publisher = Publisher.new(params[:publisher])
    if @publisher.save
      flash[:success] = "Successfully created..."
      redirect_to publishers_path
    end
  end

  def edit
    @publisher = Publisher.find(params[:id])
    if current_user == nil || (@publisher.user_id != current_user.id && !current_user.admin?)
      redirect_to "/", :notice => "You don't have permission to access this area"
    end
  end

  def update
    @publisher = Publisher.find(params[:id])
    if @publisher.user_id != current_user.id && !current_user.admin?
      redirect_to "/", :notice => "You don't have permission to access this area"
    end
    if !current_user.admin?
      params[:publisher][:code] = @publisher.code
      params[:publisher][:user_id] = @publisher.user_id
    end
    if @publisher.update_attributes(params[:publisher])
      flash[:success] = "Successfully edited..."
      if @publisher.user_id == current_user.id
        return redirect_to publisher_path(@publisher)
      end
      return redirect_to publishers_path
    else
      return redirect_to edit_publisher_path(@publisher)
    end
  end

  def destroy
    @publisher = Publisher.find(params[:id])
    @publisher.destroy
    flash[:success] = "Successfully deleted."
    redirect_to publishers_path
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
    @tracking_threshold = get_tracking_threshold
    @threshold = @tracking_threshold['threshold'].to_f
    @tracking_domain = @tracking_threshold['tracking']
    @publishers = Publisher.all
    @report_dictionary, @data_rows =
      Publisher.generate_report_dictionary(@startDate, @endDate)
  end

  def login_status
    if params[:id] != nil
      @publisher = Publisher.find(params[:id])
      if user_signed_in?
        if !current_user.owner?(@publisher) && !current_user.admin?
          return redirect_to "/",
            :notice => "You don't have permission to access this area"
        end
      else
        return redirect_to "/",
          :notice => "You don't have permission to access this area"
      end
    else
      @publisher = current_user.publisher
    end

    if current_user != nil
      params[:user_id] = current_user.id
    end
  end
end
