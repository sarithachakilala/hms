class DrugFormulasController < ApplicationController
  # GET /drug_formulas
  # GET /drug_formulas.xml
  def index
    @drug_formulas = DrugFormula.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @drug_formulas }
    end
  end

  # GET /drug_formulas/1
  # GET /drug_formulas/1.xml
  def show
    @drug_formula = DrugFormula.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @drug_formula }
    end
  end

  # GET /drug_formulas/new
  # GET /drug_formulas/new.xml
  def new
    @drug_formula = DrugFormula.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @drug_formula }
    end
  end

  # GET /drug_formulas/1/edit
  def edit
    @drug_formula = DrugFormula.find(params[:id])
  end

  # POST /drug_formulas
  # POST /drug_formulas.xml
  def create
    @drug_formula = DrugFormula.new(params[:drug_formula])
    respond_to do |format|
      if @drug_formula.save
        format.html { redirect_to("/drug_formulas/show/#{@drug_formula.id}?call_from=#{@call_from}", :notice => 'DrugFormula was successfully created.') }
        format.xml  { render :xml => @drug_formula, :status => :created, :location => @drug_formula }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @drug_formula.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /drug_formulas/1
  # PUT /drug_formulas/1.xml
  def update
    @drug_formula = DrugFormula.find(params[:id])

    respond_to do |format|
      if @drug_formula.update_attributes(params[:drug_formula])
        format.html { redirect_to(@drug_formula, :notice => 'DrugFormula was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @drug_formula.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /drug_formulas/1
  # DELETE /drug_formulas/1.xml
  def destroy
    @drug_formula = DrugFormula.find(params[:id])
    @drug_formula.destroy

    respond_to do |format|
      format.html { redirect_to(drug_formulas_url) }
      format.xml  { head :ok }
    end
  end
end
