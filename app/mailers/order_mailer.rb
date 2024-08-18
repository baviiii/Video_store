# app/mailers/order_mailer.rb
class OrderMailer < ApplicationMailer
  def order_receipt(email, pdf_content, order, movie_copies)
    @order = order
    @movie_copies = movie_copies
    attachments['order_receipt.pdf'] = { mime_type: 'application/pdf', content: pdf_content }
    mail(to: email, subject: 'Your Order Receipt')
  end

  def order_reminder(email, subject, body)
    @body = body
    mail(to: email, subject: subject)
  end

end



