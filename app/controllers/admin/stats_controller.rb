class Admin::StatsController < AdminController
load_and_authorize_resource  class: "Stats"
layout 'stats'    
end