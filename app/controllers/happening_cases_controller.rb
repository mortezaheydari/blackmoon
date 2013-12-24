# this controller is out of use. Make sure to upload it with proper loginc before using it.
class HappeningCasesController < ApplicationController

	def update
		@happening_case = HappeningCase.find.(params[:happening_case][:id])

		if !@happening_case.happening.administrators.include? current_user; raise Errors::FlowError.new(@happening_case.happening); end

		@happening_case = params[:happening_case]
		@happening_case.date_and_time = date_helper_to_str(params[:date_and_time])

		if !@happening_case.save; raise Errors::FlowError.new(@happening_case.happening, @happening_case.errors); end

		@happening_case.create_activity :update, owner: current_user
		
		respond_to do |format|
			format.html { redirect_to @game}
			format.js
		end
	end
end
