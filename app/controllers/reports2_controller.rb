class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.xml
  def index
    @reports = Report.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.xml
  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.xml
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.xml
  def create
    @report = Report.new(params[:report])

    respond_to do |format|
      if @report.save
        format.html { redirect_to(@report, :notice => 'Report was successfully created.') }
        format.xml  { render :xml => @report, :status => :created, :location => @report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.xml
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        format.html { redirect_to(@report, :notice => 'Report was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.xml
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to(reports_url) }
      format.xml  { head :ok }
    end
  end
  def sales_report_by_invoice
  end
  def sales_report_by_invoice1
		if(params[:from_invoice]!="")
	      sales = Sale.find(:all, :conditions=>"inv_no BETWEEN '#{params[:from_invoice]}%' and '#{params[:to_invoice]}%'")
		else
			sales = Sale.find(:all)
		end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/sales_report_invoice.pdf') do
        use_layout'app/views/reports/sales_report.tlf'
        
        start_new_page do
            
             client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Sales Report by Invoice No"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total2=0
        total1=0
            for sale in sales
               
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:date).value sale.date
                     row.item(:invno).value sale.inv_no
                     if(sale.amount!="")
                     row.item(:gross).value "%05.2f" % sale.amount
                     total=total+sale.amount
                     else
                      row.item(:gross).value "0.0"
                      total=total
                     end
                     if(sale.dis_amount!="")
                     row.item(:dis_amt).value "%05.2f" % sale.dis_amount
                     total1=total1+sale.dis_amount
                      else
                     row.item(:dis_amt).value "0.0"
                     total1=total1
                      end
                      if(sale.net_amount!="")
                     row.item(:net_amt).value "%05.2f" % sale.net_amount
                     total2=total2+sale.net_amount
                     else
                      row.item(:net_amt).value "0.0"
                      total2=total2
                    end
               
    
                  
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/sales_report_invoice/1?format=pdf") 
 end
     def sales_report_invoice

      send_file "app/views/reports/sales_report_invoice.pdf", :type => "application/pdf", :disposition => 'inline'
    end
def sales_report
end
def sales_report_1

      sales = Sale.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/sales_report1.pdf') do
        use_layout'app/views/reports/total_sales_report.tlf'
        
        start_new_page do
            client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]                
         	item(:report_name).value "Sales Report"
         	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        		total=0
        		total2=0
        		total1=0
            for sale in sales
               
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:date).value sale.date
                     row.item(:cust).value sale.customer 
                     row.item(:invno).value sale.inv_no
                     row.item(:city).value ""
                     if(sale.amount!="")
                     row.item(:gross).value "%05.2f" % sale.amount
                     total=total+sale.amount
                     else
                      row.item(:gross).value "0.0"
                      total=total
                     end
                     if(sale.dis_amount!="")
                     row.item(:dis_amt).value sale.dis_amount
                     total1=total1+sale.dis_amount
                      else
                     row.item(:dis_amt).value "0.0"
                     total1=total1
                      end
                      if(sale.net_amount!="")
                     row.item(:net_amt).value "%05.2f" % sale.net_amount
                     total2=total2+sale.net_amount
                     else
                      row.item(:net_amt).value "0.00"
                      total2=total2
                    end
               
               end
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/sales_report1/1?format=pdf") 
 end
     def sales_report1

      send_file "app/views/reports/sales_report1.pdf", :type => "application/pdf", :disposition => 'inline'
    end
    def doctor_wise_sales_report
    end
    def doctor_wise_sales
      doctor=params[:doctor]
      if(doctor!="")
       sales = Sale.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND doctor LIKE '#{params[:doctor]}'")
     else
      sales = Sale.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
    end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/doctorwise_sales_report.pdf') do
        use_layout'app/views/reports/doctorwise_sales.tlf'
        
        start_new_page do
            
              client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]              
            item(:report_name).value "Doctor Wise Sales Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total2=0
        total1=0
            for sale in sales
               
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:doctor).value sale.doctor
                     row.item(:invno).value sale.inv_no
                     
                     if(sale.amount!="")
                     row.item(:gross).value sale.amount
                     total=total+sale.amount
                     else
                      row.item(:gross).value "0.0"
                      total=total
                     end
                     if(sale.dis_amount!="")
                     row.item(:dis_amt).value sale.dis_amount
                     total1=total1+sale.dis_amount
                      else
                     row.item(:dis_amt).value "0.0"
                     total1=total1
                      end
                      if(sale.net_amount!="")
                     row.item(:net_amt).value sale.net_amount
                     total2=total2+sale.net_amount
                     else
                      row.item(:net_amt).value "0.0"
                      total2=total2
                    end
               
    
                  
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/doctorwise_sales_report/1?format=pdf") 
 end
     def doctorwise_sales_report

      send_file "app/views/reports/doctorwise_sales_report.pdf", :type => "application/pdf", :disposition => 'inline'
    end
    def monthly_sales
    end
    def monthly_sales_report
      sales = Sale.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/monthlysales.pdf') do
        use_layout'app/views/reports/monthly_sales_report1.tlf'
        
        start_new_page do
            
             client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Monthly Sales Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total2=0
        total1=0
        total3=0
        total4=0
        total5=0
            for sale in sales
               
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:date).value sale.date
                    if(sale.cr_note!="")
                     row.item(:crnt).value sale.cr_note  
                     total4=total4+sale.cr_note  
                     else
                      row.item(:crnt).value ""
                       total4=total4
                     end
                       if(sale.dr_note!="")
                     row.item(:drnt).value sale.dr_note  
                     total5=total5+sale.dr_note   
                     else
                      row.item(:drnt).value ""
                       total5=total5
                     end
                     row.item(:adj).value sale.adjust
                     if(sale.round_amt!="")
                     row.item(:round).value sale.round_amt  
                     total3=total3+sale.round_amt  
                     else
                      row.item(:round).value ""
                       total3=total3
                     end
                     if(sale.amount!="")
                     row.item(:gross).value sale.amount
                     total=total+sale.amount
                     else
                      row.item(:gross).value "0.0"
                      total=total
                     end
                     if(sale.dis_amount!="")
                     row.item(:dis_amt).value sale.dis_amount
                     total1=total1+sale.dis_amount
                      else
                     row.item(:dis_amt).value "0.0"
                     total1=total1
                      end
                      if(sale.net_amount!="")
                     row.item(:net_amt).value sale.net_amount
                     total2=total2+sale.net_amount
                     else
                      row.item(:net_amt).value "0.0"
                      total2=total2
                    end
              
               end
                grand=total+total1+total2+total3+total4+total5
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:total3).value "%05.2f" % total3
           item(:total4).value "%05.2f" % total4
           item(:total5).value "%05.2f" % total5
            item(:grand_tot).value "%05.2f" % grand
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/monthlysales/1?format=pdf") 
 end
     def monthlysales

      send_file "app/views/reports/monthlysales.pdf", :type => "application/pdf", :disposition => 'inline'
    end
    def doctorwise_purchase_sales
    end
    def doctor_wise_purchase_sales
      
      doctor=params[:doctor]
      if(doctor=="")
      sales = Sale.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
     else
       sales = Sale.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND doctor LIKE '#{params[:doctor]}'")
   
    end
     
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/doctorwise_purchase.pdf') do
        use_layout'app/views/reports/doctorwise_purchase1.tlf'
        
        start_new_page do
            
             client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Doctor Wise Product Sales Report"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total2=0
        total1=0
            for sale in sales
					for sale_child in sale.sales_children
               report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:doctor).value sale.doctor
                     row.item(:date).value sale.date
							row.item(:product).value sale_child.product_name
                     if(sale.amount!="")
                     row.item(:gross).value "%05.2f" % sale.amount
                     total=total+sale.amount
                     else
                      row.item(:gross).value "0.0"
                      total=total
                     end
                     if(sale.dis_amount!="")
                     row.item(:dis_amt).value "%05.2f" % sale.dis_amount
                     total1=total1+sale.dis_amount
                      else
                     row.item(:dis_amt).value "0.0"
                     total1=total1
                      end
                      if(sale.net_amount!="")
                     row.item(:net_amt).value "%05.2f" % sale.net_amount
                     total2=total2+sale.net_amount
                     else
                      row.item(:net_amt).value "0.0"
                      total2=total2
                    end
               
                end
	             s_no=s_no+1    
				 end
           end
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:page_no).value 1
          
           
            
    end
      
    end
    redirect_to("/reports/doctorwise_purchase/1?format=pdf") 
 end
     def doctorwise_purchase

      send_file "app/views/reports/doctorwise_purchase.pdf", :type => "application/pdf", :disposition => 'inline'
    end
    def purchase_register
    end
    def purchase_register_report
      supplier=params[:supply]
      if(supplier!="")
     purchases = PurchaseInvoice.find(:all, :conditions=>"entry_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND supply LIKE '#{params[:supply]}'")
      else
        purchases = PurchaseInvoice.find(:all, :conditions=>"entry_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'") 
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchse_register1.pdf') do
        use_layout'app/views/reports/purchase1_register.tlf'
        
        start_new_page do
            
            client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Purchase Register Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        
        total2=0
       
            for purchase in purchases
               
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:supply).value purchase.supply
                     row.item(:invno).value purchase.supply_invoice_no
                     if(purchase.net_amount!="")
                     row.item(:net_amt).value "%05.2f" % purchase.net_amount 
                     total2=total2+purchase.net_amount
                     else
                      row.item(:net_amt).value "0.00"
                      total2=total2
                    end
               
    
                  
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           
           item(:total2).value "%05.2f" % total2
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/purchse_register1/1?format=pdf") 
 end
     def purchse_register1

      send_file "app/views/reports/purchse_register1.pdf", :type => "application/pdf", :disposition => 'inline'
    end 


    def supplier_wise_purchase
    end
    def supplier_wise_purchase_report
      supplier=params[:supply]
      if(supplier!="")
     purchases = PurchaseInvoice.find(:all, :conditions=>"entry_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND supply LIKE '#{params[:supply]}'")
      else
        purchases = PurchaseInvoice.find(:all, :conditions=>"entry_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'") 
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/supplier_purchse_register1.pdf') do
        use_layout'app/views/reports/supplier_report.tlf'
        
        start_new_page do
            
             client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Supplier Wise Purchase Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total1=0
        total2=0
       
            for purchase in purchases
               
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:supply).value purchase.supply
                     row.item(:invno).value purchase.supply_invoice_no
                     row.item(:date).value purchase.entry_date

                     if(purchase.amount!="")
                     row.item(:gross).value "%05.2f" % purchase.amount
                     total=total+purchase.amount
                     else
                      row.item(:gross).value "0.0"
                      total=total
                     end
                     if(purchase.discount!="")
                     row.item(:dis_amt).value "%05.2f" % purchase.discount.to_f
                     total1=total1+purchase.discount.to_f
                      else
                     row.item(:dis_amt).value "0.0"
                     total1=total1
                      end
                      if(purchase.net_amount!="")
                     row.item(:net_amt).value "%05.2f" % purchase.net_amount
                     total2=total2+purchase.net_amount
                     else
                      row.item(:net_amt).value "0.0"
                      total2=total2
                    end
               
                
                  
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:page_no).value 1
          
           
            
    end
    end
      
    end
    redirect_to("/reports/supplier_purchse_register1/1?format=pdf") 
 end
     def supplier_purchse_register1

      send_file "app/views/reports/supplier_purchse_register1.pdf", :type => "application/pdf", :disposition => 'inline'
    end 

    def supplierwise_product_purchase
    end
    def supplier_wise_product_purchase
      sales = PurchaseInvoice.find(:all, :conditions=>"entry_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND supply LIKE '#{params[:supply]}%'")
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/supplier_wise_product.pdf') do
        use_layout'app/views/reports/supplier_wise_pp.tlf'
        
        start_new_page do
            
             client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Supplier wise Product Purchase Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total2=0
        total1=0
            for sale in sales
               
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:date).value sale.entry_date  
                     row.item(:supply).value sale.supply
                     row.item(:invno).value sale.supply_invoice_no
                     child=PurchaseInvoiceChild.find_by_id(sales[0].id)
                     if(child)
                      row.item(:product).value child.product_name  
                      row.item(:pack).value child.packing
                      row.item(:batch).value child.batch_no
                      row.item(:expdt).value "%05.2f" % child.purchase_rate   
                     if(child.received_qty!="")
                     row.item(:qty).value child.received_qty
                     total=total+child.received_qty
                     else
                      row.item(:qty).value "0.0"
                      total=total
                     end
                     if(child.free!="")
                     row.item(:free).value child.free
                     total1=total1+child.free.to_f
                      else
                     row.item(:free).value "0.0"
                     total1=total1
                      end
                      if(sale.net_amount!="")
                     row.item(:amt).value "%05.2f" % child.amount 
                     total2=total2+child.amount  
                     else
                      row.item(:amt).value "0.0"
                      total2=total2
                    end
               end
    
                  
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/supplier_wise_product/1?format=pdf") 
 end
     def supplier_wise_product

      send_file "app/views/reports/supplier_wise_product.pdf", :type => "application/pdf", :disposition => 'inline'
    end
    

    def datewise_purchase
    end
    def date_wise_purchase_report
    purchases = PurchaseInvoice.find(:all, :conditions=>"entry_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/datewise_purchase1.pdf') do
        use_layout'app/views/reports/date_wise_purchase.tlf'
        
        start_new_page do
            
             client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Datewise Purchase Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total2=0
        total1=0
        total3=0
        total4=0
        total5=0
        total6=0
            for purchase in purchases
               
                    report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:date).value purchase.entry_date
                    if(purchase.cr_note!="")
                     row.item(:crnt).value "%05.2f" % purchase.cr_note  
                     total4=total4+purchase.cr_note  
                     else
                      row.item(:crnt).value ""
                       total4=total4
                     end
                       if(purchase.dr_note!="")
                     row.item(:drnt).value "%05.2f" % purchase.dr_note  
                     total5=total5+purchase.dr_note   
                     else
                      row.item(:drnt).value ""
                       total5=total5
                     end
                     
                     row.item(:round).value "%05.2f" % purchase.round  
                     total3=total3+purchase.round  
                     
                     if(purchase.amount!="")
                     row.item(:gross).value "%05.2f" % purchase.amount
                     total=total+purchase.amount
                     else
                      row.item(:gross).value "0.0"
                      total=total
                     end
                     if(purchase.discount!="")
                     row.item(:dis_amt).value "%05.2f" % purchase.discount
                     total1=total1+purchase.discount
                      else
                     row.item(:dis_amt).value "0.0"
                     total1=total1
                      end
                     row.item(:adj).value "%05.2f" % purchase.adjust
                     total6=total6+purchase.adjust
                     
                    if(purchase.net_amount!="")
                    row.item(:net_amt).value "%05.2f" % purchase.net_amount
                     total2=total2+purchase.net_amount
                     else
                      row.item(:net_amt).value "0.0"
                      total2=total2
                    end
              
               end
                grand=total+total1+total2+total3+total4+total5+total6
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:total3).value "%05.2f" % total3
           item(:total4).value "%05.2f" % total4
           item(:total5).value "%05.2f" % total5
           item(:total6).value "%05.2f" % total6
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/datewise_purchase1/1?format=pdf") 
 end
     def datewise_purchase1

      send_file "app/views/reports/datewise_purchase1.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def productwise_stock
end
def product_wise_stock
  product1=params[:product_name]
  if(product1!="")
		sales = PurchaseInvoiceChild.find(:all, :conditions=>"created_at BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND product_name LIKE '#{params[:product_name]}'")
  else
    sales = PurchaseInvoiceChild.find(:all, :conditions=>"created_at BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")  
  end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/productwisestock.pdf') do
        use_layout'app/views/reports/product_wise_stk.tlf'
        
        start_new_page do
            
             client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Productwise Stock Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total2=0
        total1=0
            for sale in sales
               
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value sale.product_name 
                    
                     row.item(:batch).value sale.batch_no
                     row.item(:date).value sale.expiry_date
                     row.item(:rate).value "%05.2f" % sale.purchase_rate
                     row.item(:mrp).value "%05.2f" % sale.mrp
                     row.item(:pack).value sale.packing
                     row.item(:qty).value sale.available_qty
                     child=PurchaseInvoice.find_by_id(sales[0].purchase_invoice_id)
                     if(child)
                      row.item(:supply).value child.supply
                      
                     end
                total=total+sale.purchase_rate
                 total1=total1+sale.mrp
                 total2=total2+sale.available_qty 
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/productwisestock/1?format=pdf") 
 end
     def productwisestock

      send_file "app/views/reports/productwisestock.pdf", :type => "application/pdf", :disposition => 'inline'
    end

    def categorywise_stock
    end
    def category_wise_report
     	sales = PurchaseInvoiceChild.find(:all, :conditions=>"drug_type LIKE '#{params[:drug_type]}%'")
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/categorywisestock.pdf') do
        use_layout'app/views/reports/category_wise_stk.tlf'
        
        start_new_page do      
				client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]     
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
            item(:report_name).value "Category wise Stocks"
        		item(:image).value "public/images/exleaz.png"     
         	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        		total=0
        		total2=0
        		total1=0
            for sale in sales
            	report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:cate).value sale.drug_type 
                     row.item(:product).value sale.product_name
                     row.item(:qty).value sale.available_qty
                     row.item(:rate).value "%05.2f" % sale.purchase_rate
                     row.item(:mrp).value "%05.2f" % sale.mrp          
                     child=PurchaseInvoice.find_by_id(sales[0].purchase_invoice_id)
                     if(child)
                      row.item(:supply).value child.supply
                      
                     end
                		total=total+sale.purchase_rate
                 		total1=total1+sale.mrp
                 		total2=total2+sale.available_qty 
                end
				    s_no=s_no+1
				    item(:count).value s_no-1        
				    item(:total).value "%05.2f" % total
				    item(:total1).value "%05.2f" % total1
				    item(:total2).value "%05.2f" % total2
				    item(:page_no).value 1 
           end
    	end
    end
    redirect_to("/reports/categorywisestock/1?format=pdf") 
 end
     def categorywisestock

      send_file "app/views/reports/categorywisestock.pdf", :type => "application/pdf", :disposition => 'inline'
    end

    def purchase_vat
    end
    def purchase_vat_report
      
sales = PurchaseInvoice.find(:all, :conditions=>"entry_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchasevat.pdf') do
        use_layout'app/views/reports/purchasevat.tlf'
        
        start_new_page do
             client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]    
                       
            item(:report_name).value "Purchase VAT Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total2=0
        total1=0
        total3=0
        total4=0
            for sale in sales
               
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:invno).value sale.supply_invoice_no 
                     row.item(:date).value sale.entry_date
                     row.item(:city).value ""
                     row.item(:supply).value sale.supply
                     row.item(:sub).value sale.sub_total
                     row.item(:dis).value sale.discount
                     
                     row.item(:net_amt).value sale.net_amount 
                     child=PurchaseInvoiceChild.find_by_purchase_invoice_id(sales[0].id)
                     if(child)
                      row.item(:vat).value "%05.2f" % child.vat
                      total1=total1+child.vat
                        end
                 total3=total3+sale.sub_total
                 
                 total=total+sale.discount 
                 total2=total2+sale.net_amount
                end
                total4=total+total1+total2+total3
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:total3).value "%05.2f" % total3
           item(:total4).value "%05.2f" % total4
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/purchasevat/1?format=pdf") 
 end
     def purchasevat

      send_file "app/views/reports/purchasevat.pdf", :type => "application/pdf", :disposition => 'inline'
    end

  def vat_sales
  end
    def sales_vat_report
           
sales = Sale.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/salevat.pdf') do
        use_layout'app/views/reports/salesevat.tlf'
        
        start_new_page do
            
              client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]              
            item(:report_name).value "Sales VAT Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total2=0
        total1=0
        total3=0
        total4=0
            for sale in sales
               
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:invno).value sale.inv_no 
                     row.item(:date).value sale.date
                     row.item(:city).value ""
                     row.item(:cust).value sale.customer
                     row.item(:sub).value sale.sub_tot
                     row.item(:dis).value sale.dis_amount
                      row.item(:net_amt).value sale.net_amount 
                     child=SalesChild.find_by_sale_id(sales[0].id)
                     if(child)
                      row.item(:vat).value "%05.2f" % child.vat
                      total1=total1+child.vat
                        end
                 total3=total3+sale.sub_tot
                 
                 total=total+sale.dis_amount 
                 total2=total2+sale.net_amount
                end
                total4=total+total1+total2+total3
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:total3).value "%05.2f" % total3
           item(:total4).value "%05.2f" % total4
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/salevat/1?format=pdf") 
 end
     def salevat

      send_file "app/views/reports/salevat.pdf", :type => "application/pdf", :disposition => 'inline'
    end
def productwise_supplier_list
end
def purchase_supplier_report
 	sales = PurchaseInvoiceChild.find(:all, :conditions=>"product_name LIKE '#{params[:product_name]}%'")
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchasesupplier.pdf') do
        use_layout'app/views/reports/purchasesupplier.tlf'
        
        start_new_page do
            
            client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Product wise Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        
            for sale in sales
               
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value sale.product_name
                    
                     child=PurchaseInvoice.find_by_id(sales[0].purchase_invoice_id)
                     if(child)
                      row.item(:supply).value child.supply
                      row.item(:dis).value child.discount 
                      row.item(:city).value ""
                      row.item(:phone).value ""
                      total=total+child.discount
                        end
                 
                end
                
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/purchasesupplier/1?format=pdf") 
 end
     def purchasesupplier

      send_file "app/views/reports/purchasesupplier.pdf", :type => "application/pdf", :disposition => 'inline'
    end
def expiry_product_list
end
  def expiry_product_report 
  sales = PurchaseInvoiceChild.find(:all, :conditions=>"expiry_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/expirylist.pdf') do
        use_layout'app/views/reports/expirylist.tlf'
        
        start_new_page do
            
             client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end	
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Expiry Product List Report"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
            total=0
            total2=0
            total1=0
            for sale in sales
               	purchase=PurchaseInvoice.find_by_id(sale.purchase_invoice_id)
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value sale.product_name 
                     row.item(:batch).value sale.batch_no
                     row.item(:date).value sale.expiry_date
                     row.item(:cmpny).value purchase.supply
                     row.item(:mrp).value "%05.2f" % sale.mrp
                     row.item(:pack).value sale.packing
                     row.item(:qty).value sale.available_qty
                     row.item(:amt).value "%05.2f" % sale.amount 
                      total=total+sale.available_qty
                      total1=total1+sale.mrp
                      total2=total2+sale.amount  
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/expirylist/1?format=pdf") 
 end
     def expirylist

      send_file "app/views/reports/expirylist.pdf", :type => "application/pdf", :disposition => 'inline'
    end
 def payment_datewise
 end
 def payment_datewise_report
  sales = Payment.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/paymentdatewise.pdf') do
        use_layout'app/views/reports/paymentdatewise.tlf'
        
        start_new_page do
            
             client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Date wise Payments Report"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
            total=0
            total2=0
            total1=0
            total3=0
            total6=0
            for sale in sales
               
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:date).value sale.date
                     row.item(:adj).value sale.adjust
                     row.item(:round).value sale.amount
                     row.item(:gross).value sale.gross  
                     row.item(:supply).value sale.supplier
                     row.item(:net_amt).value sale.net_amount 
                     child=PaymentChild.find_by_payment_id(sale.id)
                     if(child)
                     
                     row.item(:invno).value child.supplier_invoice_no 
                     end
                      total=total+sale.gross
                      total3=total3+sale.amount
                      total2=total2+sale.net_amount 
                      total6=total6+sale.adjust 
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total3).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:total6).value "%05.2f" % total6
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/paymentdatewise/1?format=pdf") 
 end
     def paymentdatewise

      send_file "app/views/reports/paymentdatewise.pdf", :type => "application/pdf", :disposition => 'inline'
    end

    def sales_return
    end
    def sales_return_report
     sales = SaleReturn.find(:all, :conditions=>"invoice_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/salereturn.pdf') do
        use_layout'app/views/reports/salesreturn.tlf'
        
        start_new_page do
            
            client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Sale Returns Report"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
            total=0
            
            for sale in sales
               
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:date).value sale.invoice_date
                     row.item(:invno).value sale.invoice_no 
                     row.item(:city).value ""
                     row.item(:cust).value sale.customer
                     row.item(:net_amt).value sale.net_amount 
                     
                      total=total+sale.net_amount
                     
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
          
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/salereturn/1?format=pdf") 
 end
     def salereturn

      send_file "app/views/reports/salereturn.pdf", :type => "application/pdf", :disposition => 'inline'
    end
def purchase_return
end
def purchase_return_report
  sales = PurchaseReturn.find(:all, :conditions=>"entry_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchasereturn.pdf') do
        use_layout'app/views/reports/purchasereturns.tlf'
        
        start_new_page do
            
            client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Purchase Returns Report"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
            total=0
            
            for sale in sales
               
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:date).value sale.entry_date  
                     row.item(:invno).value sale.entry_no
                     row.item(:city).value ""
                     row.item(:supply).value sale.supplier  
                     row.item(:net_amt).value sale.net_amount 
                     
                      total=total+sale.net_amount
                     
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
          
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/purchasereturn/1?format=pdf") 
 end
     def purchasereturn

      send_file "app/views/reports/purchasereturn.pdf", :type => "application/pdf", :disposition => 'inline'
    end
def companywise_product
end
def company_wise_report
  code1=params[:code]
  if(code1!="")
sales = ProductMaster.find(:all, :conditions=>"company_name LIKE '#{params[:code]}'")
    else
      sales = ProductMaster.find(:all)
    end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/companywise.pdf') do
        use_layout'app/views/reports/companywiseproduct.tlf'
        
        start_new_page do
            
            client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]               
            item(:report_name).value "Company wise Product List Report"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
            total=0
            
            for sale in sales
               
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:cmpny).value sale.company_name  
                     
                     row.item(:product).value sale.name  
                     row.item(:pack).value sale.packing
                     
                end
           s_no=s_no+1
           item(:count).value s_no-1        
           
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/companywise/1?format=pdf") 
 end
     def companywise

      send_file "app/views/reports/companywise.pdf", :type => "application/pdf", :disposition => 'inline'
    end
    def customer_product_list
    end
    def customerwise_product_report
      code1=params[:code]
  		if(params[:to_date]!="")
			sales = Sale.find(:all, :conditions=>"(date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and customer LIKE '#{params[:code]}%'")
    	else
      	sales = Sale.find(:all, :conditions=>"customer LIKE '#{params[:code]}%'")
    	end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/customerwise.pdf') do
        use_layout'app/views/reports/customerwiseproduct.tlf'
        
        start_new_page do
            
            client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]              
            item(:report_name).value "Customer Product List Report"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
            total=0
            total1=0
            total2=0
            
            for sale in sales 
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:cust).value sale.customer 
                     row.item(:amt).value  "%05.2f" % sale.amount
                     row.item(:dis).value  "%05.2f" % sale.dis_amount  
                     row.item(:net_amt).value  "%05.2f" % sale.net_amount
                     child=SalesChild.find_by_sale_id(sales[0].id)
                     if(child)
                      row.item(:product).value child.product_name    
                     end
                     total2=total2+sale.net_amount
                     total1=total1+sale.dis_amount
                     total=total+sale.amount
                end
                grand_tot=total1+total+total2
           s_no=s_no+1
           item(:count).value s_no-1        
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
           item(:grand_tot).value "%05.2f" % grand_tot
           item(:page_no).value 1
          
           
            end
    end
      
    end
    redirect_to("/reports/customerwise/1?format=pdf") 
 end
     def customerwise

      send_file "app/views/reports/customerwise.pdf", :type => "application/pdf", :disposition => 'inline'
    end

	 def sales_thin_report
  		child1 = Sale.find(params[:id])
 
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/salesthin.pdf') do
        use_layout'app/views/reports/sale_18.tlf'
        
        start_new_page do
                   
      	   s_no=1
            client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]
            salechild=SalesChild.find(:all,:conditions=>"sale_id ='#{child1.id}'") 
                for child in salechild
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value child.product_name   
                     row.item(:batch).value child.batch_no
                     row.item(:expiry).value child.exp_date
                     row.item(:amt).value child.amount
                     row.item(:mfg).value ""
                     row.item(:sch).value ""
                     row.item(:qty).value child.sale_qty
                     row.item(:rate).value child.rate  
                 end  
                  s_no=s_no+1
                item(:gross).value child1.amount 
             	item(:bill).value child1.inv_no 
              	item(:patient).value child1.customer
              	item(:doctor).value child1.doctor 
               item(:date).value child1.date 
           
              end
         
    end
      
    end
    redirect_to("/reports/salesthin/1?format=pdf") 
 end
     def salesthin

      send_file "app/views/reports/salesthin.pdf", :type => "application/pdf", :disposition => 'inline'
    end

	def sales_return_thin_report
  		child1 = SaleReturn.find(params[:id])
 
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/salesthin.pdf') do
        use_layout'app/views/reports/sale_18.tlf'
        
        start_new_page do
                   
      	   s_no=1
            client_information=ClientInformation.last
				if(client_information.image_path!="")
					item(:image).value "public/images/client/#{client_information.image_path}"
				end
			   item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]
            salechild=SaleReturnChild.find(:all,:conditions=>"sale_return_id ='#{child1.id}'") 
                for child in salechild
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value child.product_name   
                     row.item(:batch).value child.batch_no
                     row.item(:expiry).value child.expiry_date
                     row.item(:amt).value child.return_amount
                     row.item(:mfg).value ""
                     row.item(:sch).value ""
                     row.item(:qty).value child.return_quantity
                     row.item(:rate).value child.return_rate  
                 end  
                  s_no=s_no+1
                item(:gross).value child1.refund_amount 
             	item(:bill).value child1.invoice_no
              	item(:patient).value child1.customer
              	item(:doctor).value child1.doctor 
               item(:date).value child1.invoice_date 
           
              end
         
    end
      
    end
    redirect_to("/reports/salesthin/1?format=pdf") 
 end
     
	def purchase_invoice_20
      
  sale = PurchaseInvoice.find_by_id(params[:id])
 
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchaseinvoice.pdf') do
        use_layout'app/views/reports/product_invoice20.tlf'
        
        start_new_page do
            client_information=ClientInformation.last
        		if(client_information.image_path!="")
          		item(:image).value "public/images/client/#{client_information.image_path}"
        		end
            item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]        
                
            s_no=1
            total=0
            total2=0
            total1=0
            purchasechild=PurchaseInvoiceChild.find(:all,:conditions=>"purchase_invoice_id='#{sale.id}'") 
               
                for child in purchasechild
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value child.product_name   
                     row.item(:batch).value child.batch_no
                     row.item(:expdt).value child.expiry_date
                     row.item(:amt).value child.amount
                     row.item(:mrp).value child.mrp
                     row.item(:vat).value child.vat
                     row.item(:mfg).value ""
                      row.item(:pack).value child.packing
                      row.item(:qty).value child.available_qty
                     row.item(:rate).value child.purchase_rate
                     
                 end  
                 s_no=s_no+1
                 item(:item_no).value s_no-1      
                item(:date).value sale.entry_date  
                item(:tin_no).value ""
                item(:name).value sale.supply
                item(:dl_no).value ""
                item(:dl).value ""
                item(:inv_no).value sale.supply_invoice_no 
                item(:total_amt).value sale.net_amount 
                item(:sub).value sale.sub_total
                item(:dis).value sale.discount
                item(:vat).value sale.total_vat
                item(:total).value sale.amount
              end
      
    end
      
    end
    redirect_to("/reports/purchaseinvoice/1?format=pdf") 
 	end


	def purchase_return_invoice_20
      
  sale = PurchaseReturn.find_by_id(params[:id])
 
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchaseinvoice.pdf') do
        use_layout'app/views/reports/product_invoice20.tlf'
        
        start_new_page do
            client_information=ClientInformation.last
        		if(client_information.image_path!="")
          		item(:image).value "public/images/client/#{client_information.image_path}"
        		end
            item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]        
                
            s_no=1
            total=0
            total2=0
            total1=0
            purchasechild=PurchaseReturnChild.find(:all,:conditions=>"purchase_invoice_child_id='#{sale.id}'") 
               
                for child in purchasechild
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value child.product_name   
                     row.item(:batch).value child.batch_no
                     row.item(:expdt).value child.expiry_date
                     row.item(:amt).value child.amount
                     row.item(:mrp).value child.purchase_rate
                     row.item(:qty).value child.return_quantity
                     row.item(:rate).value child.return_rate
                     
                 end  
                 s_no=s_no+1
                 item(:item_no).value s_no-1      
                item(:date).value sale.entry_date  
                item(:tin_no).value ""
                item(:name).value sale.supply
                item(:dl_no).value ""
                item(:dl).value ""
                item(:inv_no).value sale.supply_invoice_no 
                item(:total_amt).value sale.net_amount 
                item(:sub).value sale.sub_total
                item(:dis).value sale.discount
                item(:vat).value sale.total_vat
                item(:total).value sale.amount
              end
      
    end
      
    end
    redirect_to("/reports/purchaseinvoice/1?format=pdf") 
 	end

   def purchaseinvoice
      send_file "app/views/reports/purchaseinvoice.pdf", :type => "application/pdf", :disposition => 'inline'
    end

	 def payment_thin_report
  
  		payment = Payment.find_by_id(params[:id])
 
  		require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/payment.pdf') do
        use_layout'app/views/reports/payment21.tlf'
        
        start_new_page do
            client_information=ClientInformation.last
        if(client_information.image_path!="")
          item(:image).value "public/images/client/#{client_information.image_path}"
        end
            item(:address1).value client_information.address.split(";")[0]
            item(:address2).value client_information.address.split(";")[1]
            item(:address3).value client_information.address.split(";")[2]
            item(:address4).value client_information.address.split(";")[3]        
                
            s_no=1
            total=0
            total2=0
            total1=0
           paymentchild=PaymentChild.find(:all,:conditions=>"payment_id LIKE '#{payment.id}'") 
             
                for child in paymentchild
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:bill).value child.supplier_invoice_no   
                     row.item(:discount).value child.discount
                     row.item(:date).value child.inv_date
                     row.item(:amt).value child.amount
                     row.item(:paid).value child.received
                    
                    
                     
                 end  
                 s_no=s_no+1
                 item(:item_no).value s_no-1      
                item(:date).value payment.date  
                item(:tin).value ""
                item(:name).value payment.supplier
                item(:dl_no).value ""
                item(:pay_no).value payment.payment_no 
                item(:total).value payment.net_amount 
                item(:gross).value payment.gross
          
                item(:adj).value payment.adjust
               
              end
      
    end
      
    end
    redirect_to("/reports/payment/1?format=pdf") 
   end
     def payment

      send_file "app/views/reports/payment.pdf", :type => "application/pdf", :disposition => 'inline'
    end
end
