class ItemsController < ApplicationController
  before_action :index_category_set, only: :index
  before_action :set_item, only: [:edit, :update]


  def index
    @images = Image.all
    @categories = Category.where('ancestry IS NULL')
    @items = Item.where(status: 1).order('created_at ASC')
  end

  def show
  end

  def new
    @item = Item.new
    @item.images.new
    # @item.users << current_user
  end

  def create
    # ステータスの状態を「出品中：１」にして登録する
    @status = 1
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    # ステータスの状態を「出品中：１」にして登録する
    @status = 1
    if @item.update(item_params)
      redirect_to item_path(@item), notice: '出品情報を更新しました'
    else
      render :edit
    end
  end
  
  private
  def item_params
    # 仮でユーザーIDを１にしている
    params.require(:item).permit(:name, :explanation, :category_id, :size, :brand_name, :condition_id, :status_id, :delivery_fee_id, :prefecture_id, :delivery_day_id, :price, images_attributes: [:image]).merge(user_id: 1,status_id: @status) 
  end

  def index_category_set
    search_anc = Category.where('ancestry IS NULL')
    array = []
    search_anc.each do |i|
      array << i[:id]
    end
    for num in array do
      search_anc = Category.where('ancestry LIKE(?)', "#{num}%")
      ids = []
      search_anc.each do |i|
        ids << i[:id]
      end
      items = Item.where(category_id: ids).order("id DESC").limit(10)
      instance_variable_set("@cat_no#{num}", items)
    end
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
