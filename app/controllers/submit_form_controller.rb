# frozen_string_literal: true

class SubmitFormController < ApplicationController
  layout 'form'

  skip_before_action :authenticate_user!

  def show
    @submitter =
      Submitter.preload(submission: { template: { documents_attachments: { preview_images_attachments: :blob } } })
               .find_by!(slug: params[:slug])

    return redirect_to submit_form_completed_path(@submitter.slug) if @submitter.completed_at?

    cookies[:submitter_sid] = @submitter.signed_id
  end

  def update
    submitter = Submitter.find_by!(slug: params[:slug])

    Submitters::SubmitValues.call(submitter, params, request)

    head :ok
  end

  def completed
    @submitter = Submitter.find_by!(slug: params[:submit_form_slug])
  end
end
