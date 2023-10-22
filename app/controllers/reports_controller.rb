# frozen_string_literal: true

require 'uri'

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    begin
      ApplicationRecord.transaction do
        @report.save!
        save_mentions
      end
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @report.assign_attributes(report_params)

    begin
      ApplicationRecord.transaction do
        @report.save!
        save_mentions
      end
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def save_mentions
    @report.active_mentions.destroy_all if @report.active_mentions.any?
    report_ids = extract_report_ids(@report.content)
    report_ids.each do |report_id|
      Mention.create!(mentioning_report_id: @report.id, mentioned_report_id: report_id)
    end
  end

  def extract_report_ids(text, regexp = %r{http://localhost:3000/reports/(\d+)})
    text.to_s.scan(regexp).flatten.uniq
  end
end
