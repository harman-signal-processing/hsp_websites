class Admin::DemoSongsController < AdminController
  load_and_authorize_resource
  # DELETE /admin/product_attachments/1
  # DELETE /admin/product_attachments/1.xml
  def destroy
    @demo_song.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_attachment_url(@demo_song.product_attachment)) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Deleted a demo song")
  end
end
