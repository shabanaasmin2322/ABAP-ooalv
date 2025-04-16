DATA: gv_container TYPE REF TO cl_gui_custom_container,
     GV_GRID TYPE REF TO CL_GUI_ALV_GRID.
MODULE status0200 OUTPUT.
  IF GV_CONTAINER IS NOT BOUND.
  SET PF-STATUS 'STATUS_200'.
  CREATE OBJECT gv_container
    EXPORTING
      container_name              = 'CUST_CNTRL2'.
  IF SY-SUBRC = 0.
    CREATE OBJECT gv_grid
      EXPORTING
        i_parent          = GV_CONTAINER.
  ENDIF.
  if lt_vbak is not initial.
    CALL METHOD gv_grid->set_table_for_first_display
      EXPORTING
        i_structure_name              =  'ZCVBAK'
      CHANGING
        it_outtab                     =  lt_vbak.
  else.
    message 'No sale order found for this customer' type 'I'.
  endif.
  ENDIF.

ENDMODULE.

MODULE user_command_0200 INPUT.
CASE SY-UCOMM.
  WHEN 'BACK'.
    LEAVE TO SCREEN 100.
ENDCASE.
ENDMODULE.