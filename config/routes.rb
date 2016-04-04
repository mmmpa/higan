Higan::Engine.routes.draw do
  get 'previews/:element_name/:element_id', to: 'previews#show', as: :preview

  get 'elements/:element_name', to: 'elements#show', as: :element
  post 'elements/:element_name', to: 'elements#upload'

  get 'states/index', as: :states
end
