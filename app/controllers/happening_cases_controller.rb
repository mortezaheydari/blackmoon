class HappeningCasesController < ApplicationController

	def update
		@happening_case = HappeningCase.find.(params[:happening_case][:id])
		if @happening_case.happening.administrators.include? current_user
			@happening_case = params[:happening_case]
			@happening_case.date_and_time = date_helper_to_str(params[:date_and_time])
			double_check { @happening_case.save }
			@happening_case.create_activity :update, owner: current_user
			respond_to do |format|
	        	format.html { redirect_to @game}
	        	format.js
	        end
	    else
	    	redirect_to @happening_case.happening, notice: 'error'
	    end
    end

    private

	    def double_check(&b)
	        a = root_path
	        a = @redirect_object unless @redirect_object.nil?
	        redirect_to a, notice: 'error' and return unless b.call == true
	    end
end
