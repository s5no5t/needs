class RequirementsController < ApplicationController
  # GET /requirements
  # GET /requirements.json
  def index
    @requirements = Requirement.includes(:derived_requirements, :deriving_requirements)
                               .paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  # GET /requirements/1
  # GET /requirements/1.json
  def show
    @requirement = Requirement.includes(:derived_requirements, :deriving_requirements)
                              .find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  # GET /requirements/new
  # GET /requirements/new.json
  def new
    @requirement = Requirement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @requirement }
    end
  end

  # GET /requirements/1/edit
  def edit
    @requirement = Requirement.includes(:deriving_requirements)
                              .find(params[:id])
  end

  # POST /requirements
  # POST /requirements.json
  def create
    @requirement = Requirement.new(params[:requirement])

    respond_to do |format|
      if @requirement.save
        format.html { redirect_to @requirement, notice: 'Requirement was successfully created.' }
        format.json { render json: @requirement, status: :created, location: @requirement }
      else
        format.html { render action: "new" }
        format.json { render json: @requirement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /requirements/1
  # PUT /requirements/1.json
  def update
    @requirement = Requirement.find(params[:id])

    @requirement.title = params[:requirement][:title]
    @requirement.body = params[:requirement][:body]

    params[:requirement][:deriving_requirements] ||= {}
    update_deriving_requirements params[:requirement][:deriving_requirements].keys

    params[:requirement][:derived_requirements] ||= {}
    update_derived_requirements params[:requirement][:derived_requirements].keys

    respond_to do |format|
      if @requirement.save
        format.html { redirect_to @requirement, notice: 'Requirement was successfully updated.' }
        #format.json { head :no_content } TODO
      else
        format.html { render action: "edit" }
        #format.json { render json: @requirement.errors, status: :unprocessable_entity } TODO
      end
    end
  end

  def update_deriving_requirements ids
    deriving_relationships_before = @requirement.deriving_relationships.dup

    ids.each do |id|
      deriving_relationship = deriving_relationships_before.select {|rel| rel.deriving_requirement.id.to_s == id}.first

      if deriving_relationship
        deriving_relationships_before.delete deriving_relationship
      else
        relationship = @requirement.deriving_relationships.build
        relationship.deriving_requirement = Requirement.find(id)
      end
    end

    deriving_relationships_before.each do |rel|
      rel.destroy
    end
  end

  def update_derived_requirements ids
    derived_relationships_before = @requirement.derived_relationships.dup

    ids.each do |id|
      derived_relationship = derived_relationships_before.select {|rel| rel.derived_requirement.id.to_s == id}.first

      if derived_relationship
        derived_relationships_before.delete derived_relationship
      else
        relationship = @requirement.derived_relationships.build
        relationship.derived_requirement = Requirement.find(id)
      end
    end

    derived_relationships_before.each do |rel|
      rel.destroy
    end
  end

  # DELETE /requirements/1
  # DELETE /requirements/1.json
  def destroy
    @requirement = Requirement.find(params[:id])
    @requirement.destroy

    respond_to do |format|
      format.html { redirect_to requirements_url }
      format.json { head :no_content }
    end
  end
end
