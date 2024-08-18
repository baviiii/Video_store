# app/jobs/order_receipt_pdf_job.rb
class OrderReceiptPdfJob < ApplicationJob
  queue_as :default

  def perform(order)
    movie_copies = order.movie_copies  # Ensure you have a relationship or method to fetch these

    # Generate the PDF using Wicked PDF
    pdf_content = ApplicationController.renderer.render(
      pdf: "receipt",
      template: "order_mailer/receipt",
      # layout: 'pdf.html',
      locals: { order: order, movie_copies: movie_copies }
    )

    # Send email with PDF attachment
    OrderMailer.order_receipt(order.user.email, pdf_content, order, movie_copies).deliver_now
  end
end
