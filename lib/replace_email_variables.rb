# frozen_string_literal: true

module ReplaceEmailVariables
  TEMAPLTE_NAME = '{{template.name}}'
  SUBMITTER_LINK = '{{submitter.link}}'
  ACCOUNT_NAME = '{{account.name}}'
  SUBMITTER_EMAIL = '{{submitter.email}}'
  SUBMISSION_LINK = '{{submission.link}}'
  DOCUMENTS_LINKS = '{{documents.links}}'

  module_function

  def call(text, submitter:)
    submitter_link =
      Rails.application.routes.url_helpers.submit_form_url(
        slug: submitter.slug, **Docuseal.default_url_options
      )

    submission_link =
      Rails.application.routes.url_helpers.submission_url(
        submitter.submission, **Docuseal.default_url_options
      )

    text = text.gsub(TEMAPLTE_NAME, submitter.template.name)
    text = text.gsub(SUBMITTER_EMAIL, submitter.email)
    text = text.gsub(SUBMITTER_LINK, submitter_link)
    text = text.gsub(SUBMISSION_LINK, submission_link)
    text = text.gsub(DOCUMENTS_LINKS, build_documents_links_text(submitter))

    text.gsub(ACCOUNT_NAME, submitter.template.account.name)
  end

  def build_documents_links_text(submitter)
    submitter.documents.map do |document|
      link =
        Rails.application.routes.url_helpers.rails_blob_url(
          document, **Docuseal.default_url_options
        )

      "#{link}\n"
    end.join
  end
end
