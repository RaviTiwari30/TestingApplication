<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SetLowStock.aspx.cs" Inherits="Design_Store_SetLowStock" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        function MoveUpAndDownText(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                ///__doPostBack('ListBox1','')
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;

                            return;
                        }
                    }

                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }

                    //listbox.options[0].selected=true;
                }

            }
        }
        function loadDetail(str) {
            if (str != "0") {
                var val = str.split('#');
                document.getElementById('<%=txtMax.ClientID %>').value = val[5];
                document.getElementById('<%=txtmin.ClientID %>').value = val[4];
                document.getElementById('<%=txtReorderLevel.ClientID %>').value = val[6];
                document.getElementById('<%=txtReorderQty.ClientID %>').value = val[7];
                document.getElementById('<%=txtRack.ClientID %>').value = val[8];
                document.getElementById('<%=txtShelf.ClientID %>').value = val[9];
            }

        }
        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                //alert(textbox2.value);
                //var f = document.theSource;
                //var listbox = f.measureIndx;
                //var textbox = f.measure_name;
                var listbox = listbox2;
                var textbox = textbox2;

                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].text.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }

                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }

        }
        function Validate() {
            if ($('#<%=ddlCategory.ClientID %>').val() == "Select") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Category');
                $('#<%=ddlCategory.ClientID %>').focus();
                return false;
            }
            if ($('#<%=listItem.ClientID %>').val() == null) {
                $("#<%=lblMsg.ClientID %>").text('Please Select Item ');
                $('#<%=listItem.ClientID %>').focus();
                return false;
            }
            if ($('#<%=txtmin.ClientID %>').val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Min. Level');
                $('#<%=txtmin.ClientID %>').focus()
                return false;
            }
            if ($('#<%=txtMax.ClientID %>').val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Max. Level');
                $('#<%=txtMax.ClientID %>').focus();
                return false;
            }
            if ($('#<%=txtReorderLevel.ClientID %>').val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Reorder Level');
              $('#<%=txtReorderLevel.ClientID %>').focus();
              return false;
          }
          if ($('#<%=txtReorderQty.ClientID %>').val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Reorder Quantity');
              $('#<%=txtReorderQty.ClientID %>').focus();
              return false;
          }
          if ($('#<%=txtRack.ClientID %>').val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Rack Name');
              $('#<%=txtRack.ClientID %>').focus();
              return false;
          }
          if ($('#<%=txtShelf.ClientID %>').val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Shelf Name');
              $('#<%=txtShelf.ClientID %>').focus();
              return false;
          }
          if (Number($('#<%=txtmin.ClientID %>').val()) > Number($('#<%=txtMax.ClientID %>').val())) {
                alert('Max. Level Should Be Greater Than Min. Level');
                return false;
            }
            if (Number($('#<%=txtReorderLevel.ClientID %>').val()) < Number($('#<%=txtmin.ClientID %>').val())) {
                alert('Reorder Level Should Be between Min. Level or Max. Level');
                return false;
            }
            if (Number($('#<%=txtReorderLevel.ClientID %>').val()) > Number($('#<%=txtMax.ClientID %>').val())) {
                alert('Reorder Level Should Be between Min. Level or Max. Level');
                return false;
            }
            if (Number($('#<%=txtReorderQty.ClientID %>').val()) > Number($('#<%=txtMax.ClientID %>').val())) {
                alert('Reorder Qty. Should Not Be Greater Than Max. Level');
                return false;
            }
            if (Page_IsValid) {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            }
            else {
                document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
            }
        }

        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
    </script>


    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">

            <div style="text-align: center;">
                <b>Set Low Stock</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Set Low Stock
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" ID="ddlCategory" CssClass="requiredField" Width=""
                                OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" AutoPostBack="True">
                            </asp:DropDownList>
                            <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSubCategory" runat="server" Width=""
                                OnSelectedIndexChanged="ddlSubCategory_SelectedIndexChanged" AutoPostBack="True">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSearch" runat="server" AutoCompleteType="disabled"
                                onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_listItem);"
                                onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_listItem);"
                                Width="" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:ListBox ID="listItem" runat="server" CssClass="ItDoseDropdownbox" Width="566px" onChange="loadDetail(this.value);"
                                Height="121px"></asp:ListBox>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Min. Level
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtmin" CssClass="ItDoseTextinputNum requiredField" runat="server" Width="" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtmin" ValidChars="." />
                            <asp:Label ID="lblV0" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                            <asp:RequiredFieldValidator ID="reqMin" runat="server" ValidationGroup="Save" ErrorMessage="*"
                                Display="None" ControlToValidate="txtmin"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Max. Level
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMax" runat="server" Width="" CssClass="ItDoseTextinputNum requiredField" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtMax" ValidChars="." />
                            <asp:Label ID="lblV1" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Reorder Level
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReorderLevel" CssClass="ItDoseTextinputNum requiredField" runat="server" Width="" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtReorderLevel" ValidChars="." />
                            <asp:Label ID="lblV2" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Reorder Qty.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReorderQty" CssClass="ItDoseTextinputNum requiredField" runat="server" Width="" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtReorderQty" ValidChars="." />
                            <asp:Label ID="lblV3" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Rack Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRack" CssClass="requiredField" runat="server" Width=""></asp:TextBox>
                            <asp:Label ID="lblV4" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Shelf Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtShelf" CssClass="requiredField" runat="server" Width=""></asp:TextBox>
                            <asp:Label ID="lblV5" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" Text="Save" ClientIDMode="Static" ValidationGroup="Save"
                    CssClass="ItDoseButton" OnClick="btnSave_Click" UseSubmitBehavior="false" OnClientClick="javascript:return Validate();" CausesValidation="false" />&nbsp;&nbsp;&nbsp;&nbsp;
            </div>
        </div>


    </div>
</asp:Content>


