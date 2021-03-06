class LogsController < ApplicationController
  before_action :set_log, only: [:show, :edit, :update, :destroy]

  # GET /logs
  # GET /logs.json
  def index
    @logs = Log.where(:site=>params[:site])
    @rejected = Log.joins('logs join `logs` l2 on l2.`username` = `logs`.`username`')
      .where('logs.operation_type = \'ADD-111\' and l2.operation_type=\'REMOVE-111\' and ABS(l2.date-logs.date) < 100 and logs.site =\''+params[:site]+'\'')
  end

  # GET /logs/1
  # GET /logs/1.json
  def show
  end


  def import 
    lines = File.readlines('/var/www/digester/tmp/ccbill.log')
    lines.each do |l|
      log = Log.new
      log.create_from_array(l.split(/\|/),params[:site])
      log.save
    end
  end

  # GET /logs/new
  def new
    @log = Log.new
  end

  # GET /logs/1/edit
  def edit
  end

  # POST /logs
  # POST /logs.json
  def create
    @log = Log.new(log_params)

    respond_to do |format|
      if @log.save
        format.html { redirect_to @log, notice: 'Log was successfully created.' }
        format.json { render :show, status: :created, location: @log }
      else
        format.html { render :new }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logs/1
  # PATCH/PUT /logs/1.json
  def update
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to @log, notice: 'Log was successfully updated.' }
        format.json { render :show, status: :ok, location: @log }
      else
        format.html { render :edit }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1
  # DELETE /logs/1.json
  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to logs_url }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:operation_type, :date, :username, :second_date,  :ip, :site)
    end
end
