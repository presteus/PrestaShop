{*
* 2007-2011 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2011 PrestaShop SA
*  @version  Release: $Revision: 9795 $
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
{extends file="../helper/form/form.tpl"}

{block name="other_fieldsets"}
	{if isset($show_product_management_form)}
	<p>&nbsp;</p>

	<input type="hidden" id="product_ids" name="product_ids" value=""/>

	<fieldset>
		<legend>
			<img alt="Supplier Order Management" src="../img/admin/edit.gif">
			Ad an manage products of the current supplier Order
		</legend>

		<p class="clear">{l s='To add a product to the order, begin typing the first letters of the product name, then select the product from the drop-down list:'}</p>
		<input type="text" size="75" id="cur_product_name" />
		<span onclick="addProduct();" style="cursor: pointer;"><img src="../img/admin/add.gif" alt="{l s='Add a product to the supplier order'}" title="{l s='Add a product to the supplier order'}" /></span>

		<p>&nbsp;</p>

		<table class="table_grid">
			<tr>
				<td>
					<table
					id="products_in_supplier_order"
					class="table {if $table_dnd}tableDnD{/if}"
					cellpadding="0" cellspacing="0"
					style="width: 100%; margin-bottom:10px;"
					>
						<thead>
							<tr class="nodrag nodrop">
								<th style="width: 150px">{l s='Reference'}</th>
								<th style="width: 50px">{l s='EAN13'}</th>
								<th>{l s='Name'}</th>
								<th style="width: 100px">{l s='Unit Price TE'}</th>
								<th style="width: 100px">{l s='Quantity'}</th>
								<th style="width: 100px">{l s='Discount rate'}</th>
								<th style="width: 100px">{l s='Tax rate'}</th>
								<th style="width: 40px">{l s='Delete'}</th>
							</tr>
						</thead>
						<tbody>
							{foreach $products_list AS $product}
								<tr style="height:50px;">
									<td>
										{$product.reference}
									</td>
									<td>
										{$product.ean13}
									</td>
									<td>
										{$product.name}
									</td>
									<td class="center">
										<input type="text" name="input_unit_price_te|{$product.$id_product}_{$product.$id_product_attribute}" value="{$product.unit_price_te|escape:'htmlall':'UTF-8'}" />
									</td>
									<td class="center">
										<input type="text" name="input_quantity|{$product.$id_product}_{$product.$id_product_attribute}" value="{$product.quantity|escape:'htmlall':'UTF-8'}" />
									</td>
									<td class="center">
										<input type="text" name="input_discount_rate|{$product.$id_product}_{$product.$id_product_attribute}" value="{$product.discount_rate|escape:'htmlall':'UTF-8'}" />
									</td>
									<td class="center">
										<input type="text" name="input_tax_rate|{$product.$id_product}_{$product.$id_product_attribute}" value="{$product.tax_rate|escape:'htmlall':'UTF-8'}" />
									</td>
									<td class="center">
										<a href="#" id="deletelink|{$product.$id_product}_{$product.$id_product_attribute}" class="removeProductFromSupplierOrderLink">
											<img src="../img/admin/delete.gif" alt="{l s='Remove this product from the order'}" title="{l s='Remove this product from the order'}" />
										</a>
									</td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				</td>
			</tr>
		</table>

	</fieldset>

	<script language="javascript">
		product_infos = null;
		debug = null;
		if ($('#product_ids').val() == '')
			product_ids = [];
		else
			product_ids = $('#product_ids').val().split('|');

		function addProduct()
		{
			// check if it's possible to add the product
			if (product_infos == null || $('#cur_product_name').val() == '')
			{
				alert('{l s='Thanks to select at least one product.'}');
				return false;
			}

			// add a new line in the products table
			$('#products_in_supplier_order > tbody:last').append(
				'<tr style="height:50px;">'+
				'<td>'+product_infos.reference+'</td>'+
				'<td>'+product_infos.ean13+'</td>'+
				'<td>'+product_infos.name+'</td>'+
				'<td class="center"><input type="text" name="input_unit_price_te|'+product_infos.id+'" value="" size="8" /></td>'+
				'<td class="center"><input type="text" name="input_quantity|'+product_infos.id+'" value="" size="5" /></td>'+
				'<td class="center"><input type="text" name="input_discount_rate|'+product_infos.id+'" value="" size="5" /></td>'+
				'<td class="center"><input type="text" name="input_tax_rate|'+product_infos.id+'" value="" size="5" /></td>'+
				'<td class="center"><a href="#" class="removeProductFromSupplierOrderLink" id="deletelink|'+product_infos.id+'">'+
				'<img src="../img/admin/delete.gif" alt="{l s="Remove this product from the order"}" title="{l s="Remove this product from the order"}" />'+
				'</a></td></tr>'
			);

			// add the current product id to the product_id array - used for not show another time the product in the list
			product_ids.push(product_infos.id);

			// update the product_ids hidden field
			$('#product_ids').val(product_ids.join('|'));

			// clear the cur_product_name field
			$('#cur_product_name').val("");

			// clear the product_infos var
			product_infos = null;
		}

		/* function autocomplete */
		$(function() {
			// add click event on just created delete item link
			$('.removeProductFromSupplierOrderLink').live('click', function() {
				var id = $(this).attr('id');
				var product_id = id.split('|')[1];

				//find the position of the product id in product_id array
				var position = product_ids.indexOf(product_id);

				if (position != -1)
				{
					//remove the id from the array
					product_ids.splice(position, 1);

					// update the product_ids hidden field
					$('#product_ids').val(product_ids.join('|'));

					//remove the table row
					$(this).parents('tr:eq(0)').remove();
				}

				return false;
			});

			btn_save = $('span[class~="process-icon-save"]').parent();

			btn_save.click(function() {
				$('#supplier_order_form').submit();
			});

			// set autocomplete
			$('#cur_product_name').autocomplete("ajax_supplier_order_products_list.php", {
				delay: 100,
				minChars: 4,
				autoFill: true,
				max:20,
				matchContains: true,
				mustMatch:true,
				scroll:false,
				cacheLength:0,
	            dataType: 'json',
	            extraParams: {
	                supplier_id: '{$supplier_id}',
	            },
	            parse: function(data) {
	            	return $.map(data, function(row) {
		            	// filter the data to chaeck if the product is already added to the order
	            		if (jQuery.inArray(row.id, product_ids) == -1)
		    				return {
		    					data: row,
		    					result: row.reference + ' - ' + row.name,
		    					value: row.id
		    				}
	    			});
	            },
	    		formatItem: function(item) {
	    			return item.reference + ' - ' + item.name;
	    		}
	        }).result(function(event, item){
				product_infos = item;
			});
		});
	</script>

	{/if}
	{if isset($show_change_state_form)}
		{$state_content}
	{/if}
{/block}
