require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./assetList.db"
)

class Asset < ActiveRecord::Base
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  @title = "ホーム"
  erb :index
end

# 検索
get '/search' do
  @title = "検索"
  result = Asset.all

  if result.empty?
    print "not found\n"
  else
    
  end
  @assets = result

  erb :search
end

post '/search?:key' do
  @title = "検索"
  result = Asset.where("name like ?", "%" + params[:name] + "%").limit(30)

  if result.empty?
    print "not found\n"
  else
    
  end
  @assets = result

  erb :search
end

# 追加
get '/admin/new' do
  @title = "登録"
  erb :new
end

post '/admin/new' do
  Asset.create(
    name: params[:name],
    url: params[:url],
    tag: params[:tag],
    count: params[:count],
    memo: params[:memo],
    admin: params[:admin],
  )
  redirect '/admin/new'
end

# 更新
get '/admin/update' do
  @title = "更新"
  erb :update
end

post '/admin/update' do
  asset = Asset.find_by_id(params[:id])

  if asset.nil?
    print "not found\n"
    redirect '/admin/update'
  else
    asset.update_attributes(
      name: params[:name],
      url: params[:url],
      tag: params[:tag],
      count: params[:count],
      memo: params[:memo],
      admin: params[:admin],
      )
    redirect '/admin/update'
  end
end

# 削除
get '/admin/delete' do
  @title = "削除"
  erb :delete
end

post '/admin/delete' do
  asset = Asset.find_by_id(params[:id])

  if asset.nil?
    print "not found\n"
    redirect '/'
  else
    asset.delete
    redirect '/admin/delete'
  end
end

not_found do
  redirect '/'
end
