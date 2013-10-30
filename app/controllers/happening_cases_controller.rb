class HappeningCasesController < ApplicationController

	def update
		@happening_case = HappeningCase.find.(params[:happening_case][:id])

			double_check(@happening_case.happening) {
		@happening_case.happening.administrators.include? current_user }

		@happening_case = params[:happening_case]
		@happening_case.date_and_time = date_helper_to_str(params[:date_and_time])

			double_check(@happening_case.happening) {
		@happening_case.save }

		@happening_case.create_activity :update, owner: current_user
		
		respond_to do |format|
			format.html { redirect_to @game}
			format.js
		end
	end
end
