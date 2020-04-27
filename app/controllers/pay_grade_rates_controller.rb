class PayGradeRatesController < ApplicationController

  def index
    @pay_grade_rates = PayGradeRate.chronological.paginate(page: params[:page]).per_page(10)
  end

  def new
    @pay_grade_rate = PayGradeRate.new
  end

  def create
    @pay_grade_rate = PayGradeRate.new(pay_grade_rate_params)
    if @pay_grade_rate.save
      redirect_to pay_grade_rates_path, notice: "Successfully added #{@pay_grade_rate.rate} as an pay_grade_rate."
    else
      render action: 'new'
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  # def set_pay_grade_rate
  #   @pay_grade_rate = PayGradeRate.find(params[:id])
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pay_grade_rate_params
    params.require(:pay_grade_rate).permit(:pay_grade_id, :rate, :start_date, :end_date)
  end
end
