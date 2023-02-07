using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_Store_SetLowStock : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            //BindCategory();
            BindCategory();

        }
    }
    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCategory.SelectedIndex != 0)
        {
            ddlSubCategory.Items.Clear();
            ddlSubCategory.Items.AddRange(LoadItems(CreateStockMaster.LoadSubCategoryByCategory(ddlCategory.SelectedValue)));
              ddlSubCategory.DataTextField = "DisplayName";
              ddlSubCategory.DataValueField = "SubCategoryID";
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Insert(0, new ListItem("ALL", "0"));
            if (ddlSubCategory.Items != null)
            {
                ddlSubCategory.SelectedIndex = 0;

            }
            ddlSubCategory.Enabled = true;
            btnSave.Enabled = true;



        }
        else { ddlSubCategory.Enabled = false; }
        BindItem();
    }
    public ListItem[] LoadItems(DataTable str)
    {
        try
        {
            ListItem[] Items = new ListItem[str.Rows.Count];

            for (int i = 0; i < str.Rows.Count; i++)
            {
                Items[i] = new ListItem(str.Rows[i][2].ToString(), str.Rows[i][0].ToString());
            }

            return Items;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }
    private void BindItem()
    {
        DataTable dtItem = new DataTable();
        if (ddlCategory.SelectedValue == "5")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(IM.Typename,'#',IFNULL(IM.ItemCatalog,''))ItemName, ");
            sb.Append(" CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IF(IFNULL(fid.minorUnit,'')='',IFNULL(IM.UnitType,''),fid.minorUnit) ,'#', ");
            sb.Append(" IF(IFNULL(fid.MajorUnit,'')='',im.MajorUnit,fid.MajorUnit) ,'#', ");
            sb.Append(" IF(IFNULL(fid.MinLevel,'')='',im.MinLevel,fid.MinLevel),'#',IF(IFNULL(fid.MaxLevel,'')='',im.MaxLevel,fid.MaxLevel),'#', ");
            sb.Append(" IF(IFNULL(fid.ReorderLevel,'')='',im.ReorderLevel,fid.ReorderLevel),'#',IF(IFNULL(fid.ReorderQty,'')='',im.ReorderQty,fid.ReorderQty),'#', ");
            sb.Append(" IF(IFNULL(fid.Rack,'')='',IFNULL(im.Rack,''),fid.Rack) ,'#',IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf),'#', ");
            sb.Append(" IF(IFNULL(fid.maxreorderqty,'')='',im.maxreorderqty,fid.maxreorderqty),'#',IF(IFNULL(fid.minreorderqty,'')='',im.minreorderqty,fid.minreorderqty),'#',");
            sb.Append(" IF(IFNULL(fid.ConversionFactor,'')='',im.ConversionFactor,fid.ConversionFactor) ");
            
            
            sb.Append(",'#' )ItemID ");
            sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
            sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID  ");
            sb.Append(" LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID = im.itemID   and fid.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'");
            sb.Append("  ");
            if (ddlCategory.SelectedValue == "LSHHI5")
            {
                sb.Append(" WHERE CR.ConfigID = 11 AND im.IsActive=1  ");
            }
            else if (ddlCategory.SelectedValue == "8")
            {
                sb.Append(" WHERE CR.ConfigID = 28 AND im.IsActive=1  ");
            }
            if (ddlSubCategory.SelectedItem.Text != "ALL")
            {
                sb.Append("  and sm.Subcategoryid='" + ddlSubCategory.SelectedValue + "'");
            }
            sb.Append("  GROUP BY im.Typename order by IM.Typename  ");

            dtItem = StockReports.GetDataTable(sb.ToString());
        }
        //else if (ddlCategory.SelectedValue == "LSHHI8")
        //{
        //    StringBuilder sb = new StringBuilder();
        //    sb.Append("SELECT CONCAT(IM.Typename,'#',IFNULL(IM.ItemCatalog,''))ItemName, ");
        //    sb.Append(" CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(IM.UnitType,''),'#',IFNULL(ls.MinLevel,''),'#',IFNULL(ls.MaxLevel,''),'#',IFNULL(ls.ReorderLevel,''),'#',IFNULL(ls.ReorderQty,''),'#',IFNULL(ls.Rack,''),'#',IFNULL(ls.Self,''),'#' )ItemID ");
        //    sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
        //    sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID ");
        //    sb.Append(" LEFT JOIN f_LowStock ls ON ls.itemID = im.itemID and ls.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
        //    sb.Append(" AND ls.itemID = im.ItemID ");
        //    sb.Append(" WHERE CR.ConfigID = 28 AND im.IsActive=1 ");
        //    if (ddlSubCategory.SelectedItem.Text != "ALL")
        //    {
        //        sb.Append("  and sm.Subcategoryid='" + ddlSubCategory.SelectedValue + "'");
        //    }
        //    sb.Append("  order by IM.Typename  ");
        //    dtItem = StockReports.GetDataTable(sb.ToString());

        //}


        if (dtItem.Rows.Count > 0)
        {
            listItem.DataSource = dtItem;
            listItem.DataTextField = "ItemName";
            listItem.DataValueField = "ItemID";
            listItem.DataBind();
        }
        else
        {
            listItem.Items.Clear();
            listItem.Items.Add("No Item Found");

        }


    }
    private void BindCategory()
    {
        string strQuery = "";
        strQuery = "SELECT cat.Name,cat.CategoryID from f_categorymaster cat inner join f_configrelation conf on conf.CategoryID=cat.CategoryID where conf.ConfigID in (11,28)";


        DataTable Items = StockReports.GetDataTable(strQuery);
        ddlCategory.DataSource = Items;
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataValueField = "CategoryID";
        ddlCategory.DataBind();
        //ddlCategory.SelectedIndex = 0;
        ddlCategory.Items.Insert(0, "Select");
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (listItem.SelectedIndex > -1)
        {
            string itemid = listItem.SelectedValue.Split('#')[0].ToString();
            string subcategoryid = listItem.SelectedValue.Split('#')[1].ToString();
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
               // MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE From f_LowStock where DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'AND Itemid='" + itemid.Trim() + "' ");
                string id = "";
                int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_itemmaster_deptWise Where ItemID = '" + itemid.Trim() + "' AND DeptLedgerNo='" + ViewState["DeptLedgerNo"] + "' AND CentreID='" + Session["CentreID"] + "' "));
                if (count > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_itemmaster_deptWise SET MaxLevel='" + txtMax.Text.Trim() + "',MinLevel='" + txtmin.Text.Trim() + "',ReorderLevel='" + txtReorderLevel.Text.Trim() + "', ReorderQty='" + txtReorderQty.Text.Trim() + "', " +
                        " MaxReorderQty='" + listItem.SelectedValue.Split('#')[10].ToString() + "',MinReorderQty='" + listItem.SelectedValue.Split('#')[11].ToString() + "',majorUnit='" + listItem.SelectedValue.Split('#')[3].ToString() + "',minorUnit='" + listItem.SelectedValue.Split('#')[2].ToString() + "', "+
                        " ConversionFactor=" + listItem.SelectedValue.Split('#')[12].ToString() + ",SubCategoryID ='" + subcategoryid + "',UpdatedBy='" + ViewState["ID"].ToString() + "',UpdatedDate=NOW() ,"+
                        " Rack='" + txtRack.Text.Trim() + "',Shelf='" + txtShelf.Text.Trim() + "' " +
                        " Where ItemID = '" + itemid.Trim() + "' AND DeptLedgerNo='" + ViewState["DeptLedgerNo"] + "' AND CentreID='" + Session["CentreID"] + "'");
                }

                else
                {
                    itemmaster_deptWise imd = new itemmaster_deptWise(tnx);
                    imd.ItemID = itemid.Trim();
                    imd.DeptLedgerNo = Util.GetString(ViewState["DeptLedgerNo"]);
                    imd.MaxLevel = Util.GetDecimal(txtMax.Text.Trim());
                    imd.MinLevel = Util.GetDecimal(txtmin.Text.Trim());
                    imd.ReorderLevel = Util.GetDecimal(txtReorderLevel.Text.Trim());
                    imd.ReorderQty = Util.GetDecimal(txtReorderQty.Text.Trim());
                    imd.MaxReorderQty = Util.GetDecimal(listItem.SelectedValue.Split('#')[10].ToString());
                    imd.MinReorderQty = Util.GetDecimal(listItem.SelectedValue.Split('#')[11].ToString());
                    imd.majorUnit = Util.GetString(listItem.SelectedValue.Split('#')[3].ToString());
                    imd.minorUnit = Util.GetString(listItem.SelectedValue.Split('#')[2].ToString());
                    imd.ConversionFactor = Util.GetDecimal(listItem.SelectedValue.Split('#')[12].ToString());
                    imd.SubCategoryID = Util.GetString(subcategoryid); ;
                    imd.CreatedBy = Util.GetString(ViewState["ID"].ToString());
                    imd.ipAddress = HttpContext.Current.Request.UserHostAddress;
                    imd.Rack = Util.GetString(txtRack.Text.Trim());
                    imd.Shelf = Util.GetString(txtShelf.Text.Trim());
              
                   id =imd.Insert();
                }

                if(id!="")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE f_itemmaster_deptWise set CentreID='" + Session["CentreID"] + "' WHERE ID="+id+" ");
                }

              //  MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into f_LowStock(DeptLedgerNo,Itemid,Minlevel,MaxLevel,ReorderLevel,ReorderQty,Category,SubCategoryID,CreaterID) values('" + ViewState["DeptLedgerNo"].ToString() + "','" + itemid.Trim() + "','" + txtmin.Text.Trim() + "','" + txtMax.Text.Trim() + "','" + txtReorderLevel.Text.Trim() + "','" + txtReorderQty.Text.Trim() + "','" + ddlCategory.SelectedValue + "','" + subcategoryid + "','" + ViewState["ID"].ToString() + "')");
                lblMsg.Text = "Record Saved Successfully";
                tnx.Commit();
                BindItem();
                Clear();
            }
            catch (Exception ex)
            {
                tnx.Rollback();

                lblMsg.Text = ex.Message;
                ClassLog c1 = new ClassLog();
                c1.errLog(ex);
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }

    }
    protected void ddlSubCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
    }


    private void Clear()
    {
        txtReorderQty.Text = "";
        txtReorderLevel.Text = "";
        txtmin.Text = "";
        txtMax.Text = "";
        txtShelf.Text = "";
        txtRack.Text = "";
    }
}