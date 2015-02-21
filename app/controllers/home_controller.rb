class HomeController < ApplicationController
  def index
    @sel_providers = @providers
    @selected_state = State.find_by_name(params['departamento'].try(:titleize))
    @sel_providers = @sel_providers.where(id: @selected_state.providers) if @selected_state

    # order
    name_order = params['nombre'].try(:downcase).try(:to_sym)
    @sel_providers = @sel_providers.order(nombre_completo: name_order) if [:asc, :desc].include?(name_order)

    @sel_providers = @sel_providers.includes(:provider_state_infos)
    # @lookup = State.all.inject({}) do |lookup, state|
    #   lookup.merge({ "#{state.id}" => state.providers.map(&:id) })
    # end

    respond_to do |format|
      format.html
      format.json do
        render json: {
          providers: @sel_providers,
          states: State.all.select(:id, :name, :path),
          lookup_by_state: State.all.inject({}) do |lookup, state|
            lookup.merge({ "#{state.id}" => state.providers.map(&:id) })
          end
        }.to_json
      end
    end
  end
end
