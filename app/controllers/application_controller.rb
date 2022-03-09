class ApplicationController < ActionController::Base

    def index
      @tasks = Task.all
      respond_to do |format|
        format.html { render template: 'tasks/list', layout: 'layouts/application', status: 200}
      end
    end

    def page_not_found
        respond_to do |format|
          format.html { render template: 'errors/not_found_error', layout: 'layouts/application', status: 404 }
          format.all  { render nothing: true, status: 404 }
        end
    end
    
    def server_error
        respond_to do |format|
          format.html { render template: 'errors/internal_server_error', layout: 'layouts/error', status: 500 }
          format.all  { render nothing: true, status: 500}
        end
    end

end
