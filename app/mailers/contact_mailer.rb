class ContentSlice::ContactMailer < Merb::MailController

#  self._template_root = ContentSlice.root / "app" / "mailers" / "views"

  def notify_on_event
    # use params[] passed to this controller to get data
    # read more at http://wiki.merbivore.com/pages/mailers
    render_mail
  end

  def contact_form
    @contact = params[:contact]
    render_mail
  end
  
end
