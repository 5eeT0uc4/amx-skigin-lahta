PROGRAM_NAME='Main_Exp'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)

#include 'SqueezeBox.axi'
#include 'iPort_Variables.axi'


DEFINE_DEVICE

dvDebug				= 0:0:0

//Panels
dvPanel_1			= 10001:1:1 // iPad Hall 1-st Floor
dvPanel_2			= 10002:1:1 // iPad Hall 2-nd Floor
dvPanel_3			= 10003:1:1 // Skigin iPhone
dvPanel_4			= 10004:1:1 // Oter iPhone
dvPanel_5			= 10005:1:1 // Robik iPhone
dvPanel_6			= 10006:1:1 // iPod Touch Red 2
dvPanel_7			= 10007:1:1 // Gena
dvPanel_8			= 10008:1:1 // Marianna
dvPanel_9			= 10009:1:1 // iPod Touch Blue 1
dvPanel_10			= 10010:1:1 // iPod Touch Blue 2
dvPanel_11			= 10011:1:1 // 
dvPanel_12			= 10012:1:1 // iPad Mini Robik Black
dvPanel_13			= 10013:1:1 // Oter iPad 3
dvPanel_14			= 10014:1:1 // iPad2 Home White 
dvPanel_15			= 10015:1:1 // iPad Mini 1
dvPanel_16			= 10016:1:1 // iPad Mini 2
dvPanel_17			= 10017:1:1 // iPod Touch Blue 3
dvPanel_18			= 10018:1:1 // iPod Touch Blue 4
dvPanel_19			= 10019:1:1 // iPod Touch Red 1
dvPanel_20			= 10020:1:1 // 

//SqueezeBox
dvSqueezeServer_1		= 0:3:0
dvSqueezeServer_2		= 0:4:0
dvSqueezeServer_3		= 0:5:0
dvSqueezeServer_4		= 0:6:0
dvSqueezeServer_5		= 0:7:0
dvSqueezeServer_6		= 0:8:0

//Sonance iPort FS-23 Devices
dvSonance_iPort_1		= 0:9:0
dvSonance_iPort_2		= 0:10:0
dvSonance_iPort_3		= 0:11:0
dvSonance_iPort_4		= 0:12:0
dvSonance_iPort_5		= 0:13:0

//vdvSqueeze
vdvSqueezeServer_1		= 33001:1:3
vdvSqueezeServer_2		= 33002:1:3
vdvSqueezeServer_3		= 33003:1:3
vdvSqueezeServer_4		= 33004:1:3
vdvSqueezeServer_5		= 33005:1:3
vdvSqueezeServer_6		= 33006:1:3


//Sonance iPort
vdvSonance_iPort_1		= 33010:1:3
vdvSonance_iPort_2		= 33011:1:3
vdvSonance_iPort_3		= 33012:1:3
vdvSonance_iPort_4		= 33013:1:3
vdvSonance_iPort_5		= 33014:1:3


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

MAX_PANELS = 16
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile dev		g_dvaPanels[MAX_PANELS]		= { dvPanel_1, dvPanel_2, dvPanel_3, dvPanel_4, dvPanel_5,
							    dvPanel_6, dvPanel_7, dvPanel_8, dvPanel_9, dvPanel_10,
							    dvPanel_11, dvPanel_12, dvPanel_13, dvPanel_14, dvPanel_15,
							    dvPanel_16 }

volatile char		g_caHost_iPort_1[]	= '10.98.253.86' // Dining 
volatile char		g_caHost_iPort_2[]	= '10.98.253.87' // Salon
volatile char		g_caHost_iPort_3[]	= '10.98.253.88' // Oriental
volatile char		g_caHost_iPort_4[]	= '10.98.253.89' // Massage
//volatile char		g_caHost_iPort_5[]	= '10.98.253.90' // Anna Living
volatile long		g_lPort_iPort		= 47678

//Squeeze
volatile char		m_caSqueezeHost[]		= '10.98.253.101' //Squeeze Server Host
volatile char		g_caSqueezePlayerID_1[] 	= '00:00:00:00:01:00' // Player ID
volatile char		g_caSqueezePlayerID_2[] 	= '00:00:00:00:01:01' // Player ID
volatile char		g_caSqueezePlayerID_3[] 	= '00:00:00:00:02:00' // Player ID
volatile char		g_caSqueezePlayerID_4[] 	= '00:00:00:00:02:01' // Player ID
volatile char		g_caSqueezePlayerID_5[] 	= '00:00:00:00:03:00' // Player ID
volatile char		g_caSqueezePlayerID_6[] 	= '00:00:00:00:03:01' // Player ID
volatile integer	m_iSqueezeCoverPort		= 9001 // CoverArt Port
volatile integer	m_iSqueezeCLIPort		= 9090 // CLI Port

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

set_pulse_time(1)

//
send_command vdvSqueezeServer_1, 'CONNECT;'
//send_command vdvSqueezeServer_2, 'CONNECT;'
//send_command vdvSqueezeServer_3, 'CONNECT;'
//send_command vdvSqueezeServer_4, 'CONNECT;'
//send_command vdvSqueezeServer_5, 'CONNECT;'
//send_command vdvSqueezeServer_6, 'CONNECT;'

//Sonance iPort FS-23
//DEFINE_MODULE 'iPort_IP_Multi'			modiPortMulti_1(dvSonance_iPort_1, vdvSonance_iPort_1, dvIPORT_1_TPs, g_caHost_iPort_1, g_lPort_iPort)
//DEFINE_MODULE 'iPort_IP_Multi'			modiPortMulti_2(dvSonance_iPort_2, vdvSonance_iPort_2, dvIPORT_2_TPs, g_caHost_iPort_2, g_lPort_iPort)
//DEFINE_MODULE 'iPort_IP_Multi'			modiPortMulti_3(dvSonance_iPort_3, vdvSonance_iPort_3, dvIPORT_3_TPs, g_caHost_iPort_3, g_lPort_iPort)
//DEFINE_MODULE 'iPort_IP_Multi'			modiPortMulti_4(dvSonance_iPort_4, vdvSonance_iPort_4, dvIPORT_4_TPs, g_caHost_iPort_4, g_lPort_iPort)

//SqueezeBox Modules
DEFINE_MODULE 'Squeezebox_Comm'			modSquezeboxTCP1(vdvSqueezeServer_1, 
								dvSqueezeServer_1, 
								g_dvaSqueezePanels_1,
								g_dvaPanels,
								g_caSqueezePlayerID_1,
								m_caSqueezeHost, 
								m_iSqueezeCLIPort, 
								m_iSqueezeCoverPort)
/*
DEFINE_MODULE 'Squeezebox_Comm'			modSquezeboxTCP2(vdvSqueezeServer_2, 
								dvSqueezeServer_2, 
								g_dvaSqueezePanels_2,
								g_dvaPanels,
								g_caSqueezePlayerID_2,
								m_caSqueezeHost, 
								m_iSqueezeCLIPort, 
								m_iSqueezeCoverPort)

DEFINE_MODULE 'Squeezebox_Comm'			modSquezeboxTCP3(vdvSqueezeServer_3, 
								dvSqueezeServer_3, 
								g_dvaSqueezePanels_3,
								g_dvaPanels,
								g_caSqueezePlayerID_3,
								m_caSqueezeHost, 
								m_iSqueezeCLIPort, 
								m_iSqueezeCoverPort)

DEFINE_MODULE 'Squeezebox_Comm'			modSquezeboxTCP4(vdvSqueezeServer_4, 
								dvSqueezeServer_4, 
								g_dvaSqueezePanels_4,
								g_dvaPanels,
								g_caSqueezePlayerID_4,
								m_caSqueezeHost, 
								m_iSqueezeCLIPort, 
								m_iSqueezeCoverPort)

DEFINE_MODULE 'Squeezebox_Comm'			modSquezeboxTCP5(vdvSqueezeServer_5, 
								dvSqueezeServer_5, 
								g_dvaSqueezePanels_5,
								g_dvaPanels,
								g_caSqueezePlayerID_5,
								m_caSqueezeHost, 
								m_iSqueezeCLIPort, 
								m_iSqueezeCoverPort)
								
DEFINE_MODULE 'Squeezebox_Comm'			modSquezeboxTCP6(vdvSqueezeServer_6, 
								dvSqueezeServer_6, 
								g_dvaSqueezePanels_6,
								g_dvaPanels,
								g_caSqueezePlayerID_6,
								m_caSqueezeHost, 
								m_iSqueezeCLIPort, 
								m_iSqueezeCoverPort)
*/
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

