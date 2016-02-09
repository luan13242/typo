class Admin::CategoriesController < Admin::BaseController
  cache_sweeper :blog_sweeper
  
=begin
I don't know java script, so the *.js files are meaningless.
I also can't completely comprehend what new_or_edit does.
From my mind, I think what the Categories needs to do is:
1. Enter new data
2. Save the new data
3. Modify existing data
4. Save the modified data
5. Delete any data
6. Present all data

The new.html.erb is the one in all presentation view.
=end

  #def index; redirect_to :action => 'new' ; end
  def index
    @categories = Category.all
    @category = Category.new
    render 'new'
  end
  
  #def edit; new_or_edit;  end
  
=begin
Because new.html.erb is used for both display and new, and this template
specifies its action = "edit", therefore, both the display flow and
save new record flow comes to here.  I can use request.post? to see
if this is an edit/udpate.  If edit/update, save and redirect to new.
=end
  def edit

    if request.post?
      # save new or modified category

      @category = Category.find_by_id(params[:id])  #if id is set, then a record will be found, else nil
      if @category
        # name is the business key, updating business key has implication.  i guess
        # to the class, it is "to hell with it"
        if @category.update_attributes(:name => params[:category][:name], :keywords => params[:category][:keywords], :permalink => params[:category][:permalink], :description => params[:category][:description])
          flash[:notice] = "Category was successfully updated."
        else
          flash[:error] = @category.errors.full_messages
        end
      else
        @category = Category.new(params[:category])         #abandon the previous memory, ha!
        if @category.save
          flash[:notice] = "Category was successfully saved."
        else
          flash[:error] = @category.errors.full_messages
        end
      end
      redirect_to :action => 'new'
    
    else
      # show selected category
      @categories = Category.all
      @category = Category.find(params[:id])
      
      render 'new'
    end
    
  end

  def new 
    @category = Category.new
    @categories = Category.find(:all)
=begin    
    @categories = Category.find(:all)
    
    @category = case params[:category][:id]
                when nil
                  Category.new
                else
                  Category.find(params[:category][:id])
                end
    @category.attributes = params[:category]    
    

    respond_to do |format|
      format.html { new_or_edit }
      format.js { 
        @category = Category.new
      }
    end
=end
    
  end

  def destroy
    @record = Category.find(params[:id])
    return(render 'admin/shared/destroy') unless request.post?

    @record.destroy
    redirect_to :action => 'new'
  end

  private
  def new_or_edit
    @categories = Category.find(:all)
    #@category = Category.find(params[:id])
    @category = case params[:category]
                when nil
                  Category.new
                else
                  if request.post?
                    Category.new(params[:category])
                    save_category
                    return
                  end
                  Category.find(params[:category][:id])
                end    
    @category.attributes = params[:category]
    
    render 'new'
=begin    
    if request.post?
      respond_to do |format|
        format.html { save_category }
        format.js do 
          @category.save
          @article = Article.new
          @article.categories << @category
          return render(:partial => 'admin/content/categories')
        end
      end
      return
    end
=end
  end

  def save_category
    if @category.save!
      flash[:notice] = _('Category was successfully saved.')
    else
      flash[:error] = _('Category could not be saved.')
    end
    redirect_to :action => 'new'
  end

end
