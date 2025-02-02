class CompaniesController < ApplicationController
  before_action :set_industries, only: [:new, :edit, :show, :create]
  before_action :set_users, only: [:new, :create, :edit, :update]
  load_and_authorize_resource

  # GET /companies
  # GET /companies.json
  def index
    @companies = current_user.admin? ? Company.includes(:industry).active : current_user.plants.includes(company: [:industry]).map(&:company)
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @plants = @company.plants.active
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit; end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to new_company_plant_path(@company), notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.inactive!
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_industries
    @industries = Industry.all_names
  end

  def set_users
    @users = User.filtered.active.sort_by_id
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:active, :name, :taxid, :industry_id, :contact_id, :bf_contact_id)
  end
end
