  RakutenWebService.configuration do |c|
    # (Required) Appliction ID for your application.
    c.application_id = Rails.application.secrets.rakuten_application_id

    # (Optional) Affiliate ID for your Rakuten account.
    c.affiliate_id = Rails.application.secrets.rakuten_affiliate_id
  end