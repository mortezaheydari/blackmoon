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

    def initialize(redirect_object="http://localhost:3000", message="There was a problem with your request.")
      @redirect_object = redirect_object
      @message = message
    end

    def message
    	@message
    end

  end

  class ValidationError < FlowError
  end  

  class LoudMalfunction < FlowError
  end  

  class SilentMalfunction < FlowError
    def initialize(message="00000")
      @message = message
    end    
  end  
     
end
