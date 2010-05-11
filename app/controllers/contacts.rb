class ContentSlice::Contacts < ContentSlice::Application
  # provides :xml, :yaml, :js

  def index
    only_provides :html
    @contact = Contact.new
    display @contact
  end

  def show(id)
    @contact = Contact.get(id)
    raise NotFound unless @contact
    display @contact
  end

  def new
    only_provides :html
    @contact = Contact.new
    display @contact
  end

  def edit(id)
    only_provides :html
    @contact = Contact.get(id)
    raise NotFound unless @contact
    display @contact
  end

  def create(contact)
    @contact = Contact.new(contact)
    if @contact.save
      send_mail(ContentSlice::ContactMailer, :contact_form, {
         :from => "nowy_startup@o2.pl",
         :to => 'slawosz@gmail.com',
         :subject => @contact.topic
         }, 
         { :contact => @contact}
      )
      redirect slice_url(:contacts), :message => {:notice => "Email kontaktowy został wysłany"}
    else
      message[:error] = "Problem z wysłaniem wiadomości. Przepraszamy, wkrótce to naprawimy"
      render :new
    end
  end

  def update(id, contact)
    @contact = Contact.get(id)
    raise NotFound unless @contact
    if @contact.update_attributes(contact)
       redirect resource(@contact)
    else
      display @contact, :edit
    end
  end

  def destroy(id)
    @contact = Contact.get(id)
    raise NotFound unless @contact
    if @contact.destroy
      redirect resource(:contacts)
    else
      raise InternalServerError
    end
  end

end # Contacts
