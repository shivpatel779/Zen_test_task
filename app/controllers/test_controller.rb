class TestController < ApplicationController
    before_action :authenticate
  
  	def inbound
  		cache = ActiveSupport::Cache::MemoryStore.new(expires_in: 4.hours)
    	Rails.cache.write('to', params[:to])
    	Rails.cache.write('from', params[:from])

  		if params[:to].present? && params[:from].present?
          phone_number = PhoneNumber.find_by(number: params[:to])
          
          if params[:to].length < 6 ||  params[:to].length > 16 
          	render :json => {:message => "", :error => "to parameter is invalid"}
          elsif params[:from].length < 6 ||  params[:from].length > 16 
          	render :json => {:message => "", :error => "from parameter is invalid"}
          elsif phone_number.present?
          	render :json => {:message => "inbound sms ok", :error => ""}		
          else
          	render :json => {:message => "", :error => "to parameter is not found"}	
          end

  		elsif (params[:to].present? && !params[:from].present?)
  			render :json => {:message => "", :error => "parameter from is missing"}
  		elsif (params[:from].present? && !params[:to].present?)
  			render :json => {:message => "", :error => "parameter to is missing"}	
  		end
  	end

  	def outbound

  		if params[:to].present? && params[:from].present?

  			phone_number = PhoneNumber.find_by(number: params[:from])

  			if params[:to].length < 6 ||  params[:to].length > 16 
        		render :json => {:message => "", :error => "#{params[:to]} parameter is invalid"}
        	elsif params[:from].length < 6 &&  params[:from].length < 16 
        		render :json => {:message => "", :error => "#{params[:from]} parameter is invalid"}
  			elsif params[:to] ==  Rails.cache.fetch('to') && params[:from] == Rails.cache.fetch('from')
  				render :json => {:message => "", :error => "sms from #{params[:from]} to #{params[:to]} blocked by STOP request"}
            elsif !phone_number.present?
          		render :json => {:message => "", :error => "from parameter not found"}
  			end

  		elsif params[:to].nil? && params[:from].nil?
  			render :json => {:message => "", :error => "parameter to & from is missing"}

  		elsif (params[:to].present? && !params[:from].present?)
  			render :json => {:message => "", :error => "parameter from is missing"}

  		elsif (params[:from].present? && !params[:to].present?)
  			render :json => {:message => "", :error => "parameter to is missing"}	
  		end	
  	end

  	private
  	def authenticate
  		user, pass = ActionController::HttpAuthentication::Basic::user_name_and_password(request)
  		if [user, pass].any?
        else 
          render :json => {:status => 403}

        end  		
  	end
end
