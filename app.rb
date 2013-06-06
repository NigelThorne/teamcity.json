require 'rubygems'
require 'sinatra'
require 'json'
require 'crack'
require 'nokogiri'
require 'open-uri'

SITE = "http://teamcity:8000" 
URL = SITE + "/guestAuth/app/rest/"

get '/projects' do 
    content_type :json
    data = open(URL + "projects", {'Accept' => "application/json"}).read
    data
end

get "/projects/:id" do |id|
    content_type :json

    data = open(URL + "projects/id:#{id}/buildTypes", {'Accept' => "application/json"}).read
    buildTypes = Crack::JSON.parse(data) || {}

    buildTypes["buildType"].each do |build|
        
      json = open(SITE + build["href"] + "/builds/", {'Accept' => "application/json"}).read
    
      build["history"] = Crack::JSON.parse(json)["build"]
    end

    buildTypes.to_json
end


get '/' do 
    erb :index
end

