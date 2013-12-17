module Errors

  # = Blackmoon Errors
  #
  # Generic Blackmoon exception class.
  class BlackmoonError < StandardError

    def message
      "There was a problem with your request."
    end
  end


  class FlowError < BlackmoonError
	attr_reader :redirect_object, :message

    def initialize(redirect_object= root_path, message = "There was a problem with your request")
      @redirect_object = redirect_object
      @message = message
    end

    def message
    	@message
    end

  end

end
