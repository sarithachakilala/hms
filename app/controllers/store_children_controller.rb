class StoreChildrenController < ApplicationController
  # GET /store_children
  # GET /store_children.xml
  def index
  @user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
	@store_children = StoreChild.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@org.org_code}'"
	

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @store_children }
    end
  end

  # GET /store_children/1
  # GET /store_children/1.xml
  def show
    @store_child = StoreChild.find(params[:id])

	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @store_child }
    end
  end

 def show1
	@goods=Goodsrecieptnotemaster.find_by_id(params[:goods_id])
    @store_child = StoreChild.find(:all, :conditions=>"goodsrecieptnotemaster_id='#{params[:goods_id]}'")

  end

  # GET /store_children/new
  # GET /store_children/new.xml
  def new
    @store_child = StoreChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @store_child }
    end
  end

  # GET /store_children/1/edit
  def edit
	$user_id = params[:user_id]
	@user_id = params[:user_id]
	
	@org=Person.find_by_id(@user_id)
	@people=Person.find_by_id(params[:user_id])
    @store_child = StoreChild.find(params[:id])
    
  end

  # POST /store_children
  # POST /store_children.xml
  def create
    @store_child = StoreChild.new(params[:store_child])

    respond_to do |format|
      if @store_child.save
        format.html { redirect_to(@store_child, :notice => 'StoreChild was successfully created.') }
        format.xml  { render :xml => @store_child, :status => :created, :location => @store_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @store_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /store_children/1
  # PUT /store_children/1.xml
  def update
    @store_child = StoreChild.find(params[:id])

    user_id=$user_id
    respond_to do |format|
      if @store_child.update_attributes(params[:store_child])
        format.html { redirect_to(@store_child, :notice => 'StoreChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @store_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /store_children/1
  # DELETE /store_children/1.xml
  def destroy
    @store_child = StoreChild.find(params[:id])
    @store_child.destroy

    respond_to do |format|
      format.html { redirect_to(store_children_url) }
      format.xml  { head :ok }
    end
  end
end
