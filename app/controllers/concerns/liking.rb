=begin
module Liking
  extend ActiveSupport::Concern

  included do
    ThisClass = set_this_class
    def like
      
      @this = ThisClass.find(params[:id])

      if current_user.flagged?(@this, :like)
        current_user.unflag(@this, :like)
        msg = "you now don't like this event."
      else
        current_user.flag(@this, :like)
        msg = "you now like this event."
      end

      set_this_variable

      respond_to do |format|
          format.html { redirect_to @event}
          format.js
      end
    end

    def like_cards
  
      @this = ThisClass.find(params[:id])

      # current_user.unflag(@event, :like)
      current_user.toggle_flag(@this, :like)

      set_this_variable

      respond_to do |format|
          format.js { render 'shared/offering/like_cards', :locals => { offering: @this, style_id: params[:style_id], class_name: params[:class_name] } }
      end
    end

  end

end
=end
