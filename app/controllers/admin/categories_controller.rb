class Admin::CategoriesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  #def index; redirect_to :action => 'new' ; end
  def index
    redirect_to :action => 'new'
  end
  
  #def edit; new_or_edit;  end
  def edit
    #new_or_edit
    
    @category.id = 2
    @category.name = "cat"
    @category.keywords = "c"

    if @category.save
      flash[:notice] = "Category was successfully saved."
    else
      flash[:error] = "Category could not be saved."
    end
 
    redirect_to :action => 'new'
  end

  def new 
    #redirect_to :action => 'index'
    @category = Category.new
    @categories = Category.find(:all)
    @category.attributes = params[:category]
    
=begin
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
    @category = Category.find(params[:id])
    @category.attributes = params[:category]
    
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

    render 'new'
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
