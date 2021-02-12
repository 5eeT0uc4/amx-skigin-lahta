PROGRAM_NAME='DFSolutions BLink User Interface'
////////////////////////////////////////////////////////////
//     AMX UK Ltd Standard Netlinx New File Template      //
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
//       ========== CVS Version History ==========        //
////////////////////////////////////////////////////////////
/*
    $log: $
*/
////////////////////////////////////////////////////////////
#include 'cp1251.axi'

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
DEFINE_CONSTANT

/////////////////// Array Bounds
MAX_USERINTERFACES		= 16;
MAX_ITEMNAME			= 96; // Track, Artist, Album etc. And 'Track - Artist'
MAX_G4RES_NAME			= 32;
MAX_SENDCMD_QLENGTH		= 128;

///////////////////
ASCII_BACKSPACE			= $08;
XIVAFONT_CHAR_SEARCH 		= '9'; // Magnifying Glass

/////////////////// Browser ID's
BRWSR_CAT_NULL			= 0;	// Nopage set 
BRWSR_CAT_ARTISTS		= 1;
BRWSR_CAT_ALBUMS		= 2;
BRWSR_CAT_TRACKS		= 3;
BRWSR_CAT_ALBUMCOVERS		= 4;
BRWSR_CAT_GENRES		= 5;
BRWSR_CAT_ERAS			= 6;
BRWSR_CAT_SIMILAR		= 7;
BRWSR_CAT_PLAYLISTS		= 8;
BRWSR_CAT_MOVIES		= 9;	// Video
BRWSR_CAT_ACTORS		= 10;	// Video
BRWSR_CAT_PLAYQ			= 11;
BRWSR_CAT_DIRECTORS		= 12;	// Video
BRWSR_CAT_MOVIECOVERS		= 13;	// Video
BRWSR_CAT_MOVIEGENRES		= 14;	// Video
BRWSR_CAT_MOVIEYEARS		= 15;	// Video
BRWSR_CAT_RATING		= 16;	// Video
BRWSR_CAT_ALLTRACKS		= 17;	
BRWSR_CAT_STATIONS		= 18;	
BRWSR_CAT_RADIOGENRES		= 19;	
BRWSR_NOWPLAYING		= 20;	// Not actually A browser but usefull flag
BRWSR_MAX_CATEGORIES		= 20;   // BRWSR_CAT_SELECTIONS;


// Non List based pages
PAGE_LIBRARY_AUDIO		= $0100;  // <-- These are non list 'other' pages
PAGE_LIBRARY_VIDEO		= $0200;
PAGE_LIBRARY_NETRADIO		= $0300;
PAGE_NOWPLAYING_AUD		= $0400;
PAGE_NOWPLAYING_VID		= $0500;

PAGE_MASK_BROWSER		= $00FF;
PAGE_MASK_OTHER			= $FF00;

LIBRARY_AUDIO			= 1;
LIBRARY_VIDEO			= 2;
LIBRARY_RADIO			= 3;

/////////////////// 
BRWSR_MAX_PAGESIZE		= 12;
BRWSR_MAX_DMS_PAGESIZE		= 4;
BRWSR_MAX_FWDPATHS		= 4;

/////////////////// BLink Comms browser msg data prefixes

/// Extended message details
ORIGDAT_BRW_GETARTIST_1STMEDIA	= 1;  // For Artist we have to et the 1st album
ORIGDAT_BRW_GETGENRE_1STMEDIA	= 2;  // For Genre we have to et the 1st album
ORIGDAT_BRW_GET1STTRACK		= 3;  // For Era's and Years, get the first track...
ORIGDAT_BRW_GETTRACK_DETAIL	= 4;  // ...then we can get the full details from the 1st Track
ORIGDAT_BRW_GETPLAYLIST_TRKCOUNT= 5;  // For listing the tracks in a playlist
ORIGDAT_BRW_CONTENTQUERY	= 6;  // Browser dataset mode
ORIGDAT_BRW_OBJECTCOVERART	= 7;  // Object detail fetch.


/////////////////// Dataset Stuff
DS_MODE_NORMAL			= 1;
DS_MODE_SEARCH			= 2;
DS_STATE_NULL			= 0;	// Uninitialized
DS_STATE_INITIALIZED		= 1;	// Parameters set
DS_STATE_DIRTY			= 2;	// Changed on the server since we last requested. Mainly for the PlayQ
DS_STATE_READY			= 3;	// Created on the server and ready for paging
DS_STATE_NORESULTS		= 4;	// Query was ok but on data came back, zero row count

DS_DEFAULT_VIEW			= 1;
//MAX_BRWSR_DATASETS		= 2;

// Dataset seach modes
DS_SRCHMODE_NONE		= 0;
DS_SRCHMODE_JUMP		= 1;
DS_SRCHMODE_BEGINS		= 2;
DS_SRCHMODE_CONTAINS	= 3;

// Dataset Fields
MAX_DS_QUERYSTRING		= 256;
MAX_DS_SHORTFIELD		= 32;
MAX_DS_MEDIUMFIELD		= 128;
MAX_DS_LONGFIELD		= 256;
MAX_DS_GUID				= 256;
MAX_DS_VIEWS			= 10;

// Constants for Commands
QADD_TRACK_ALL			= -1;

// PlayQueue Adding
QADD_INSMODE_REPLACEPLAY	= 0;
QADD_INSMODE_APPEND		= 1;
QADD_INSMODE_APPENDPLAY		= 2;

/////////////////// TP Button Defines.

// Browser List Fields
integer vtx_BrwsList_Fields[BRWSR_MAX_PAGESIZE] 	= { 001,002,003,004,005,006,007,008,009,010,011,012 };
integer btn_BrwsList_Fields[BRWSR_MAX_PAGESIZE] 	= { 001,002,003,004,005,006,007,008,009,010,011,012 };

char BRWSR_G4DYNIMG_COVERRESOURCE[] 			= 'BLinkBrowserCovers';
char BRWSR_G4DYNIMG_SIMCOVERRESOURCE[] 			= 'BLinkSimilarCovers';

integer vtx_BrwsList_CoverFields[BRWSR_MAX_PAGESIZE] 	= { 081,082,083,084,085,086,087,088,089,090,091,092 };
integer btn_BrwsList_CoverFields[BRWSR_MAX_PAGESIZE] 	= { 081,082,083,084,085,086,087,088,089,090,091,092 };

integer vtx_BrwsList_QTextFields[BRWSR_MAX_PAGESIZE] 	= { 301,302,303,304,305,306,307,308,309,310 }; // <-- Legacy. Leav for now
integer btn_BrwsList_QTextFields[BRWSR_MAX_PAGESIZE] 	= { 301,302,303,304,305,306,307,308,309,310 };

integer vtx_BrwsList_SimilarMedia[BRWSR_MAX_PAGESIZE] 	= { 021,022,023,024,025,026,027,028,029,030 };
integer btn_BrwsList_SimilarMedia[BRWSR_MAX_PAGESIZE] 	= { 021,022,023,024,025,026,027,028,029,030 };

integer btn_Page_MediaLibrary				= 100;
integer btn_Page_LibraryAudio				= 101;
integer vtx_Page_LibraryAudio				= 101;
integer btn_Page_LibraryVideo				= 102;
integer vtx_Page_LibraryVideo				= 102;
integer btn_Page_LibraryNetRadio			= 103;
integer vtx_Page_LibraryNetRadio			= 103;
integer btn_Page_NowPlaying				= 110;

// Browser category selection
integer btn_BrwsCategories[BRWSR_MAX_CATEGORIES] 	= { 111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130 }; // ..130 as spares
														
integer vtx_Brws_NavInfo 		= 131;
integer vtx_Brws_CategoryName  		= 132;
integer btn_Brws_CategoryIcon		= 133;
integer vtx_Brws_CategoryIcon		= 133;
integer vtx_Brws_PageInfo 		= 134; // Page x of x
integer lvl_Brws_PageInfo 		= 001; // Page x of x Scroll Bar.
integer vtx_Brws_CoverMenuPopup 	= 135;
integer vtx_Brws_SimilarNavInfo 	= 136;
integer vtx_Brws_SimilarPageInfo	= 137;


// View/Sort controls
integer btn_BrwsViewSort_Item		= 41;
integer vtx_BrwsViewSort_ItemText 	= 41;		
integer vtx_BrwsViewSort_QualText 	= 42;
integer btn_BrwsViewSort_NextView	= 43;
integer btn_BrwsViewSort_PrevView 	= 44;
integer btn_BrwsViewSort_Default  	= 45;
integer btn_BrwsViewSort_Done  		= 46;

// Editing Controls
integer btn_Edit_Start			= 61;
integer btn_Edit_Finish			= 62;
integer btn_Edit_MoveUp			= 63;
integer btn_Edit_MoveDn			= 64;
integer btn_Edit_RemoveItem		= 65;
integer btn_Edit_DeletePlaylist		= 66;
integer btn_Edit_RenamePlaylist		= 67;
integer btn_Edit_SavePlaylist		= 68;
integer btn_Edit_SavePlayQueue		= 69;
integer btn_Edit_ClearText		= 70;
integer btn_Edit_Dirty			= 71;
integer vtx_Edit_EditText		= 72;
integer vtx_Edit_TargetPlaylist		= 73;


// Search controls
integer btn_BrwsSearch_Modes[]		= { 51, 52, 53 };
integer vtx_BrwsSearch_Text		= 50;
integer vtx_BrwsSearch_TextVerbose	= 54;
integer btn_BrwsSearch_Clear		= 55;
integer btn_BrwsSearch_Go		= 56;
integer vtx_BrwsSearch_Enabled		= 59;

integer vtx_BrwsABCJump			= 151; 			// ABC Jump button. Usually disabled when Browser is in search mode.									
integer btn_BrwsPaging[2]		= { 151,152 }; 	// Up, Down
integer btn_BrwsSelection[2]		= { 154,155 }; 	// Up, Down
integer btn_BrwsSimilar_Paging[2]  	= { 57, 58 };	// Up, Down
integer vtx_BrwsFwdPath_ShowPaths 	= 200;
integer btn_BrwsFwdPath_Paths[BRWSR_MAX_FWDPATHS] 	= { 201,202,203,204 } // ...210 as spares
integer vtx_BrwsFwdPath_Names[BRWSR_MAX_FWDPATHS] 	= { 201,202,203,204 } // ...210 as spares
integer vtx_BrwsFwdPath_Icons[BRWSR_MAX_FWDPATHS]	= { 211,212,213,214 } // ...220 as spares

integer btn_BrwsRestore				= 156;			// Restore the current browser from non-browser pages
integer btn_BrwsBackup				= 157;			// Go back in the current context
integer vtx_BrwsBackup				= 157;			// Go back in the current context
integer btn_BrwsAdd2Queue			= 158;			// Add the highlighted item to the Q
integer vtx_BrwsAdded2Queue			= 158;			// Added to Queue confirmation text
integer btn_BrwsRemoveFromQueue 		= 159;			// Remove the item selected in the playqueue
integer btn_BrwsClearQueue			= 160;			// Clear the entire queue.
integer vtx_BrwsSelCoverArt			= 153;			// Cover Art for selected Item
integer vtx_BrwsSelItemMETA_Name 		= 198;			// Text for selected item.
integer btn_BrwsTop				= 199;			//Return to Top-Most Main Menu



// Transport Control
integer btn_GUI_Transport_Stop		= 700;
integer btn_GUI_Transport_Pause		= 701;
integer btn_GUI_Transport_Play		= 713;
integer btn_GUI_Transport_SkipLeft	= 702;
integer btn_GUI_Transport_SkipRight	= 703;
integer btn_GUI_Transport_ScanLeft	= 704;
integer btn_GUI_Transport_ScanRight	= 705;
integer btn_GUI_IR_Cycle_Browse		= 706;
integer btn_GUI_IR_Ch_Plus		= 707;
integer btn_GUI_IR_Ch_Minus		= 708;
integer btn_GUI_IR_Macro_Red		= 709;
integer btn_GUI_IR_Macro_Yellow		= 710;
integer btn_GUI_IR_Macro_Green		= 711;
integer btn_GUI_IR_Macro_Blue		= 712;
integer btn_PlayTransports[]		= { 181,182,183,184,185,186,187 };
integer btn_PlayMode_Cycle		= 180;
integer btn_PlayMode_Once		= 188;
integer btn_PlayMode_Repeat		= 189;
integer btn_PlayMode_Shuffle		= 190;
integer btn_PlayModes[]			= { btn_PlayMode_Once, btn_PlayMode_Repeat, btn_PlayMode_Shuffle };
integer btn_PlaySelected		= 197;
integer btn_PreviewSelected		= 198;
integer btn_DMS_PlayAction		= 246;
integer btn_1				= 714;
integer btn_2				= 715;
integer btn_3				= 716;
integer btn_4				= 717;
integer btn_5				= 718;
integer btn_6				= 719;
integer btn_7				= 720;
integer btn_8				= 721;
integer btn_9				= 722;
integer btn_0				= 723;

// Navigation Controls
integer btn_NavCursorUp			= 171;
integer btn_NavCursorDown		= 172;
integer btn_NavCursorLeft		= 173;
integer btn_NavCursorRight		= 174;
integer btn_NavCursorEnter		= 175;
integer btn_NavMenu_Menu		= 176;
integer btn_NavMenu_Back		= 177;
integer btn_GUI_IR[]	= { 171,172,173,174,175,176,177, btn_GUI_Transport_Stop, btn_GUI_Transport_Pause, btn_GUI_Transport_Play, btn_GUI_Transport_SkipLeft, btn_GUI_Transport_SkipRight, btn_GUI_Transport_ScanLeft, btn_GUI_Transport_ScanRight, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723  }

// Playout Destination Selection
integer btn_PlayPlayoutZone[MAX_ZONES] = { 221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236 }
integer vtx_PlayPlayoutZone[MAX_ZONES] = { 221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236 }
integer vtx_PlayCurrentZone		= 200;

// Now Playing Info
integer vtx_NowPlaying_Time		= 191;
integer vtx_NowPlaying_Title		= 192;
integer vtx_NowPlaying_Artist		= 193;
integer vtx_NowPlaying_Album		= 194;
integer lvl_NowPlaying_TimeBar		= 06;
integer vtx_NowPlaying_TimeBar  	= 195;
integer vtx_NowPlaying_CoverArt 	= 196;
integer vtx_NowPlaying_Genre    	= 241;
integer vtx_NowPlaying_Year		= 242;
integer vtx_NowPlaying_SelectionInfo 	= 243;
integer vtx_NowPlaying_TrackLength 	= 244;
integer vtx_DMS_PlayingStatus		= 245;
integer vtx_NowPlaying_Director		= 246;
integer vtx_NowPlaying_Rating		= 247;

// About Info
integer vtx_About_Server		= 31;
integer vtx_About_Serial		= 32;
integer vtx_About_BLinkSoft		= 33;
integer vtx_About_APIVer		= 34;
integer vtx_About_IPAddress		= 35;
integer vtx_About_Outputs		= 36;
integer vtx_About_Module		= 37;
integer vtx_About_CommState		= 38;
integer btn_Comms_Connect		= 39;
integer btn_Comms_Disconnect		= 40;
integer btn_About_GetInfo		= 31;



/////////////////// Std Func Order
TR_PLAY      = 1;
TR_STOP      = 2;
TR_PAUSE     = 3;
TR_FFWD      = 4;
TR_REW       = 5;
TR_NEXT      = 4;
TR_PREV      = 5;
TR_SFWD      = 6;
TR_SREV      = 7;
TR_REC       = 8;
TR_POWER     = 9;

NAV_UP      = 45;    
NAV_DN      = 46;    
NAV_LT      = 47;    
NAV_RT      = 48;    
NAV_SELECT	= 49; 
NAV_BACK	= 81;	
NAV_DVDMENU	= 115;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
DEFINE_TYPE

struct _DEVCMD_QUEUEITEM
{
    integer occupied;
    char overwriteid[MAX_DS_GUID];
    dev dvDevice;
    char txdata[MAX_BLINKTXBYTES];
}

struct _DEVCMD_QUEUE
{
    integer head;
    integer tail;	
    _DEVCMD_QUEUEITEM items[MAX_SENDCMD_QLENGTH];
}

structure _BLINK_DS_LINE // Dataset line/row
{
    long	row;				// The absosulte row number
    char	id[MAX_DS_GUID];		// guid for objectification :o)
    char	text[MAX_ITEMNAME];		// Item text
    char	qtext[MAX_ITEMNAME];		// Qualifying Item text
    char	cover_path[MAX_DS_GUID];	// Path to the media's folder for cover art
}

structure _COVERART_URL
{
    char	host[MAX_DS_SHORTFIELD];
    char 	path[MAX_DS_LONGFIELD];
    char	file[MAX_DS_LONGFIELD];
}

structure _G4_IMG_CACHE
{
    char 	resource[MAX_G4RES_NAME];
    char	url[MAX_DS_GUID];
    integer	isDynamic;
}
/*
structure _BLINK_DS_VIEW // Field info and description
{
    char 	sortkey[MAX_DS_SHORTFIELD];			// Sort column
    char	sortdescription[MAX_DS_LONGFIELD];		// Sort Description
    char 	qtextkey[MAX_DS_SHORTFIELD];			// Qualify text column
    char	qtextdescription[MAX_DS_LONGFIELD];		// Qtext Description
    integer	prefixqtext;					// Qtext should be prefixed with its description
}
*/
structure _BLINK_DATASET
{
    ///// Status
    integer	status;					// Status of the dataset
    integer	isDirty;				// Flag to say that the data on the server associated with this browser may have changed
    integer	isSeeded;				// Dataset query will be seeded by another browser. Use queryseed.
    integer	isSearch;				// Datset is in search mode using queryfilter as the search string
    integer	searchmode;				// Dataset search mode. Jump, Begins with, Contains
    integer	user_searchmode;			// Search mode used last time
    
    ///// Properties of the query
    char	querytype[MAX_DS_SHORTFIELD];		// Dataset Query Type/Table.
    char	queryseed[MAX_DS_LONGFIELD];		// Seeded query spec
    char	queryseed_type[MAX_DS_LONGFIELD];	// Seeded query spec
    char	queryfilter[MAX_DS_SHORTFIELD];		// Filter string for filtered lists AKA search
    integer	seed_br;				// Browser that actually Seeded this one
    
    ///// Current View state
    long 	rowcount;				// Number of rows in this dataset
    integer	pagecount;				// Number of pages
    integer	pagesize;				// lines in each page
    long	prevline;				// Where we were
    long	currline;				// Where we are on the page
    long	pagetop;				// Where we are in the data.
    long 	offset;					// Offset 
    integer	linecount;				// How many items on this page
    integer	pagenum;				// The current page
}

structure _FWD_PATH
{
    integer enabled;					// Forward path should be shown
    integer browser;					// Browser category in this path
}

structure _BROWSER
{
    // Pageing data
    integer		selected;				// Selected item within the current page of items
    
    // Navigation
    integer		refBrowser;				// The browser we were refered from by a search or fwd path
    //integer		prevBrowser;				// The browser we were on before the PLAY_Q
    _FWD_PATH		fwdpaths[BRWSR_MAX_FWDPATHS] 		// Browsers we can go to from here, or seedable browsers from this category
    
    _BLINK_DATASET	dataset;				// The dataset itself
    _BLINK_DS_LINE 	ds_items[BRWSR_MAX_PAGESIZE];		// The actual data
    _G4_IMG_CACHE 	ds_covers_cache[BRWSR_MAX_PAGESIZE];	// cover art url caching.
}

structure _USERINTERFACE
{
    dev			device;				// The actual device for this UI, for feedback
    integer		isonline;			// The device is present
    integer		hasbeenoffline;			// Sound strange but we need to know if the panel is out of sync
    DEV_INFO_STRUCT	devinfo;			// The type of UI, Modero, DMS, G3
    integer		isDMS				// Pre checked dms keypad flag
    integer 		initialised;			// This UI has had its inits stuff done
    _BROWSER		browsers[BRWSR_MAX_CATEGORIES]	// Browser array for this UI
    integer		curbrowser;			// Current live browser or page
    integer		curLibrary;			// Last library chosen Audio/Video
    integer		prevBrowser;			// Last browser before switching to non-library pages
    integer     	lastAudioBr;			// Last browser of the Audio category
    integer     	lastVideoBr;			// Last browser of the Video category
    integer 		curzone;			// Current XiVA output.
    integer 		defaultpagesize;		// Default page size for browsers
    
    // Special states
    integer		drillbtn_hold;			// Hold state for DrillDown/PlayNow btn
    integer		playaddbtn_hold;		// Hold state for Play/Add selected to Q
    integer		resetpageinfo;			// Flag to re show the page number info after "Selection Added" msg.
    integer		lastselected_br;		// The browser of the last selected item
    
    // Dynamic Image Management
    //integer btnDynImageSet[BRWSR_MAX_PAGESIZE];
    //integer btnNormDynImageSet[BRWSR_MAX_PAGESIZE];
    //integer btnSimDynImageSet[BRWSR_MAX_PAGESIZE];
    
}
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
DEFINE_VARIABLE

volatile _USERINTERFACE uis[MAX_USERINTERFACES];	// UI Holding vars
volatile _DEVCMD_QUEUE  sendcmd_queue;			// Send Command queue. Mainly for pacing coverart

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// FUNCTIONS

// Useful Macros
#define CHECK_UI if(ui and ui <= MAX_USERINTERFACES)
#define CHECK_BROWSER if(br and br <= BRWSR_MAX_CATEGORIES)
#define CHECK_ITEM if(item and item <= BRWSR_MAX_PAGESIZE)
#define THIS_UI uis[ui]
#define THIS_BRWSR uis[ui].browsers[br]
#define THAT_BRWSR uis[ui].browsers[tbr]
#define REF_BRWSR uis[ui].browsers[ref_br]
#define SEED_BRWSR uis[ui].browsers[seed_br]
#define DEST_BRWSR uis[ui].browsers[tbr]
#define SRCE_BRWSR uis[ui].browsers[br]
#define PREV_BRWSR uis[ui].browsers[pbr]
#define THIS_DATASET uis[ui].browsers[br].dataset
#define CURRENT_VIEW views[vw]
#define GET_DS_SORT  uis[ui].browsers[br].dataset.currSort
#define CHECK_VIEW if(vw and vw <= MAX_DS_VIEWS)
#define CHECK_PATH if(fwp and fwp <= BRWSR_MAX_CATEGORIES)
#define THIS_PATH uis[ui].browsers[br].fwdpaths[fwp]

///////// Touch Panel api
Define_Function integer fnTPAPI_IsAxlinkDev(dev testdev)
{
    if(testdev.number >255) return 0;
    
    return 1;
}

/**
    Устновка текста элементу
    на входе	:	device	- панель
			vtx	- адрес элемента
			text	- текст для установки
    на выходе	:	*
*/
Define_Function fnTPAPI_Text_SetSimple(dev device, integer vtx, char text[])
{
    if(fnTPAPI_IsAxlinkDev(device))
	send_command device,"'!T',itoa(vtx), text";		// G3
    else
	send_command device,"'^UNI-',itoa(vtx),',0,',CP1251ToUNI(text)"; // G4
}

/**
    Устновка видимости элемента
    на входе	:	device		- панель
			vtx		- адрес элемента
			bVisible	- видимость элемента
    на выходе	:	*
*/
Define_Function fnTPAPI_Btn_SetVisible(dev device, integer vtx, integer bVisible)
{
    if(fnTPAPI_IsAxlinkDev(device)) // G3
	send_command device,"'!B',vtx,(bVisible)";
    else
	send_command device,"'^SHO-',itoa(vtx),',',itoa((bVisible))"; // G4
}

/**
    Добавление флип команды элементу
    на входе	:	device		- панель
			vtx		- адрес элемента
			type		- тип команды
			pagename	- параметр команды
    на выходе	:	*
*/
Define_Function fnTPAPI_PageFlip_AddFlip(dev device, integer vtx, char type[], char pagename[])
{
    if(fnTPAPI_IsAxlinkDev(device)) // G3
    {
	// No G3 equivalent
    }
    else
	send_command device,"'^APF-',itoa(vtx),',',type,',',pagename"; // G4
}

/**
    Добавление флип команды группе элементов
    на входе	:	device		- панель
			vtx_Array	- список команд
			type		- тип команды
			pagename	- параметр команды
    на выходе	:	*
*/
Define_Function fnTPAPI_PageFlip_AddFlip_M(dev device, integer vtx_Array[], char type[], char pagename[])
{
    if(fnTPAPI_IsAxlinkDev(device)) // G3
    {
	// No G3 equivalent
    }
    else
    {
	char vtxRange[256];
	integer v, count;
	
	count = Length_Array(vtx_Array);
	for(v = 1; v <= count; v++)
	{
	    if(v=1) vtxRange = itoa(vtx_Array[v]);
	    else    vtxRange = "vtxRange,',',itoa(vtx_Array[v])";
	}
	send_command device,"'^APF-',vtxRange,',',type,',',pagename"; // G4
    }
}

/**
    Удаление флип команды с элемента
    на входе	:	device		- панель
			vtx		- список команд
			type		- тип команды
			pagename	- параметр команды
    на выходе	:	*
*/
Define_Function fnTPAPI_PageFlip_DeleteFlip(dev device, integer vtx, char type[], char pagename[])
{
    if(fnTPAPI_IsAxlinkDev(device)) // G3
    {
	// No G3 equivalent
    }
    else send_command device,"'^DPF-',itoa(vtx),',',type,',',pagename"; // G4
}

/**
    Удаление флип команды с элемента
    на входе	:	device		- панель
			vtx_Array	- список команд
			type		- тип команды
			pagename	- параметр команды
    на выходе	:	*
*/
Define_Function fnTPAPI_PageFlip_DeleteFlip_M(dev device, integer vtx_Array[], char type[], char pagename[])
{
    if(fnTPAPI_IsAxlinkDev(device)) // G3
    {
	// No G3 equivalent
    }
    else
    {
	char vtxRange[256];
	integer v, count;
	
	count = Length_Array(vtx_Array);
	for(v = 1; v <= count; v++)
	{
	    if(v=1)
		vtxRange = itoa(vtx_Array[v]);
	    else
		vtxRange = "vtxRange,',',itoa(vtx_Array[v])";
	}
	send_command device,"'^DPF-',vtxRange,',',type,',',pagename"; // G4
    }
}

/**
    Удаление всех флип команд с элемента
    на входе	:	device	- панель
			vtx	- список команд
    на выходе	:	*
*/
Define_Function fnTPAPI_PageFlip_ClearAll(dev device, integer vtx)
{
    if(fnTPAPI_IsAxlinkDev(device)) // G3
    {
	// No G3 equivalent
    }
    else send_command device,"'^CPF-',itoa(vtx)"; // G4
}

/**
    Получение порядкового номера элемента по идентификатору
    на входе	:	btn	- идентификатор элемента
			btns	- список идентификаторов элементов
    на выходе	:	порядковый номер элемента
*/
Define_Function integer fnGetLastBtn(integer btn, integer btns[])
{
    integer b,len;
    
    len = LENGTH_ARRAY(btns);
    
    for(b=1; b <= len; b++)
	if(btn == btns[b])
	    return b;
    
    return 0;
}

/**
    Получение порядкового номера панели по идентификатору
    на входе	:	srchdev	- идентификатор панели
			devlist	- список идентификаторов панелей
    на выходе	:	порядковый номер панели
*/
Define_Function integer fnGetLastUI(dev srchdev, dev devlist[])
{
    integer d, len;
    
    len = LENGTH_ARRAY(devlist);
    
    for(d=1; d <= len; d++)
    {
	if(devlist[d].system == 0 or srchdev.system == 0)
	{
	    if(	srchdev.number 	== devlist[d].number &&
		srchdev.port 	== devlist[d].port)
	    {
		return d;
	    }
	}
	else
	{
	    if(	srchdev.number 	== devlist[d].number &&
		srchdev.port 	== devlist[d].port &&
		srchdev.system	== devlist[d].system)
	    {
		return d;
	    }
	}
    }
    
    return 0;
}

/**
    Получение порядкового номера зоны по идентификатору
    на входе	:	z		- идентификатор зоны
			dvZoneUIs	- список идентификаторов панелей
    на выходе	:	порядковый номер панели связаной с зоной
*/
Define_Function integer fnGetZoneUIDevs(integer z, dev dvZoneUIs[])
{
    integer ui, uicount;
    uicount = Length_Array(uis);
    
    //// Get a list of panels associated with this zone
    for(ui=1; ui <= uicount; ui++)
    {
	if(THIS_UI.curzone == z)
	{
	    uicount++;
	    if(uicount <= Max_Length_Array(dvZoneUIs))
	    {
		dvZoneUIs[uicount] = THIS_UI.device;
		Set_Length_Array(dvZoneUIs,uicount);
	    } else
		return 0; // Oops!
	}
    }
    
    return 1;
}

/**
    Подсчет общего количества панелей
    на входе	:	uitarget	- идентификатор зоны
			dvUIs		- массив куда нужно поместить найденные панели
			dvG3UIs		- массив куда нужно поместить все G3 панели
			dvG4UIs		- массив куда нужно поместить все G4 панели
    на выходе	:	количество панелей
*/
Define_Function integer fnGetUIDeviceLists(integer uitarget, dev dvUIs[], dev dvG3UIs[], dev dvG4UIs[])
{
    //local_var _BLink_NOWPLAYING old_nowplaying;
    integer ui, uicount, g3uicount, g4uicount;
    
    // Selective ui update
    if(uitarget)
	ui = uitarget;
    else
	ui = 1;
    
    //// Get a list of panels associated with this zone
    for(ui=1 ; ui <= MAX_USERINTERFACES; ui++)
    {
	uicount++;
	dvUIs[uicount] = THIS_UI.device;
	Set_Length_Array(dvUIs,uicount);
	
	// List of G3 panels
	if(fnIsAxlinkDev(THIS_UI.device))
	{
	    g3uicount++
	    dvG3UIs[g3uicount] = THIS_UI.device;
	    Set_Length_String(dvG3UIs,g3uicount);
	}
	// List of G4 panels
	else
	{
	    g4uicount++
	    dvG4UIs[g4uicount] = THIS_UI.device;
	    Set_Length_String(dvG4UIs,g4uicount);
	}
	
	if(uitarget) break; // Just one ui?
    }
    
    return uicount;
}

/**
    Подсчет общего количества панелей
    на входе	:	uitarget	- идентификатор зоны
			dvUIs		- массив куда нужно поместить найденные панели
			dvG3UIs		- массив куда нужно поместить все G3 панели
			dvG4UIs		- массив куда нужно поместить все G4 панели
    на выходе	:	количество панелей
*/
Define_Function integer fnGetZoneUIDeviceLists(integer uitarget, integer z, dev dvZoneUIs[], dev dvG3ZoneUIs[], dev dvG4ZoneUIs[])
{
    CHECK_ZONE
    {
	//local_var _BLink_NOWPLAYING old_nowplaying;
	integer ui, uicount, g3uicount, g4uicount;
	
	// Selective ui update
	if(uitarget) ui = uitarget;
	else		 ui = 1;
	
	//// Get a list of panels associated with this zone
	for( ; ui <= MAX_USERINTERFACES; ui++)
	{
	    if(THIS_UI.curzone == z)
	    {
		uicount++;
		dvZoneUIs[uicount] = THIS_UI.device;
		Set_Length_Array(dvZoneUIs,uicount);
		
		// List of G3 panels
		if(fnIsAxlinkDev(THIS_UI.device))
		{
		    g3uicount++
		    dvG3ZoneUIs[g3uicount] = THIS_UI.device;
		    Set_Length_String(dvG3ZoneUIs,g3uicount);
		}
		// List of G4 panels
		else
		{
		    g4uicount++
		    dvG4ZoneUIs[g4uicount] = THIS_UI.device;
		    Set_Length_String(dvG4ZoneUIs,g4uicount);
		}
	    }
	    
	    if(uitarget) break; // Just one ui?
	}
	
	return uicount;
    }
}

/**
    Проверка принадлежности идентификатора панели к G3 панелям
    на входе	:	testdev	- идентификтор тестуркемой модели
    на выходе	:	true	- идентификатор G3
			false	- идентификатор G4
*/
Define_Function integer fnIsAxlinkDev(dev testdev)
{
    if(testdev.number >255) return 0;
    
    return 1;
}

/**
    Функция помошник: "Подрезание" слишком длинной строки
    на входе	:	text		- строка для подрезания
			targetlen	- максимальная длинна строки
    на выходе	:	полученная строка
    примечание	:	Для примера есть строка "Test String" а максимальная длинна строки 5 
			на выходе имеем строку "Te..."
*/
Define_Function char[255] fnHelper_ElipseString(char text[], integer targetlen)
{
    integer len;
    len = Length_String(text);
    
    if(len > targetlen)
	return "Left_String(text, targetlen - 3), '...'";
    else
	return text;
}

/**
    Функция помошник: разделение URI строки на составляющие с помещением в структуру
    на входе	:	coverURI	- URI строка
			urlstruct	- структура куда нужно поместить полученные данные
    на выходе	:	успешность разделения строки
			0 - строка не содержит URI данных
			1 - строка успешно разделена
*/
Define_Function integer fnHelper_CoverURIToHostPathFile(char coverURI[], _COVERART_URL urlstruct)
{
    integer pProtcol;
    char url[MAX_DS_GUID];
    
    // Копирование строки
    url = coverURI;
    
    // Проверка наличия начальной строки протокола
    pProtcol = Find_String(url, "'://'", 1);
    if(pProtcol)
    {
	Remove_String(url,"'://'",1);
	urlstruct.host = Remove_String(url, "'/'", 1);
	
	// Проверка наличия хоста в строке
	if(urlstruct.host == "")
	    return 0;
	    
	// Установка длинна хоста
	Set_Length_String(urlstruct.host, Length_String(urlstruct.host) - 1);
	
	// Разделение строки на путь и файл
	{
	    char pathtoken[MAX_DS_MEDIUMFIELD];
	    pathtoken = Remove_String(url, "'/'", 1);
	    while(Length_String(pathtoken))
	    {
		urlstruct.path = "urlstruct.path, pathtoken";
		pathtoken = Remove_String(url, "'/'", 1);
	    }
	    // Установка длинны пути
	    Set_Length_String(urlstruct.path, Length_String(urlstruct.path) - 1);
	}
	
	// Запишем файл
	urlstruct.file = url;
	
	return 1;
    }
}

/**
    Функция помошник: получение имени категории по идентификатору
    на входе	:	br	- идентиифкатор браузера
			bShort	- признак короткого имени
    на выходе	:	строка с именем категории
*/
Define_Function char[12] fnHelper_BrowserCatTOString(integer br, integer bShort)
{
    switch(br)
    {
	case BRWSR_CAT_ARTISTS: 	return 'Artists';
	case BRWSR_CAT_ALBUMS: 		return 'Albums';
	case BRWSR_CAT_TRACKS: 		return 'Tracks';
	case BRWSR_CAT_ALBUMCOVERS:	if(bShort) return 'Covers'; else return 'Album Covers';
	case BRWSR_CAT_GENRES: 		return 'Genres';
	case BRWSR_CAT_SIMILAR:		return 'Similar';
	case BRWSR_CAT_ERAS: 		return 'Eras';
	case BRWSR_CAT_PLAYLISTS:	return 'Playlists';
	case BRWSR_CAT_MOVIES: 		return 'Movies';
	case BRWSR_CAT_ACTORS: 		return 'Actors';
	case BRWSR_CAT_PLAYQ: 		return 'Play Queue';
	case BRWSR_CAT_DIRECTORS:	return 'Directors';
	case BRWSR_CAT_MOVIECOVERS:	if(bShort) return 'Covers'; else return 'Movie Covers';
	case BRWSR_CAT_MOVIEYEARS:	if(bShort) return 'Years'; else return 'Movie Years';
	case BRWSR_CAT_MOVIEGENRES:	if(bShort) return 'Genre'; else return 'Movie Genres';
	case BRWSR_CAT_RATING:		return 'Rating';
	case BRWSR_CAT_ALLTRACKS:	if(bShort) return 'All Trks'; else return 'All Tracks';
	case BRWSR_CAT_STATIONS:	return 'Stations';
	case BRWSR_CAT_RADIOGENRES:	if(bShort) return 'R.Genres'; else return 'Radio Genres';
	case BRWSR_NOWPLAYING:		return 'Now Playing';
    }
    
    return 'Unkown Category';
}

/**
    Функция помошник: получение имени категории по идентификатору для работы с группой
    на входе	:	br	- идентиифкатор браузера
    на выходе	:	строка с именем категории
*/
Define_Function char[12] fnHelper_BrowserCatToBLinkGroupType(integer br)
{
    switch(br)
    {
	case BRWSR_CAT_ARTISTS: 	return 'Artist';
	case BRWSR_CAT_ALBUMS: 		return 'Album';
	case BRWSR_CAT_TRACKS: 		return 'Track';
	case BRWSR_CAT_ALBUMCOVERS:	return 'Album';
	case BRWSR_CAT_GENRES: 		return 'Genre';
	case BRWSR_CAT_SIMILAR:		return 'Album';
	case BRWSR_CAT_ERAS: 		return 'Eras';
	case BRWSR_CAT_PLAYLISTS:	return 'Playlist';
	case BRWSR_CAT_MOVIES: 		return 'Movies';
	case BRWSR_CAT_ACTORS: 		return 'Actors';
	case BRWSR_CAT_PLAYQ: 		return 'Play Queue';
	case BRWSR_CAT_DIRECTORS:	return 'Directors';
	case BRWSR_CAT_MOVIECOVERS:	return 'Covers';
	case BRWSR_CAT_MOVIEYEARS:	return 'Years';
	case BRWSR_CAT_MOVIEGENRES:	return 'Genre';
	case BRWSR_CAT_RATING:		return 'Rating';
	case BRWSR_CAT_ALLTRACKS:	return 'Track';
	case BRWSR_CAT_STATIONS:	return 'NetRadio';
	case BRWSR_CAT_RADIOGENRES:	return 'NetRadio';
	case BRWSR_NOWPLAYING:		return 'Now Playing';
    }
    
    return 'Unkown Category';
}

/**
    Функция помошник: получение символа по идентификатору категории
    на входе	:	br	- идентиифкатор браузера
    на выходе	:	строка с именем категории
*/
Define_Function char fnHelper_BrowserCatTOFontSymbolChar(integer br)
{
    switch(br)
    {
	case BRWSR_CAT_ARTISTS: 	return 'F';
	case BRWSR_CAT_ALBUMS: 		return 'A';
	case BRWSR_CAT_TRACKS: 		return 'B';
	case BRWSR_CAT_ALBUMCOVERS:	return 'A';
	case BRWSR_CAT_GENRES: 		return 'E';
	case BRWSR_CAT_SIMILAR: 	return '?';
	case BRWSR_CAT_ERAS: 		return '0';//'пїЅ';
	case BRWSR_CAT_PLAYLISTS:	return '_';
	case BRWSR_CAT_MOVIES: 		return '1';//'пїЅ';
	case BRWSR_CAT_ACTORS: 		return '2';//'пїЅ';
	case BRWSR_CAT_PLAYQ: 		return '!';
	case BRWSR_CAT_DIRECTORS:	return '3';//'пїЅ';
	case BRWSR_CAT_MOVIECOVERS:	return '4';//'пїЅ';
	case BRWSR_CAT_MOVIEYEARS:	return '?';
	case BRWSR_CAT_MOVIEGENRES:	return '3';
	case BRWSR_CAT_RATING:		return '5';//'пїЅ';
	case BRWSR_CAT_ALLTRACKS:	return 'J';
	case BRWSR_CAT_RADIOGENRES:	return 'K';
    }
    
    return 0;
}

/**
    Функция помошник: получение идентификатора категории по имени категории
    на входе	:	sCategory	- строка с категорией
    на выходе	:	идентификатор категории
*/
Define_Function integer fnHelper_StringToCategory(char sCategory[])
{
    switch(Upper_String(sCategory))
    {
	case 'ARTISTS': 	return BRWSR_CAT_ARTISTS;
	case 'ALBUMS': 		return BRWSR_CAT_ALBUMS;
	case 'TRACKS': 		return BRWSR_CAT_TRACKS;
	case 'ALLTRACKS':	return BRWSR_CAT_ALLTRACKS;
	case 'ALBUMCOVERS':	return BRWSR_CAT_ALBUMCOVERS;
	case 'GENRES':		return BRWSR_CAT_GENRES;
	case 'SIMILAR':		return BRWSR_CAT_SIMILAR;
	case 'ERAS':		return BRWSR_CAT_ERAS;
	case 'PLAYLISTS':	return BRWSR_CAT_PLAYLISTS;
	case 'PLAYQ': 		return BRWSR_CAT_PLAYQ;
	case 'MOVIES':		return BRWSR_CAT_MOVIES;
	case 'ACTORS':		return BRWSR_CAT_ACTORS;
	case 'DIRECTORS':	return BRWSR_CAT_DIRECTORS;
	case 'MOVIECOVERS':	return BRWSR_CAT_MOVIECOVERS;
	case 'MOVIEGENRES':	return BRWSR_CAT_MOVIEGENRES;
	case 'MOVIEYEARS':	return BRWSR_CAT_MOVIEYEARS;
	case 'RATING':		return BRWSR_CAT_RATING;
	case 'STATIONS':	return BRWSR_CAT_STATIONS;
	case 'RADIOGENRES':	return BRWSR_CAT_RADIOGENRES;
    }
    
    return 0;
}

/**
    Функция помошник: получение идентификатора категории по имени группы
    на входе	:	sCategory	- строка с категорией
    на выходе	:	идентификатор категории
*/
Define_Function integer fnHelper_GroupTypeStringToCategory(char sGroupType[])
{
    switch(Upper_String(sGroupType))
    {
	// BLink Group Types
	case 'ARTIST': 		return BRWSR_CAT_ARTISTS;
	case 'ALBUM': 		return BRWSR_CAT_ALBUMS;
	case 'GENRE':		return BRWSR_CAT_GENRES;
	case 'PLAYLIST':	return BRWSR_CAT_PLAYLISTS;
	case 'SIMILAR':		return BRWSR_CAT_SIMILAR;
	
	// Group Type BLink should support
	case 'TRACKS': 		return BRWSR_CAT_TRACKS;
	case 'ALBUMCOVERS':	return BRWSR_CAT_ALBUMCOVERS;
	case 'ERAS':		return BRWSR_CAT_ERAS;
	case 'PLAYQ': 		return BRWSR_CAT_PLAYQ;
	case 'MOVIES':		return BRWSR_CAT_MOVIES;
	case 'ACTORS':		return BRWSR_CAT_ACTORS;
	case 'DIRECTORS':	return BRWSR_CAT_DIRECTORS;
	case 'MOVIECOVERS':	return BRWSR_CAT_MOVIECOVERS;
	case 'MOVIEGENRES':	return BRWSR_CAT_MOVIEGENRES;
	case 'MOVIEYEARS':	return BRWSR_CAT_MOVIEYEARS;
	case 'RATING':		return BRWSR_CAT_RATING;
	case 'ALLTRACKS':	return BRWSR_CAT_ALLTRACKS;
	
	case 'NETRADIO':	return BRWSR_CAT_RADIOGENRES;
    }
}

/**
    Функция помошник: получение строки по идентификатору состояния транспорта
    на входе	:	transport	- идентификатор состояния транспорта
    на выходе	:	строка с состоянием транспорта
*/
Define_Function char[16] fnHelper_TransportFnToStateString(integer transport)
{
    switch(transport)
    {
	case TR_PLAY:	return 'Playing';
	case TR_STOP:	return 'Stopped';
	case TR_PAUSE:	return 'Paused';
	default:	return 'Idle';
    }
}

Define_Function integer fnHelper_DS_CountColumnKeys(char colkeys[])
{
    integer i, keylen, colcount;
    
    i = Length_String(colkeys);
    
    // Must be at least 1 column
    if(i)
	colcount++;
    
    // Count the seperators
    while(i)
    {
	if(colkeys[i] == '|')
	    colcount++;
	i--
    }
    
    return colcount;
}

Define_Function integer fnHelper_GetPlaybackContext(integer z, integer ui)
{
    CHECK_ZONE
    CHECK_UI
    {
	select
	{
	    active(	THIS_ZONE.nowplaying.album_guid != '' and
			THIS_ZONE.nowplaying.video_guid == ''):
	    {
		return LIBRARY_AUDIO;
	    }
	    active(	THIS_ZONE.nowplaying.video_guid != '' and
			THIS_ZONE.nowplaying.album_guid == ''):
	    {
		return LIBRARY_VIDEO;
	    }
	    active(1): return THIS_UI.curlibrary;
	}
    }
    
    return 0;
}

Define_Function integer fnHelper_DS_FindBrowserRowItem(integer ui, integer br, long srchRow)
{
    CHECK_UI
    CHECK_BROWSER
    {
	integer i;
	
	if(THIS_DATASET.linecount == 0) return 0;
	
	for(i=1; i <= THIS_DATASET.linecount; i++)
	{
	    if(THIS_BRWSR.ds_items[i].row == srchRow)
		return i;
	}
    }
    
    return 0;
}

Define_Function char[8] fnHelper_DS_SearchModeToString(integer searchmode)
{
	switch(searchmode)
	{
		case DS_SRCHMODE_BEGINS: 	return 'Start';
		case DS_SRCHMODE_CONTAINS: 	return 'Inline';
	}
	
	return '';
}

Define_Function char[MAX_PARAMVAL] fnHelper_DS_PipeDelimitToCommaSep(char text[])
{
    integer i, itemcount;
    char new_text[MAX_PARAMVAL]
    
    // Count the seperators
    for(i=1; i <= Length_Array(text); i++)
    {
	if(text[i] == '|')
	{
	    //if(!itemcount) new_text = "'пїЅ',new_text";
	    new_text = "new_text,' пїЅ'";
	    itemcount++;
	}
	else
	{
	    new_text = "new_text,text[i]";
	}
    }
    
    return new_text;
}

Define_Function integer fnHelper_DS_CalculatePageCount(long rowcount, integer pagesize)
{
    integer pages;
    long lastpageitemcount;
    
    // Find out if the last page is whole or not
    lastpageitemcount = rowcount % pagesize;
	    
    pages = Type_Cast(rowcount/pagesize);
    if(lastpageitemcount) pages++;
    
    return pages;
}

Define_Function integer fnHelper_DS_CalculatePageNumber(long absrow, integer pagesize)
{
    integer page;
    page = Type_Cast(((absrow - 1) / pagesize) + 1);
    return page;
}

Define_Function long fnHelper_Paging_CalculatePageTop(integer pageno, long rowcount, integer pagesize)
{
    integer pagetop;
    
    if(pageno)
    {
	pagetop = (pagesize*(pageno-1)) +1;
	
	// Watch for pages beyond the end of the list
	if(pagetop > rowcount)
	{
	    integer lastpageitemcount;
	    lastpageitemcount = Type_Cast(rowcount % pagesize);
	    pagetop = Type_Cast(rowcount - lastpageitemcount +1);
	}
    }
    
    return pagetop;
}

Define_Function integer fnHelper_GetLibraryType(integer br)
{
    switch(br)
    {
	case BRWSR_CAT_ARTISTS:
	case BRWSR_CAT_ALBUMS:
	case BRWSR_CAT_TRACKS:
	case BRWSR_CAT_ALBUMCOVERS:
	case BRWSR_CAT_GENRES:
	case BRWSR_CAT_ERAS:
	case BRWSR_CAT_SIMILAR:
	case BRWSR_CAT_PLAYLISTS:
	case BRWSR_CAT_PLAYQ:
	case BRWSR_CAT_ALLTRACKS:
	case PAGE_NOWPLAYING_AUD:
	case PAGE_LIBRARY_AUDIO:
	case BRWSR_CAT_STATIONS:
	case BRWSR_CAT_RADIOGENRES:
	case PAGE_LIBRARY_NETRADIO:
	{
	    return LIBRARY_AUDIO;
	}
	
	case BRWSR_CAT_MOVIES:
	case BRWSR_CAT_ACTORS:
	case BRWSR_CAT_DIRECTORS:
	case BRWSR_CAT_MOVIECOVERS:
	case BRWSR_CAT_MOVIEGENRES:
	case BRWSR_CAT_MOVIEYEARS:
	case BRWSR_CAT_RATING:
	case PAGE_NOWPLAYING_VID:
	case PAGE_LIBRARY_VIDEO:
	{
	    return LIBRARY_VIDEO;
	}
	
	//case BRWSR_CAT_STATIONS:
	//case BRWSR_CAT_RADIOGENRES:
	//case PAGE_LIBRARY_NETRADIO:
	//{
	//	return LIBRARY_RADIO;
	//}
    }
    
    return 0;
}

Define_Function integer fnHelper_IsContentBrowser(integer br)
{
    switch(br)
    {
	case BRWSR_CAT_PLAYQ:
	case PAGE_NOWPLAYING_AUD:
	case PAGE_NOWPLAYING_VID:
	case PAGE_LIBRARY_AUDIO:
	case PAGE_LIBRARY_VIDEO:
	case BRWSR_NOWPLAYING: return FALSE;
    }
    
    return (br and br <= BRWSR_MAX_CATEGORIES);
}

Define_Function integer fnHelper_UItoUnit(integer ui)
{
    integer unit;
    CHECK_UI
    {
	integer zone;
	zone = THIS_UI.curZone;
	unit = fnBLINK_ZoneToUnit(zone);
    }
    
    return unit;
}

Define_Function char[2] fnInt8ToHex(integer in)
{
    return Format('%02.2X',in);
}

Define_Function char[8] fnInt32ToHex(long in)
{
    return Format('%08.8X',in);
}

/////////////////////////////////////////////////////////////////// Native Device send_command queue
Define_Function integer fnDeviceSendCmdQ_GetLength(_DEVCMD_QUEUE queue)
{
    integer qSize; 
    integer items;
    integer i;
    
    qSize = Max_Length_Array(queue.items);
    for(i=1; i <= qSize; i++)
    {
	if(queue.items[i].occupied) items++;
    }
    
    return items;
}

Define_Function fnDeviceSendCmdQ_EnqueueCommand(_DEVCMD_QUEUE queue, dev dvDevice, char txdata[], char overwriteid[])
{
    //     -> [1][2][3][4][5][6][7] ->
    //	       ^                 ^
    //         H                 T
    
    integer qlength;
    integer head;
    integer tail;
    integer insert_index;
    integer qLeft;
    integer qRight;
    qLeft = 1;	
    qRight = Max_Length_Array(queue.items);
    qLength = fnDeviceSendCmdQ_GetLength(queue);	
    head = queue.head;
    tail = queue.tail;
    
    // Check if this is an update and we need to overwrite an existing queue item
    if(overwriteid != "")
    {		
	integer i;
	//fnSendDebugMsg("'SendCMD Queue: Searching for item with id [',overwriteid,'] to update...'");
	for(i=1; i <= Max_Length_Array(queue.items); i++)
	{
	    if(queue.items[i].occupied == TRUE)
	    if(queue.items[i].dvDevice == dvDevice)
	    if(queue.items[i].overwriteid == overwriteid) 
	    {
		insert_index = i;
		//fnSendDebugMsg("'SendCMD Queue: Found [',overwriteid,'] at position ',itoa(i),'. Updating.'");
		break;
	    }
	}
    }
    
    if(insert_index == FALSE)
    {
	// Going to add an item
	tail++;
	if(tail > qRight) tail = qLeft;
	
	insert_index = tail;
    }
    
    // Check for full queue
    if(insert_index == FALSE and queue.items[tail].occupied == TRUE)
    {
	fnSendDebugMsg("'SendCMD Queue is full (',itoa(queue),' items), tx data will be lost. Sorry! Try making the queue longer! MAX_SENDCMD_QLENGTH=',itoa(MAX_SENDCMD_QLENGTH)");
	return;
    }

    queue.items[insert_index].dvDevice = dvDevice;
    queue.items[insert_index].occupied = TRUE;
    queue.items[insert_index].txdata = txdata;
    queue.items[insert_index].overwriteid = overwriteid;
    
    
    // Copy the queue stats back
    queue.head = head;
    queue.tail = tail;
    
    //fnSendDebugMsg("'SendCMD Queue: EN-QUEUED item at pos ',itoa(tail),'. Queue now contains ',itoa(fnDeviceSendCmdQ_GetLength(queue)),' items.'");
    Timeline_Restart(TL_SENDCMD_QUEUE);
}

Define_Function fnDeviceSendCmdQ_DeQueueCommand(_DEVCMD_QUEUE queue)
{
    integer head;
    integer tail;
    integer qLeft;
    integer qRight;
    qLeft = 1;
    qRight = Max_Length_Array(queue.items);
    
    head = queue.head;
    tail = queue.tail;
    
    head++;
    if(head > qRight) head = qLeft;
    
    // Check for empty queue
    if(queue.items[head].occupied == FALSE)
    {
	fnSendDebugMsg("'SendCMD Queue is Empty now.'");
	Timeline_Pause(TL_SENDCMD_QUEUE);
	return;
    }
    
    // Transmit the packet
    Send_Command queue.items[head].dvDevice,queue.items[head].txdata;
    queue.items[head].occupied = FALSE;
    
    //fnSendDebugMsg("'SendCMD Queue: DE-QUEUED item at pos ',itoa(head),'. Queue now contains ',itoa(fnDeviceSendCmdQ_GetLength(queue)),' items.'");
    
    // Copy the stats back
    queue.head = head;
    queue.tail = tail;
}

/////////////////////////////////////////////////////////////////// BLink API Transmission Stub functions
Define_Function fnBLINKTX_API_RequestAudioQueue(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone, long startfrom, long itemcount)
{
    fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_RequestAudioQueue,"'[][',itoa(startfrom),'][',itoa(itemcount),'][][][][][][]'"); 
}

/**
	Запрос списка аудио
*/
Define_Function fnBLINKTX_API_FindAudio(integer when, integer unit, integer org_grp, integer org_type, integer org_id, char org_data[],
										char srchCategory[], char srchValue[], char filtCategory[], char filtValue[], char srchType[],
										long startfrom, long itemcount, integer IdAsHTTP, integer ArtworkAsURL)
{
    fnBLINKTX_SendUnitPacket(when,unit,org_grp,org_type,org_id,org_data,MSG_FindAudio,
    "'[',srchCategory,'][',srchValue,'][',filtCategory,'][',filtValue,'][',itoa(startfrom),'][',itoa(itemcount),'][',srchType,'][',itoa(IdAsHTTP),';;',itoa(ArtworkAsURL),';;][]'"); 
}

Define_Function fnBLINKTX_API_FindTracks(integer when,integer unit,integer org_grp, integer org_type, integer org_id, char org_data[],
										char filt1Category[], char filt1Value[], char filt2Category[], char filt2Value[], char srchString[], char srchType[],
										long startfrom, long itemcount, integer IdAsHTTP, integer ArtworkAsURL)
{
    fnBLINKTX_SendUnitPacket(when,unit,org_grp,org_type,org_id,org_data,MSG_FindTracks,
    "'[',srchString,';;',srchType,';;][',filt1Category,'][',filt1Value,'][',filt2Category,'][',filt2Value,'][',itoa(startfrom),'][',itoa(itemcount),'][',itoa(IdAsHTTP),';;',itoa(ArtworkAsURL),'][]'");
}

Define_Function fnBLINKTX_API_AudioQueueAdd(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone,
										char rootCategory[], char subCategory[], char filtCategory[], char filtValue[],
										sinteger trackindex, long playindex ,integer insertmode)
{
    fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_AudioQueueAdd,
    "'[',rootCategory,'][',subCategory,'][',itoa(trackindex),'][',itoa(playindex),'][',itoa(insertmode),'][',filtCategory,'][',filtValue,'][][]'"); 
}
Define_Function fnBLINKTX_API_AudioQueueAddIDs(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone,
										char trackidlist[], integer playindex, integer insertmode)
{
    fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_AudioQueueAddIDs,"'[',trackidlist,'][',itoa(playindex),'][',itoa(insertmode),'][][][][][][]'"); 
}
Define_Function fnBLINKTX_API_AudioQueuePlay(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone, long playindex)
{
    fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_AudioQueuePlay,"'[',itoa(playindex),'][][][][][][][][]'"); 
}
Define_Function fnBLINKTX_API_AudioQueueClear(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone)
{
    fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_AudioQueueClear,"'[][][][][][][][][]'"); 
}
Define_Function fnBLINKTX_API_AudioQueueRemove(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone, long itemindex)
{
    fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_AudioQueueRemove,"'[',itoa(itemindex),'][][][][][][][][]'"); 
}
Define_Function fnBLINKTX_API_SetPlayMode(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone, char playmode[])
{
    fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_SetPlayMode,"'[',playmode,'][][][][][][][][]'"); 
}
Define_Function fnBLINKTX_API_SetSongPosition(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone, integer songpos)
{
    fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_SetSongPosition,"'[',itoa(songpos),'][][][][][][][][]'"); 
}
Define_Function fnBLINKTX_API_GetSongPosition(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone)
{
    fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_GetSongPosition,"'[][][][][][][][][]'"); 
}
//Define_Function fnBLINKTX_API_PlayListAdd(integer org_grp, integer org_type, integer org_id, char org_data[], integer zone)
//{
//	fnBLINKTX_SendZonePacket(org_grp,org_type,org_id,org_data,zone,'PlaylistAdd',"'[',,'][',,'][',,'][',,'][',,'][',,'][',,'][',,'][',,']'"); 
//}
//Define_Function fnBLINKTX_API_PlayListRemove(integer org_grp, integer org_type, integer org_id, char org_data[], integer zone)
//{
//	fnBLINKTX_SendZonePacket(org_grp,org_type,org_id,org_data,zone,'PlaylistRemove',"'[',,'][',,'][',,'][',,'][',,'][',,'][',,'][',,'][',,']'"); 
//}
//Define_Function fnBLINKTX_API_PlayListClear(integer org_grp, integer org_type, integer org_id, char org_data[], integer zone)
//{
//	fnBLINKTX_SendZonePacket(org_grp,org_type,org_id,org_data,zone,'PlaylistClear',"'[',,'][',,'][',,'][',,'][',,'][',,'][',,'][',,'][',,']'"); 
//}
//Define_Function fnBLINKTX_API_PlayListDelete(integer org_grp, integer org_type, integer org_id, char org_data[], integer zone)
//{
//	fnBLINKTX_SendZonePacket(org_grp,org_type,org_id,org_data,zone,'PlaylistDel',"'[',,'][',,'][',,'][',,'][',,'][',,'][',,'][',,'][',,']'"); 
//}
Define_Function fnBLINKTX_API_GetCoverArtFile(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], char albumid[])
{
    fnBLINKTX_SendServerPacket(when,org_grp,org_type,org_id,org_data,MSG_GetCoverArtFile,"'[',albumid,'][][][][][][][][]'"); 
}
Define_Function fnBLINKTX_API_VideoRequestMETAData(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], char movietitle[])
{
    fnBLINKTX_SendServerPacket(when,org_grp,org_type,org_id,org_data,MSG_VideoRequestMeta,"'[',movietitle,'][][][][][][][][]'"); 
}

/**
	when
	org_grp
	org_type
	org_id
	org_data[]
	srchCategory[]
	srchValue[]
	filtCategory[]
	filtValue[]
	srchType[]
	mediaType[]
	maxRating
	startfrom
	itemcount
*/
Define_Function fnBLINKTX_API_FindMovies(
    integer when,
    integer org_grp,
    integer org_type,
    integer org_id,
    char org_data[],
    char srchCategory[],
    char srchValue[],
    //char filtCategory[],
    //char filtValue[],
    char srchType[],
    char mediaType[],
    integer maxRating,
    long startfrom,
    long itemcount)
{
	fnBLINKTX_SendServerPacket(when,org_grp,org_type,org_id,org_data,MSG_FindMovies,
	"'[][][',srchCategory,'][',srchValue,'][',itoa(startfrom),'][',itoa(itemcount),'][1][][]'");
	//"'[',itoa(maxRating),'][',mediaType,'][',srchCategory,'][',srchValue,'][',itoa(startfrom),'][',itoa(itemcount),'][',srchType,']'"); 
	//"'[][][][][',itoa(startfrom),'][',itoa(itemcount),'][1][][]'"); 
	//"'[',mediaType,'][',itoa(maxRating),'][',srchCategory,'][',srchValue,'][',filtCategory,'][',filtValue,'][',itoa(startfrom),'][',itoa(itemcount),'][',srchType,']'"); 
}

Define_Function fnBLINKTX_API_FindMovieGroups(integer when,integer org_grp, integer org_type, integer org_id, char org_data[],
	char srchCategory[], char srchValue[],
	char filtCategory[], char filtValue[],
	char srchType[],
	char mediaType[], integer maxRating, long startfrom, long itemcount)
{
	fnBLINKTX_SendServerPacket(when,org_grp,org_type,org_id,org_data,MSG_FindMovieGroups,
	"'[',itoa(maxRating),'][',srchCategory,'][][][][',itoa(startfrom),'][',itoa(itemcount),'][][]'"); 
}

/**
	when
	org_grp
	org_type
	org_id
	org_data[]
	zone
	videoURL[]
*/
Define_Function fnBLINKTX_API_PlayMovie(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone, char videoURL[])
{
    fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_PlayMovie,"'[',videoURL,'][][][][][][][][]'"); 
}

Define_Function fnBLINKTX_API_RequestRelatedMovies(integer when,integer org_grp, integer org_type, integer org_id, char org_data[],
										char mediaType[], char videoURL[], long startfrom, long itemcount, integer maxRating)
{
	fnBLINKTX_SendServerPacket(when,org_grp,org_type,org_id,org_data,MSG_RequestRelatedMovies,
	"'[',mediaType,'][][',videoURL,'][',itoa(startfrom),'][',itoa(itemcount),'][',itoa(maxRating),'][][][]'"); 
}
Define_Function fnBLINKTX_API_SetDVDAudioOutput(integer when, integer org_grp, integer org_type, integer org_id, char org_data[], integer zone,
										char outType[])
{
	fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_SetDVDAudioOutput, "'[',outType,'][][][][][][][][]'"); 
}

Define_Function fnBLINKTX_API_GUISetOutputAndScreen(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone,
										char menu[], char subMenu[])
{
	fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_GUISetOutputScreen,
	"'[',menu,'][',subMenu,'][][][][][][][]'"); 
}
Define_Function fnBLINKTX_API_IRCmd(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone, char ircmd[])
{
	fnBLINKTX_SendZonePacket(when,org_grp,org_type,org_id,org_data,zone,MSG_IRCmd,"'[',ircmd,'][][][][][][][][]'"); 
}

Define_Function fnBLINKTX_GUI_API_IRCmd(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone, char ircmd[])
{
	fnBLINKTX_SendGUIPacket(when,org_grp,org_type,org_id,org_data,zone,MSG_IRCmd,"'[',ircmd,'][][][][][][][][]'"); 
}

///////////////////////////////////////////////////////////////////// General Initialization
Define_Function fnBrowser_Init()
{
	//// Setup the ui holding var with available info
	integer devs;
	
	// Number of uis is the sames as the panel devs passed into the module
	devs = Length_Array(dvPanels);
	Set_Length_Array(uis,devs);
	
	//if(devs)
//	{
//		integer ui;
//		for(ui=1; ui <= devs; ui++)
//		{
//			// Save the device number
//			THIS_UI.device	= dvPanels[ui];
//			//THIS_UI.type = DEVICE_ID(dvPanels[ui]);
//			
//			fnBrowser_InitUI(ui);
//		}
//		
//	}
}

///////// Initialize The UI
Define_Function fnBrowser_InitUI(integer ui)
{
    CHECK_UI
    {
	integer br;
	_BLINK_DATASET null_dataset;
	_G4_IMG_CACHE null_cache[BRWSR_MAX_PAGESIZE];
	
	// Init the browsers themselves
	if(THIS_UI.initialised == FALSE)
	{
	    for(br=1; br <= BRWSR_MAX_CATEGORIES; br++)
	    {
		THIS_BRWSR.dataset	= null_dataset;
		THIS_BRWSR.ds_covers_cache = null_cache;
		fnBrowser_DS_InitContentQuery(ui,br);
	    }
	    
	    // Default browser, zone.
	    THIS_UI.curbrowser = BRWSR_CAT_NULL;
	    THIS_UI.curzone	   = 1;
	    THIS_UI.playaddbtn_hold = 0;
    
	    // Create the Dynamic Image resources
	    {
		integer i;
		
		for(i=1; i <= BRWSR_MAX_PAGESIZE; i++)
		{
		    send_command THIS_UI.device,"'^RAF-',BRWSR_G4DYNIMG_COVERRESOURCE,itoa(i),',%R0%N0'"; // G4 only
		    send_command THIS_UI.device,"'^RAF-',BRWSR_G4DYNIMG_SIMCOVERRESOURCE,itoa(i),',%R0%N0'"; // G4 only
		}
	    }
    
	    // Watch for DMS panels
	    fnBrowser_DMSMonitorAgent(ui);
	    
	    if(THIS_UI.devinfo.device_id_string == 'Mio R4') {}
	    
	    // Update with current status
	    fnBrowserUIUpdate_CurCategory(ui);
	    fnBrowserUIUpdate_SelectedItem(ui,THIS_UI.curBrowser,0);
	    if(THIS_UI.devinfo.device_id_string != 'Mio R4') fnBrowserUIUpdate_Page(ui,THIS_UI.curBrowser);
	    if(THIS_UI.devinfo.device_id_string != 'Mio R4') fnBrowserUIUpdate_Page(ui,BRWSR_CAT_SIMILAR);
	    fnBrowserUIUpdate_PageNumber(ui,THIS_UI.curBrowser);
	    fnBrowserUIUpdate_SearchMode(ui);
	    fnBrowserUIUpdate_SearchText(ui);
	    fnPlaybackUIUpdate_PlayMode(ui,THIS_UI.curzone);
	    fnPlaybackUIUpdate_Transport(ui,THIS_UI.curzone);
	    fnPlaybackUIUpdate_PlayDuration(ui,THIS_UI.curzone);
	    fnPlaybackUIUpdate_NowPlaying(ui,THIS_UI.curzone);
	    fnPlaybackUIUpdate_PlayTime(ui,THIS_UI.curzone);
	    fnPlaybackUIUpdate_PlayChapter(ui,THIS_UI.curzone);
	    fnPlaybackUIUpdate_DMS_Status(ui,THIS_UI.curzone);
	    fnPlaybackUIUpdate_ZoneNames(0);
	    fnPlaybackUIUpdate_PlayoutZone(ui);
	    fnUIUpdate_About(ui);
	    fnUIUpdate_CommState(ui);
	}
	
	THIS_UI.initialised = TRUE;
    }
}

///////////////////////////////////////////////////////////////////// Browser Category Setting
Define_Function fnBrowser_SaveCategoryState(integer ui, integer newbr)
{
    CHECK_UI
    {
	integer libraryType;
	
	libraryType = fnHelper_GetLibraryType(newbr);
	
	THIS_UI.curBrowser = newbr
	THIS_UI.curLibrary = libraryType;
	
	switch(libraryType)
	{
	    case LIBRARY_AUDIO: if(newbr != BRWSR_CAT_PLAYQ) THIS_UI.lastAudioBr = newbr; // Dont save the Playqueue as its not a content browser
	    case LIBRARY_VIDEO: THIS_UI.lastVideoBr = newbr;
	}
    }
}
Define_Function fnBrowser_SetBrowseCategory(integer ui, integer newbr, integer reset)
{
    /* DEBUG
    switch(newbr)
    {
	case BRWSR_CAT_PLAYLISTS:
	{
	    fnSendDebugMsg("'DP88!'");
	    return;
	}	
    }
    fnSendDebugMsg("'DP99!'");
    */
    
    CHECK_UI
    {
	integer br;
	br = newbr;
	
	// Check the browser category value and set
	CHECK_BROWSER
	{
	    integer createdata;
	    
	    // Check for dataset not setup
	    if(!fnBrowser_DS_CheckOk(ui,br))
	    {
		createdata++;
	    }
	    
	    // Category directly selectly so cancel the seeded search 
	    if(THIS_BRWSR.dataset.isSeeded and reset)
	    {
		THIS_BRWSR.dataset.isSeeded = 0;
		THIS_BRWSR.dataset.seed_br	= 0;
		createdata++;
	    }
	    
	    // Category directly selectly so cancel the text search too
	    if(THIS_BRWSR.dataset.isSearch and reset)
	    {
		THIS_BRWSR.dataset.isSearch = 0;
		THIS_BRWSR.dataset.queryfilter = "";
		createdata++;
	    }
	    
	    if(reset) createdata++;
	    
	    // Save the history trail
	    if(newbr != THIS_UI.curbrowser) // Only if changing
	    {
		//// Figure wether to save the browse history/trail
		if(fnHelper_IsContentBrowser(newbr))
		{
		    THIS_UI.prevBrowser = newbr;					
		}
		
		fnBrowser_SaveCategoryState(ui, newbr);
	    }
	    
	    //// Update the list UI for content browsers and the play queue
	    if(fnHelper_IsContentBrowser(newbr) or newbr == BRWSR_CAT_PLAYQ)
	    {
		if(createdata)
		{
		    // Clear the seeding trail
		    fnBrowser_ClearHistory(ui);
		    fnBrowser_DS_CreateContentQuery(ui,br,FALSE);
		}
		else
		{
		    fnBrowserUIUpdate_Page(ui,br);
		    fnBrowserUIUpdate_PageNumber(ui, br);
		}
		
		// Update a few UI bits
		fnBrowserUIUpdate_DS_Pageitem(ui,br,THIS_BRWSR.selected);
		fnBrowserUIUpdate_CurCategory(ui);
		fnBrowserUIUpdate_SelectedItem(ui,br,0);
		fnBrowserUIUpdate_BrowserIcons(ui);
		fnBrowserUIUpdate_SearchText(ui);
		fnBrowserUIUpdate_SearchMode(ui);
		
		// Auto seeding the 'Related' or Similar browser and change the forward path
		switch(br)
		{
		    case BRWSR_CAT_ARTISTS:
		    case BRWSR_CAT_ALBUMS:
		    case BRWSR_CAT_ALBUMCOVERS:
		    case BRWSR_CAT_GENRES:
		    case BRWSR_CAT_PLAYLISTS:
		    case BRWSR_CAT_RADIOGENRES:
		    {
			fnBrowser_ClearForwardPaths(ui,BRWSR_CAT_SIMILAR);
			fnBrowser_DefineForwardPath(ui,BRWSR_CAT_SIMILAR, 1, BRWSR_CAT_TRACKS);
			fnBrowser_SeedBrowser(ui,br,BRWSR_CAT_SIMILAR,FALSE);
		    }
		    case BRWSR_CAT_MOVIES:
		    case BRWSR_CAT_ACTORS:
		    case BRWSR_CAT_DIRECTORS:
		    case BRWSR_CAT_MOVIEGENRES:
		    {
			fnBrowser_ClearForwardPaths(ui,BRWSR_CAT_SIMILAR);
			fnBrowser_SeedBrowser(ui,br,BRWSR_CAT_SIMILAR,FALSE);
		    }
		}
	    }
	    
	    // Save the last content browser uless its the play q
	    if(br != BRWSR_CAT_PLAYQ) THIS_UI.lastselected_br = br;
	}
    }
}

Define_Function fnBrowser_ShowNowPlaying(integer ui)
{
    CHECK_UI
    {
	//fnBrowser_SetBrowseCategory(ui,BRWSR_NOWPLAYING,FALSE);
	fnBrowser_RestoreBrowser(ui,BRWSR_NOWPLAYING);
    }
}

Define_Function fnBrowser_ClearHistory(integer ui)
{
    CHECK_UI
    {
	integer br;
	for(br=1; br <= BRWSR_MAX_CATEGORIES; br++)
	{
	    THIS_BRWSR.refBrowser = BRWSR_CAT_NULL;
	}
    }
}

Define_Function fnBrowser_SetPageSize(integer ui, integer targetbr, integer pagesize)
{
    integer br;
    
    if(targetbr)	br = targetbr;
    else		 	br = BRWSR_MAX_CATEGORIES; 

    CHECK_UI
    {
	// Guard condition for setting default page size
	if(targetbr == 0)
	{	
	    if(pagesize != THIS_UI.defaultpagesize)
		THIS_UI.defaultpagesize = pagesize;
	    else 
		return;
	}
	
	while(br)
	{
	    // Only do it if different
	    if(THIS_BRWSR.dataset.pagesize != pagesize)
	    {
		THIS_BRWSR.dataset.pagesize = pagesize; 
		
		if(THIS_UI.curBrowser)
		{
		    if(targetbr == THIS_UI.curBrowser)
		    {
			fnBrowserUIUpdate_PageNumber(ui,br);
			fnBrowser_DS_CreateContentQuery(ui,br,FALSE);
		    }
		}
	    }
	    
	    br--;
	    if(targetbr) break; // Just the one?
	}
    }
}
Define_Function fnBrowser_DMSMonitorAgent(integer ui)
{
    CHECK_UI
    {
	if(find_string(THIS_UI.devinfo.device_id_string,"'DMS'",1))
	{
	    THIS_UI.isDMS = 1;
	    
	    // Set the page size to the default for the DMS
	    fnBrowser_SetPageSize(ui,0,BRWSR_MAX_DMS_PAGESIZE);
	}
	else
	{
	    THIS_UI.isDMS = 0;
	    
	    // Check if we need to reset this UI
	    if(THIS_UI.browsers[BRWSR_CAT_ARTISTS].dataset.pagesize < BRWSR_MAX_PAGESIZE)
	    {
		fnBrowser_SetPageSize(ui,0,BRWSR_MAX_PAGESIZE);
	    }
	}
    }
}
Define_function fnBrowserUIUpdate_CurCategory(integer ui)
{
    CHECK_UI
    {
	integer br;
	br = THIS_UI.curbrowser;
	
	CHECK_BROWSER
	{
	    char icon[2];
	    
	    // Change the Browser Category Name Text
	    send_command THIS_UI.device,"'^UNI-',itoa(vtx_Brws_CategoryName),',0,',CP1251ToUNI(fnHelper_BrowserCatTOString(br,FALSE))";
	    
	    // Change the Browser Category Icon
	    icon = "fnHelper_BrowserCatTOFontSymbolChar(br)";
	    if(THIS_DATASET.isSearch) icon = "icon,XIVAFONT_CHAR_SEARCH";
	    send_command THIS_UI.device,"'^UNI-',itoa(vtx_Brws_CategoryIcon),',0,',CP1251ToUNI(icon)";
	}
	else
	{
	    send_command THIS_UI.device,"'!T',vtx_Brws_CategoryName,'- -'";
	    send_command THIS_UI.device,"'!T',vtx_Brws_CategoryIcon";
	}
	
	// Update the forward paths
	fnBrowserUIUpdate_ForwardPaths(ui,br);
	
	// Do the button feedback
	for(br=1; br <= BRWSR_MAX_CATEGORIES; br++)
	{
	    integer btn;
	    btn = btn_BrwsCategories[br];
	    [THIS_UI.device,btn] = THIS_UI.curbrowser == br;
	}
    }
}

Define_function fnBrowserUIUpdate_BrowserIcons(integer ui)
{
    CHECK_UI
    {
	integer br;
	br = THIS_UI.curbrowser;
	
	CHECK_BROWSER
	{
	    char icon[2];
	    
	    // Change the Browser Category Icon
	    icon = "fnHelper_BrowserCatTOFontSymbolChar(br)";
	    if(THIS_DATASET.isSearch) icon = "XIVAFONT_CHAR_SEARCH,icon";
	    send_command THIS_UI.device,"'^UNI-',itoa(vtx_Brws_CategoryIcon),',0,',CP1251ToUNI(icon)";
	    
	    [THIS_UI.device,btn_Brws_CategoryIcon] = THIS_DATASET.isSearch;
	}
    }
}

///////////////////////////////////////////////////////////////////// Browser item selection setting
Define_Function fnBrowser_SetSelectItem(integer ui, integer br, integer item)
{
    CHECK_UI
    CHECK_BROWSER
    {
	if(item && item <= THIS_BRWSR.dataset.pagesize)
	{
	    if(item <= THIS_BRWSR.dataset.linecount)
	    {
		integer browserchange;
		
		// Save the item selection
		THIS_BRWSR.selected = item;
		
		// Watch for selection from the related list
		if(br != THIS_UI.lastselected_br)
		    browserchange++;
		THIS_UI.lastselected_br	= br;
		
		fnBrowserUIUpdate_SelectedItem(ui,br,0);
		fnBrowserUIUpdate_PageNumber(ui,br);
		
		// Depending on the browse type seed the similar media browser
		switch(br)
		{
		    case BRWSR_CAT_ALLTRACKS:
		    case BRWSR_CAT_ARTISTS:
		    case BRWSR_CAT_ALBUMS:
		    case BRWSR_CAT_ALBUMCOVERS:
		    case BRWSR_CAT_GENRES:
		    case BRWSR_CAT_MOVIES:
		    //case BRWSR_CAT_MOVIECOVERS:
		    case BRWSR_CAT_ACTORS:
		    case BRWSR_CAT_DIRECTORS:
		    case BRWSR_CAT_MOVIEGENRES:
		    {	
			fnBrowser_SeedBrowser(ui,br,BRWSR_CAT_SIMILAR,FALSE);
		    }
		    case BRWSR_CAT_SIMILAR:
		    {
			if(THIS_UI.curBrowser == BRWSR_CAT_TRACKS)// and THIS_DATASET.seed_br != BRWSR_CAT_TRACKS)
			{
			    fnBrowser_SeedBrowser(ui,br,BRWSR_CAT_TRACKS,FALSE);
			}
		    }
		}
		
		if(browserchange) fnBrowserUIUpdate_ForwardPaths(ui,br);
	    }
	}
    }
}

/**
    Переход на элемент выше
    на входе	:	ui	- интерфейс
    на выходе	:	*
*/
Define_Function fnBrowser_ItemSelectUP(integer ui)
{
    CHECK_UI
    {
	integer br, fetch;
	
	br = THIS_UI.curbrowser;
	CHECK_BROWSER
	{
	    integer curritem;
	    integer newitem;
	    
	    // Check for no selection
	    curritem = THIS_BRWSR.selected;
	    
	    if(curritem) newitem = curritem-1;
	    
	    if(newitem)
	    {
		fnBrowser_SetSelectItem(ui,br,newitem);
	    }
	    else
	    {
		THIS_BRWSR.selected = THIS_BRWSR.dataset.pagesize;
		fnBrowser_PageUP(ui,br);
	    }
	}
    }
}

/**
    Переход на элемент ниже
    на входе	:	ui	- интерфейс
    на выходе	:	*
*/
Define_Function fnBrowser_ItemSelectDW(integer ui)
{
    CHECK_UI
    {
	integer br, fetch;
	
	br = THIS_UI.curbrowser;
	CHECK_BROWSER
	{
	    integer curritem;
	    integer newitem;
	    
	    // Check for no selection
	    curritem = THIS_BRWSR.selected;
	    
	    newitem = curritem+1;
	    
	    if(newitem <= THIS_DATASET.linecount)
	    {
		fnBrowser_SetSelectItem(ui,br,newitem);
	    }
	    else
	    {
		THIS_BRWSR.selected = 1;
		fnBrowser_PageDW(ui,br);
	    }
	}
    }
}

/**
    Получение текста выбранного элемента
    на входе	:	ui	- интерфейс
			br	- браузер
    на выходе	:	текст элемента
*/
Define_Function char[MAX_ITEMNAME] fnBrowser_GetSelectedItemText(integer ui, integer br)
{
    CHECK_UI
    CHECK_BROWSER
    {
	integer selected;
	
	selected = THIS_BRWSR.selected;
	
	if(selected) return THIS_BRWSR.ds_items[selected].text;
	
	return 'Nothing Selected';
    }
}

/**
    Получение текста запроса выбранного элемента
    на входе	:	ui	- интерфейс
			br	- браузер
    на выходе	:	текст запроса элемента
*/
Define_Function char[MAX_ITEMNAME] fnBrowser_GetSelectedItemQText(integer ui, integer br)
{
    CHECK_UI
    CHECK_BROWSER
    {
	integer selected;
	
	selected = THIS_BRWSR.selected;
	
	if(selected) return THIS_BRWSR.ds_items[selected].qtext;
	
	return 'Nothing Selected';
    }
}

/**
    Получение ссылки выбранного элемента
    на входе	:	ui	- интерфейс
			br	- браузер
    на выходе	:	ссылка элемента
*/
Define_Function integer fnBrowser_GetReferer(integer ui, integer br)
{
    CHECK_UI
    CHECK_BROWSER
    {
	integer br_ref;
	
	br_ref = THIS_BRWSR.refBrowser;
	
	// The browser cant seed itself so watch for a dodgy ref
	if(br_ref != br) return br_ref;
    }
    
    return 0;
}

Define_Function integer fnBrowser_GetSeeder(integer ui, integer br)
{
    CHECK_UI
    CHECK_BROWSER
    {
	integer seed_br;
	
	seed_br = THIS_DATASET.seed_br;
	
	// The browser cant seed itself so watch for a dodgy ref
	if(seed_br != br) return seed_br;
    }
    
    return 0;
}

Define_Function fnBrowserUIUpdate_SelectedItem(integer ui, integer br, integer bNavTextOnly)
{
    CHECK_UI
    {
	CHECK_BROWSER
	if(br == THIS_UI.curBrowser) // Check this is the live browser
	{
	    char sNAVText[64];
	    char sMediaId[24];
	    integer selitem;
	    integer vtx;
		    
	    // get the var text address
	    if(br == BRWSR_CAT_SIMILAR)
		vtx = vtx_Brws_SimilarNavInfo;
	    else
		vtx = vtx_Brws_NavInfo;
	    
	    // Watrch for the selected item being invalid
	    if(THIS_BRWSR.selected > THIS_DATASET.linecount)
		THIS_BRWSR.selected = THIS_DATASET.linecount;
	    
	    selitem = THIS_BRWSR.selected;
	    
	    ////////////////////////////// Navigation info text
	    // Check Browser for search mode
	    if(THIS_BRWSR.dataset.isSeeded or THIS_BRWSR.dataset.isSearch)
	    {
		char referers[MAX_DS_LONGFIELD];
		char searchinfo[MAX_DS_LONGFIELD];
		
		// Get the seeding history
		if(THIS_DATASET.isSeeded)
		{
		    integer hops;
		    integer br_path;
		    integer oldbr_path;
		    integer br_ref1;
		    integer br_ref2;
		    
		    //// Count the number of hops it took to get here
		    br_path = fnBrowser_GetSeeder(ui,br);
		    while(br_path)
		    {
			hops++;
			oldbr_path = br_path;
			
			// Check for another hop...
			br_path = fnBrowser_GetSeeder(ui,br_path);
			
			// Check for a browser seeding loop
			if(fnBrowser_GetSeeder(ui,br_path) == oldbr_path)
			{
			    fnSendDebugMsg('fnBrowserUIUpdate_SelectedItem(): Exiting Browser Hop counter.');
			    break;
			}
		    }
		    
		    // Get the last 2 referers
		    br_ref1 = fnBrowser_GetSeeder(ui,br);
		    br_ref2 = fnBrowser_GetSeeder(ui,br_ref1);
		    
		    // Depending on how many hops we make the display text will be different
		    switch(br)
		    {
			case BRWSR_CAT_SIMILAR:
			{
			    switch(br_ref1)
			    {
				//// Audio
				case BRWSR_CAT_ALBUMS:
				case BRWSR_CAT_ALBUMCOVERS:
				case BRWSR_CAT_ALLTRACKS:
				{
				    if(selitem)
					referers = "'Also by ',fnBrowser_GetSelectedItemQText(ui,br),': ',fnBrowser_GetSelectedItemText(ui,br)";
				    else
					referers = "'Also by ',fnBrowser_GetSelectedItemQText(ui,br_ref1),':'";
				}
				case BRWSR_CAT_ARTISTS:
				{
				    if(selitem)
					referers = "'Albums by ',fnBrowser_GetSelectedItemQText(ui,br),': ',fnBrowser_GetSelectedItemText(ui,br)";//"fnBrowser_GetSelectedItemText(ui,br),' ~ ',fnBrowser_GetSelectedItemText(ui,br_ref1)";
				    else
					referers = "'Albums by ',fnBrowser_GetSelectedItemText(ui,br_ref1),':'";
				}
				case BRWSR_CAT_GENRES:
				{
				    if(selitem)
					referers = "fnBrowser_GetSelectedItemText(ui,br),' ~ ',fnBrowser_GetSelectedItemQText(ui,br)";
				    else
					referers = "'Similar Albums:'";
				}
				//// Video
				case BRWSR_CAT_MOVIES:
				case BRWSR_CAT_MOVIECOVERS:
				{
				    if(selitem)
					referers = "fnBrowser_GetSelectedItemText(ui,br)";
				    else
					referers = "'Similar Movies:'";
				}
				case BRWSR_CAT_ACTORS:
				{
				    if(selitem)
					referers = "fnBrowser_GetSelectedItemText(ui,br),', staring ',fnBrowser_GetSelectedItemText(ui,br_ref1)";
				    else
					referers = "'Movies Staring: ',fnBrowser_GetSelectedItemText(ui,br_ref1)";
				}
				case BRWSR_CAT_DIRECTORS:
				{
				    if(selitem)
					referers = "fnBrowser_GetSelectedItemText(ui,br),', directed by ',fnBrowser_GetSelectedItemText(ui,br_ref1)";
				    else
					referers = "'Movies Directed by: ',fnBrowser_GetSelectedItemText(ui,br_ref1)";
				}
				case BRWSR_CAT_MOVIEGENRES:
				{
				    if(selitem)
					referers = "fnBrowser_GetSelectedItemText(ui,br_ref1),' Movie: ',fnBrowser_GetSelectedItemText(ui,br)";
				    else
					referers = "'Movies of Genre: ',fnBrowser_GetSelectedItemText(ui,br_ref1)";
				}
				default:
				{
				    if(selitem)
					referers = "THIS_DATASET.queryseed,'-->',fnBrowser_GetSelectedItemText(ui,br)";
				    else
					referers = "THIS_DATASET.queryseed";
				}
			    }
			}
			case BRWSR_CAT_TRACKS:
			{
			    referers = "THIS_DATASET.queryseed";
			}
			default:
			{
			    switch(hops)
			    {
				case 1:	referers = "fnBrowser_GetSelectedItemText(ui,br_ref1)";
				case 2:	referers = "fnBrowser_GetSelectedItemText(ui,br_ref2),'-->',fnBrowser_GetSelectedItemText(ui,br_ref1)";
				default: referers = "'пїЅ-->',fnBrowser_GetSelectedItemText(ui,br_ref2),'-->',fnBrowser_GetSelectedItemText(ui,br_ref1)";
			    }
			}
		    }
		    
		    // Special case when viewing tracks from a PlayQ selection
		    switch(THIS_BRWSR.refBrowser)
		    {
			case BRWSR_CAT_PLAYQ:
			{
			    if(hops < 3)
				referers = "'PlayQ-->',referers";
			    else
				referers = "'PlayQ',referers";
			}
		    }
		}
		
		// Add the search text
		if(THIS_DATASET.isSearch)
		{
		    switch(THIS_DATASET.searchmode)
		    {
			case DS_SRCHMODE_BEGINS:	searchinfo = "'that begin with'";
			case DS_SRCHMODE_CONTAINS:	searchinfo = "'that contain'";
			case DS_SRCHMODE_JUMP:		searchinfo = "'page containing'";
		    }
		    
		    searchinfo = "searchinfo,' "',lower_string(THIS_DATASET.queryfilter),'"'";
		}
		
		select
		{
		    active(THIS_DATASET.isSeeded and THIS_DATASET.isSearch): sNAVText = "referers,' [ ',searchinfo,' ]'";
		    active(THIS_DATASET.isSeeded):	sNAVText = referers;
		    active(THIS_DATASET.isSearch):	sNAVText = searchinfo;
		    active(1): sNAVText = THIS_BRWSR.ds_items[selitem].text;
		}
	    }
	    // Normal mode
	    else
	    {
		if(selitem) sNAVText = "THIS_BRWSR.ds_items[selitem].text";
		else		sNAVText = "'Nothing Selected.'";
	    }
	    
	    // Send the navigation info text
	    send_command THIS_UI.device,"'^UNI-',itoa(vtx),',0,',CP1251ToUNI(sNAVText)";
	    
	    ////////////////////// META DATA VIEW - Update the Selected item Meta Data Viewer
	    if(0) // Disabled in this project
	    if(selitem) // Check Indexer
	    {
		// Update the text and selected item cover art only if this browser is the live one.
		if(br == THIS_UI.curBrowser)
		{
		    char id[MAX_DS_GUID];
		    char coverURI[MAX_DS_GUID];
		    
		    // Send the text to the panel
		    send_command THIS_UI.device,"'^UNI-',itoa(vtx_BrwsSelItemMETA_Name),',0,',CP1251ToUNI(THIS_BRWSR.ds_items[selitem].text)";
		    
		    // Get the item unique id.
		    id = THIS_BRWSR.ds_items[selitem].id;
		    coverURI = THIS_BRWSR.ds_items[selitem].cover_path;
		    
		    // Do the cover art if not G3
		    //if(!fnIsAxlinkDev(THIS_UI.device))
		    {
			// Check for an id string
			if(id != "")
			{
			    _COVERART_URL urlstruct;
			    fnHelper_CoverURIToHostPathFile(coverURI,urlstruct);
			    // Add the Dynamic image resource and save the resource name as the icon name
			    send_command THIS_UI.device,"'^RAF-BLinkSelCoverArt,%R0%N0'"; // G4 only
			    //send_command THIS_UI.device,"'^RMF-BLinkSelCoverArt,%P0%H',BLink.comms.url,':',itoa(BLink.about.coverart_port),'%A',id,'%Ffolder.jpg'"; // G4 only
			    send_command THIS_UI.device,"'^RMF-BLinkSelCoverArt,%P0%H',urlstruct.host,'%A',urlstruct.path,'%F',urlstruct.file"; // G4 only
			    // Assign the dynamic image to the button first removing any iconslot assigned
			    Send_Command THIS_UI.device,"'^ICO-',itoa(vtx_BrwsSelCoverArt),',1&2,0'"; // G4
			    Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_BrwsSelCoverArt),',1&2,BLinkSelCoverArt'"; // G4 Only
			}
			else // if (mediaid == MUID_NOITEM) // Check for explicitly set 'no items flag'.
			{
			    if(fnHelper_GetLibraryType(br) == PAGE_LIBRARY_VIDEO) 
				Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_BrwsSelCoverArt),',0,EmptyDVDCase.png'"; // G4 Only
			    else
				Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_BrwsSelCoverArt),',0,EmptyCDCase.png'"; // G4 Only
			}
		    }
		}
	    }
	    // Nothing selected
	    else
	    {
		// Send the text to the panel
		send_command THIS_UI.device,"'!T',vtx_BrwsSelItemMETA_Name,'No Selection.'";
	
		// Null the cover art if not G3
		if(!fnIsAxlinkDev(THIS_UI.device))
		{
		    Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_BrwsSelCoverArt),',0,Dummy.jpg'"; // G4 Querk - jpg indicates normal image type not dynamic
		    
		    if(fnHelper_GetLibraryType(br) == PAGE_LIBRARY_VIDEO)
			Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_BrwsSelCoverArt),',0,EmptyDVDCase.png'"; // G4 Only
		    else
			Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_BrwsSelCoverArt),',0,EmptyCDCase.png'"; // G4 Only
		}
	    }
	    
	    
	    /////// Set the feedback for the list item selected highlighting
	    if(!bNavTextOnly)
	    {
		integer i;
		
		for(i=1; i <= THIS_BRWSR.dataset.pagesize; i++) 
		{
		    integer btn; 
		    
		    // Get the button to work with
		    if(br == BRWSR_CAT_SIMILAR)	btn = btn_BrwsList_SimilarMedia[i];
		    else 						btn = btn_BrwsList_Fields[i];
		    
		     // btn = btn_BrwsList_ByCategory[br][i];
		    
		    [THIS_UI.device,btn] = (i == selitem);
		}
	    }
	}
	// No Browse Category selected
	else
	{
	    // Send the text to the panel
	    send_command THIS_UI.device,"'!T',vtx_BrwsSelItemMETA_Name,'No Selection.'";
    
	    // Null the cover art if not G3
	    if(!fnIsAxlinkDev(THIS_UI.device))
	    {
		Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_BrwsSelCoverArt),',0,Dummy.jpg'"; // G4 Querk - jpg indicates normal image type not dynamic
		
		if(fnHelper_GetLibraryType(br) == PAGE_LIBRARY_VIDEO)
		    Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_BrwsSelCoverArt),',0,EmptyDVDCase.png'"; // G4 Only
		else
		    Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_BrwsSelCoverArt),',0,EmptyCDCase.png'"; // G4 Only
	    }
	}
    }
}
// Navigation. Makes the destination browser filter on the selected item from in the source browser.
Define_Function fnBrowser_SeedBrowser(integer ui, integer srcBrowser, integer destBrowser, integer savehistory)
{
    CHECK_UI
    {
	integer br, tbr, seed_br, dbr, sbr;
	br = srcBrowser;
	tbr = destBrowser; // AKA THAT_BRWSR
	seed_br = srcBrowser;  // May get corrected further down this function...
	
	CHECK_BROWSER
	{
	    integer selected;
	    selected = THIS_BRWSR.selected;
	    
	    // Something is selected
	    if(selected)
	    {
		char id[MAX_DS_GUID];
		char keytype[MAX_DS_QUERYSTRING];
		
		// Get the guid
		id = SRCE_BRWSR.ds_items[selected].id;
		
		//// Guard condition
		if(!destBrowser)
		{
		    fnSendDebugMsg('fnBrowser_SeedBrowser() destBrowser was null!');
		    return;
		}
		
		if(destBrowser == BRWSR_CAT_SIMILAR)
		{
		    switch(srcBrowser)
		    {
			case BRWSR_CAT_ALLTRACKS:
			case BRWSR_CAT_ALBUMS:
			case BRWSR_CAT_ALBUMCOVERS:
			{
			    DEST_BRWSR.dataset.querytype 	= 'Album';
			    DEST_BRWSR.dataset.queryseed_type	= 'Artist';
			    DEST_BRWSR.dataset.queryseed 	= SRCE_BRWSR.ds_items[selected].qtext;
			}
			default:
			{
			    if(fnHelper_GetLibraryType(srcBrowser) == LIBRARY_AUDIO)
				DEST_BRWSR.dataset.querytype = 'Album';
			    else
				DEST_BRWSR.dataset.querytype = 'Title';
			    DEST_BRWSR.dataset.queryseed_type	= SRCE_BRWSR.dataset.querytype;
			    DEST_BRWSR.dataset.queryseed 	= SRCE_BRWSR.ds_items[selected].text;
			}
		    }
		}
		else
		{
		    // Move the source browser query spec n the seed spec for the destination browser
		    DEST_BRWSR.dataset.queryseed_type 	= SRCE_BRWSR.dataset.querytype;
		    DEST_BRWSR.dataset.queryseed 	= SRCE_BRWSR.ds_items[selected].text;
		}
		
		// Set the current browser to be the destination browser;
		//if(destBrowser != BRWSR_CAT_SIMILAR)
		//	THIS_UI.curBrowser = destBrowser;
		
		THIS_UI.browsers[destBrowser].dataset.isSeeded	= TRUE;
		THIS_UI.browsers[destBrowser].dataset.seed_br	= seed_br;
		THIS_UI.browsers[destBrowser].selected 		= 0;
		
		if(seed_br == BRWSR_CAT_SIMILAR)
		{
			
		}
		
		
		if(savehistory)
		{
		    if(seed_br == BRWSR_CAT_SIMILAR)
			THIS_UI.browsers[destBrowser].refBrowser = SRCE_BRWSR.dataset.seed_br;
		    else
			THIS_UI.browsers[destBrowser].refBrowser = seed_br;
		    
		    fnBrowser_SaveCategoryState(ui,destBrowser);
		    //fnBrowserUIUpdate_ClearPage(ui);
		    fnBrowserUIUpdate_CurCategory(ui);
		    fnBrowserUIUpdate_BrowserIcons(ui);
		}
		
		fnBrowser_DS_CreateContentQuery(ui,destBrowser,FALSE);
		
	    }
	    else // Nothing selected so just clear the pages
	    {
		if(destBrowser == BRWSR_CAT_SIMILAR)
		{
		    fnBrowserUIUpdate_ClearPage(ui,BRWSR_CAT_SIMILAR);
		}
	    }
	}
    }
}


Define_Function fnBrowser_UseFwdPath(integer ui, integer fwp)
{
    CHECK_UI
    {
	integer br;
	//br = THIS_UI.curBrowser;
	br = THIS_UI.lastselected_br;
	
	CHECK_BROWSER
	{
	    CHECK_PATH
	    {	
		// Check this browser has foward paths
		if(Length_Array(THIS_BRWSR.fwdPaths))
		{
		    integer br_path;
		    br_path = THIS_PATH.browser;
		    
		    fnBrowser_SeedBrowser(ui,br,br_path,TRUE);
		}
	    }
	}
    }
}

Define_Function fnBrowser_BackUp(integer ui)
{
    CHECK_UI
    {
	integer br;
	br = THIS_UI.curbrowser;
	
	// Pressing back from the play Q or Now Playing should restore to the last content browser.
	CHECK_BROWSER
	{
	    switch(br)
	    {
		case BRWSR_CAT_PLAYQ:	if(THIS_UI.prevBrowser) fnBrowser_RestoreBrowser(ui,THIS_UI.prevBrowser);
		case BRWSR_NOWPLAYING: 	if(THIS_UI.prevBrowser) fnBrowser_RestoreBrowser(ui,THIS_UI.prevBrowser);
		default:		
		{
		    if(THIS_BRWSR.refBrowser) 	fnBrowser_RestoreBrowser(ui,THIS_BRWSR.refBrowser);
		    //else 						fnBrowser_LibraryHome(ui);
		}
	    }
	}
	else
	{
	    // Show the last current library root page
	    //fnBrowser_LibraryHome(ui);
	}
    }
}
Define_Function fnBrowser_RestoreBrowser(integer ui, integer br)
{
    CHECK_UI
    {
	char pagename[64];
	
	CHECK_BROWSER
	{			
	    fnBrowser_SetBrowseCategory(ui,br,0);
	}
	
	
	// Main Browser Popup
	switch(br)
	{
	    /// Audio Browers
	    case BRWSR_CAT_ARTISTS: 	
	    case BRWSR_CAT_ALBUMS: 		
	    case BRWSR_CAT_TRACKS:
	    case BRWSR_CAT_GENRES: 		
	    case BRWSR_CAT_ERAS: 		
	    case BRWSR_CAT_SIMILAR: 		
	    case BRWSR_CAT_ALLTRACKS:	pagename = 'BLink-Browser-Music-Main';
	    case BRWSR_CAT_PLAYLISTS:	pagename = 'BLink-Browser-Music-Playlists';
	    case BRWSR_CAT_ALBUMCOVERS:	pagename = 'BLink-Browser-Music-Covers';
	    
	    /// Net Radio
	    case BRWSR_CAT_STATIONS:	
	    case BRWSR_CAT_RADIOGENRES:	pagename = 'BLink-Browser-Music-Playlists';
	    
	    /// Video Browsers
	    case BRWSR_CAT_MOVIES:
	    case BRWSR_CAT_ACTORS:
	    case BRWSR_CAT_DIRECTORS:
	    case BRWSR_CAT_MOVIEGENRES:
	    case BRWSR_CAT_MOVIEYEARS:
	    case BRWSR_CAT_RATING:	pagename = 'BLink-Browser-Video-Main';
	    case BRWSR_CAT_MOVIECOVERS: pagename = 'BLink-Browser-Video-Covers';
	    
	    /// None Content
	    case BRWSR_CAT_PLAYQ: 	pagename = 'BLink-Browser-NowPlaying-PlayQueue';
	    
	    /// Library homes
	    case PAGE_LIBRARY_AUDIO:	pagename = 'BLink-Browser-Music-Main';
	    case PAGE_LIBRARY_VIDEO:	pagename = 'BLink-Browser-Video-Main';
	    case PAGE_LIBRARY_NETRADIO:	pagename = 'BLink-Browser-NetRadio-Main';
	    
	    /// Now Playing
	    case BRWSR_NOWPLAYING:	
	    {
		switch(fnHelper_GetPlaybackContext(THIS_UI.curzone,ui))
		{
		    case LIBRARY_AUDIO: pagename = 'BLink-Browser-NowPlaying'; // Only one Now playing page currently
		    case LIBRARY_VIDEO: pagename = 'BLink-Browser-NowPlaying'; // Only one Now playing page currently
		    case LIBRARY_RADIO: pagename = 'BLink-Browser-NowPlaying'; // Only one Now playing page currently
		    default:		pagename = 'BLink-Browser-NowPlaying'; // Only one Now playing page currently
		}
	    }
	    case PAGE_NOWPLAYING_AUD: 	pagename = 'BLink-Browser-NowPlaying';
	    case PAGE_NOWPLAYING_VID: 	pagename = 'BLink-Browser-NowPlaying';
	    
	    default:
	    {
		switch(THIS_UI.curLibrary)
		{
		    case LIBRARY_AUDIO: pagename = 'BLink-Browser-Music-Main'; // We'll have to add code to detect video/audio playback
		    case LIBRARY_VIDEO: pagename = 'BLink-Browser-Video-Main'; // We'll have to add code to detect video/audio playback
		    case LIBRARY_RADIO: pagename = 'BLink-Browser-NetRadio-Main'; // We'll have to add code to detect video/audio playback
		    default:		pagename = 'BLink-Browser-NowPlaying'; // We'll have to add code to detect video/audio playback
		}
	    }
	}
	
	/////////// DMS
	if(THIS_UI.isDMS)
	{
	    send_command THIS_UI.device,"'PAGE-',pagename";
	}
	/////////// Full Size nterface
	else
	{
	    send_command THIS_UI.device,"'@PPN-',pagename";
	    
	    // Context Popup
	    switch(br)
	    {
		case BRWSR_CAT_ARTISTS: 	
		case BRWSR_CAT_ALBUMS: 		
		case BRWSR_CAT_TRACKS: 		
		case BRWSR_CAT_ALLTRACKS: 		
		case BRWSR_CAT_GENRES: 		
		case BRWSR_CAT_ERAS: 		
		case BRWSR_CAT_SIMILAR: 		
		case BRWSR_CAT_PLAYLISTS:	
		case BRWSR_CAT_RADIOGENRES:
		case BRWSR_CAT_ALBUMCOVERS:
		{
		    send_command THIS_UI.device,'@PPN-BLink-ContextMenu-MusicLibrary';
		}
		
		//{
//					send_command THIS_UI.device,'@PPK-BLink-ContextMenu-DVDLibrary';
//					send_command THIS_UI.device,'@PPK-BLink-Menu-Search';
//					send_command THIS_UI.device,'@PPN-BLink-Output'; // Keep the output popup ontop as cover page is bigger
//				}
		case BRWSR_CAT_PLAYQ: 		send_command THIS_UI.device,'@PPN-BLink-ContextMenu-MiniNowPlaying'
		
		/// Net Radio
		//case BRWSR_CAT_STATIONS:	
		//case BRWSR_CAT_RADIOGENRES:	send_command THIS_UI.device,'@PPN-BLink-ContextMenu-NetRadio'
		
		/// Video Library
		case BRWSR_CAT_MOVIES:			
		case BRWSR_CAT_ACTORS:			
		case BRWSR_CAT_DIRECTORS:			
		case BRWSR_CAT_MOVIEGENRES:		
		case BRWSR_CAT_MOVIEYEARS:		
		case BRWSR_CAT_RATING:		
		case BRWSR_CAT_MOVIECOVERS:	send_command THIS_UI.device,'@PPN-BLink-ContextMenu-DVDLibrary'	
		
		/// Library homes
		case PAGE_LIBRARY_AUDIO:
		{
		    send_command THIS_UI.device,'@PPN-BLink-ContextMenu-MusicLibrary'
		}
		case PAGE_LIBRARY_VIDEO:	send_command THIS_UI.device,'@PPN-BLink-ContextMenu-DVDLibrary'
		
		/// Now playing
		case BRWSR_NOWPLAYING: 
		{
		    switch(fnHelper_GetPlaybackContext(THIS_UI.curzone,ui))
		    {
			case LIBRARY_AUDIO:	send_command THIS_UI.device,'@PPN-BLink-ContextMenu-NowPlaying'
			case LIBRARY_VIDEO:	send_command THIS_UI.device,'@PPN-BLink-ContextMenu-NowPlaying'
			case LIBRARY_RADIO:	send_command THIS_UI.device,'@PPN-BLink-ContextMenu-NowPlaying'
			default:		send_command THIS_UI.device,'@PPN-BLink-ContextMenu-NowPlaying'
		    }
		}
		case PAGE_NOWPLAYING_AUD: 	send_command THIS_UI.device,'@PPN-BLink-ContextMenu-NowPlaying'
		case PAGE_NOWPLAYING_VID: 	send_command THIS_UI.device,'@PPN-BLink-ContextMenu-NowPlaying'
		
		default: 			send_command THIS_UI.device,'@PPN-BLink-ContextMenu-NowPlaying'
	    }
	}
    }
}

Define_Function fnBrowser_LibraryHome(integer ui)
{
    CHECK_UI
    {
	char pagename[64];
	
	// Which library
	switch(THIS_UI.curLibrary)
	{
	    case LIBRARY_AUDIO: pagename = 'BLink-Browser-Music-Main';
	    case LIBRARY_VIDEO: pagename = 'BLink-Browser-Video-Main';
	    default:			pagename = 'BLink-Browser-Music-Main';
	}
	
	if(THIS_UI.isDMS)
	{
	    send_command THIS_UI.device,"'PAGE-',pagename";; 
	}
	else
	{
	    send_command THIS_UI.device,"'@PPN-',pagename";
	    send_command THIS_UI.device,'@PPN-BLink-ContextMenu-Library'
	}
    }
}

Define_Function fnBrowser_SetLibrary(integer ui, integer library)
{
    CHECK_UI
    {
	THIS_UI.curLibrary = library;
    }
}
//////////////////////////////////////////////////////////////////// Browser Pageing

/**
    Установка значений элементу списка
    на входе	:	ui		-
			br		-
			in_iItem	-
			in_lRow		-
			in_szText	-
			in_szId		-
			in_szQtext	-
			in_szCover_path	-
    на выходе	:	*
*/
Define_Function fnBrowser_DS_DeliverPageItem(integer ui, integer br, integer in_iItem, long in_lRow, char in_szText[], char in_szId[], char in_szQtext[], char in_szCover_path[])
{
    CHECK_UI	
    CHECK_BROWSER
    {
	// Check the pageitem value came out right
	if(in_iItem && in_iItem <= BRWSR_MAX_PAGESIZE)
	{	
	    // Save value to the dataset holding
	    THIS_BRWSR.ds_items[in_iItem].row		= in_lRow;
	    THIS_BRWSR.ds_items[in_iItem].text		= in_szText;
	    THIS_BRWSR.ds_items[in_iItem].qtext		= in_szQtext;
	    THIS_BRWSR.ds_items[in_iItem].id		= in_szId;
	    THIS_BRWSR.ds_items[in_iItem].cover_path	= in_szCover_path;
	    
	    // Update the UI
	    if(THIS_UI.curBrowser == br || br == BRWSR_CAT_SIMILAR)
		fnBrowserUIUpdate_DS_Pageitem(ui, br, in_iItem);
	}
	else fnSendDebugMsg("'fnBrowser_DeliverPageItem(): page item outside range. pageitem: ',itoa(in_iItem)");
    }
}
Define_Function fnBrowser_DS_SetItemCoverArtDynamicImage(integer ui, integer br, integer item, integer vtx, char resource[], char host[], char path[], char file[])
{
	CHECK_UI
	CHECK_BROWSER
	{
		CHECK_ITEM
		{
			char url[MAX_DS_GUID];
			
			url = "host,'/',path,'/',file";
			
			if(url != THIS_BRWSR.ds_covers_cache[item].url or THIS_UI.initialised == FALSE)
			{
				THIS_BRWSR.ds_covers_cache[item].url = url;
				//send_command THIS_UI.device,"'^RMF-',resource,',%P0%H',host,'%A',path,'%F',file"; // G4 only
				fnDeviceSendCmdQ_EnqueueCommand(sendcmd_queue,THIS_UI.device,"'^RMF-',resource,',%P0%H',host,'%A',path,'%F',file", resource); // G4 only
				THIS_BRWSR.ds_covers_cache[item].isDynamic = TRUE;
			}
			
			// Check for a resource change
			if(resource != THIS_BRWSR.ds_covers_cache[item].resource or THIS_UI.initialised == FALSE)
			{
				fnDeviceSendCmdQ_EnqueueCommand(sendcmd_queue,THIS_UI.device,"'^BBR-',itoa(vtx),',0,',resource",itoa(vtx));
				THIS_BRWSR.ds_covers_cache[item].resource = resource;
			}
		}
	}
}
Define_Function fnBrowser_DS_SetItemCoverArtImage(integer ui, integer br, integer item, integer vtx, char resource[])
{
	CHECK_UI
	CHECK_BROWSER
	{
		CHECK_ITEM
		{
			// Check for a resource change
			if(resource != THIS_BRWSR.ds_covers_cache[item].resource or THIS_UI.initialised == FALSE)
			{
				fnDeviceSendCmdQ_EnqueueCommand(sendcmd_queue,THIS_UI.device,"'^BBR-',itoa(vtx),',0,',resource",itoa(vtx));
				THIS_BRWSR.ds_covers_cache[item].resource = resource;
				THIS_BRWSR.ds_covers_cache[item].isDynamic = FALSE;
			}
		}
	}
}
Define_Function fnBrowser_DS_ClearItemCoverArtImage(integer ui, integer br, integer item, integer vtx)
{
	CHECK_UI
	CHECK_BROWSER
	{
		CHECK_ITEM
		{
			// Clear everything
			if(THIS_BRWSR.ds_covers_cache[item].resource != "" or THIS_UI.initialised == FALSE)
			{
				fnDeviceSendCmdQ_EnqueueCommand(sendcmd_queue,THIS_UI.device,"'^BBR-',itoa(vtx),',0,'",itoa(vtx));
				THIS_BRWSR.ds_covers_cache[item].url = "";
				THIS_BRWSR.ds_covers_cache[item].resource = "";
				THIS_BRWSR.ds_covers_cache[item].isDynamic = FALSE;
			}
		}
	}
}
Define_Function fnBrowserUIUpdate_DS_PageItem(integer ui, integer br, integer item)
{
    CHECK_UI
    {
	CHECK_BROWSER
	CHECK_ITEM
	{
	    integer vtx_it, vtx_qt, vtx_itcv, vw;
	    char itemtext[MAX_ITEMNAME];
	    char qtext[MAX_ITEMNAME];
	    char G4CoverResourceName[MAX_ITEMNAME];
	    
	    if(br == BRWSR_CAT_SIMILAR)
	    {
		vtx_it = vtx_BrwsList_SimilarMedia[item];
		vtx_itcv = vtx_BrwsList_SimilarMedia[item];
		vtx_qt = vtx_BrwsList_QTextFields[item];
		G4CoverResourceName = BRWSR_G4DYNIMG_SIMCOVERRESOURCE;
	    }
	    else
	    {
		vtx_it = vtx_BrwsList_Fields[item];
		vtx_itcv = vtx_BrwsList_CoverFields[item];
		vtx_qt = vtx_BrwsList_QTextFields[item];
		G4CoverResourceName = BRWSR_G4DYNIMG_COVERRESOURCE;
	    }
	    
	    itemtext = THIS_BRWSR.ds_items[item].text;                 
	    qtext   = fnHelper_DS_PipeDelimitToCommaSep(THIS_BRWSR.ds_items[item].qtext);
	    
	    // Send the item text
	    //send_command THIS_UI.device,"'!T',vtx_it,itemtext";
	    send_command THIS_UI.device,"'^UNI-',itoa(vtx_it),',0,',CP1251ToUNI(itemtext)";
	    
	    // Send the qualifiying text
	    if(qtext == "" and itemtext != "")
	    {
		    //send_command THIS_UI.device,"'!T',vtx_qt,' - - '";
	    }
	    else
	    {
		    //send_command THIS_UI.device,"'!T',vtx_qt,qtext";
	    }
	    
	    //// Check for none G3 panel
	    if(!fnIsAxlinkDev(THIS_UI.device))
	    {
		if(br == BRWSR_CAT_ALBUMCOVERS || br == BRWSR_CAT_MOVIECOVERS || br == BRWSR_CAT_SIMILAR)
		{
		    if(THIS_BRWSR.ds_items[item].row)
		    {
			_COVERART_URL urlstruct;
			
			//fnSendDebugMsg("'BROWSER-COVER-ID : ',THIS_BRWSR.ds_items[item].id");
			fnSendDebugMsg("'BROWSER-COVER-URL: ',THIS_BRWSR.ds_items[item].cover_path");
			
			
			fnHelper_CoverURIToHostPathFile(THIS_BRWSR.ds_items[item].cover_path, urlstruct);
			// Set the Dynamic image resource URL for the image location
			//send_command THIS_UI.device,"'^RMF-',G4CoverResourceName,itoa(item),',%P0%H',BLink.comms.url,':',itoa(BLink.about.coverart_port),'%A',cover_path,'%Ffolder.jpg'"; // G4 only
			//Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_itcv),',1&2,',G4CoverResourceName,itoa(item)"; // G4 Only
			fnBrowser_DS_SetItemCoverArtDynamicImage(ui,br,item,vtx_itcv,"G4CoverResourceName,itoa(item)",urlstruct.host,urlstruct.path,urlstruct.file);
		    }
		    else
		    {
			fnBrowser_DS_ClearItemCoverArtImage(ui,br,item,vtx_itcv);
		    }
		}
		else // Non Cover art browser
		{
		}
	    }
	    
	    if(item == THIS_BRWSR.selected)
	    {
		//fnBrowserUIUpdate_SelectedItem(ui,br,0);
	    }
	}
    }
}
Define_Function fnBrowserUIUpdate_ClearItem(integer ui, integer br, integer item)
{
    CHECK_UI
    {
	CHECK_BROWSER
	CHECK_ITEM
	{
	    integer vtx_it, vtx_qt, vtx_itcv, vw;
	    
	    if(br == BRWSR_CAT_SIMILAR)
	    {
		vtx_it = vtx_BrwsList_SimilarMedia[item];
		vtx_itcv = vtx_BrwsList_SimilarMedia[item];
		vtx_qt = vtx_BrwsList_QTextFields[item];
	    }
	    else
	    {
		vtx_it = vtx_BrwsList_Fields[item];
		vtx_itcv = vtx_BrwsList_CoverFields[item];
		vtx_qt = vtx_BrwsList_QTextFields[item];
	    }
	    
	    // Send the item text
	    send_command THIS_UI.device,"'!T',vtx_it";
	    //send_command THIS_UI.device,"'!T',vtx_qt";
	    
	    //// Check for none G3 panel
	    if(!fnIsAxlinkDev(THIS_UI.device))
	    {
		if(br == BRWSR_CAT_ALBUMCOVERS or br == BRWSR_CAT_MOVIECOVERS or br == BRWSR_CAT_SIMILAR)
		{
		    fnBrowser_DS_ClearItemCoverArtImage(ui,br,item,vtx_itcv);
		    
		    //Send_Command THIS_UI.device,"'^BMP-',itoa(vtx_itcv),',0,dummy.jpg'"; // G4 Querk - jpg indicates normal image type not dynamic
		}
		else // Non Cover art browser
		{
		}
	    }
	}
    }
}
Define_Function fnBrowserUIUpdate_Page(integer ui, integer br)
{
    CHECK_UI
    {
	CHECK_BROWSER
	{
	    integer item;
	    
	    for(item=1; item <= THIS_BRWSR.dataset.pagesize; item++)
	    {
		fnBrowserUIUpdate_DS_Pageitem(ui,br,item);
	    }
	}
	else
	{
	    fnBrowserUIUpdate_ClearPage(ui,BRWSR_CAT_ALBUMCOVERS);
	    fnBrowserUIUpdate_ClearPage(ui,BRWSR_CAT_SIMILAR);
	}
    }
}
Define_Function fnBrowserUIUpdate_ClearPage(integer ui,integer br)
{
    CHECK_UI
    {
	integer item;
	
	CHECK_BROWSER
	{
	    // Clear the item fields
	    for(item=1; item <= THIS_BRWSR.dataset.pagesize; item++)
	    {
		fnBrowserUIUpdate_ClearItem(ui,br,item);
	    }
	    
	    // Clear the selected item
	    THIS_BRWSR.selected = 0;
	    fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	}
    }
}

/**
    Получение страницы
    
*/
Define_Function fnBrowser_DS_FetchPage(integer ui, integer br, integer targetpageno)
{    
    CHECK_UI
    CHECK_BROWSER
    {
	integer unit;
	integer seed_br;		
	//char grouptype[MAX_DS_QUERYSTRING];
	char querytype[MAX_DS_QUERYSTRING];
	char queryseed[MAX_DS_QUERYSTRING];
	char queryseed_type[MAX_DS_QUERYSTRING];
	char queryfilter[MAX_DS_QUERYSTRING];
	long start, end, cursor;
	integer item, items, pageno, pages, rowcount;
	char org_data[32];
	
	unit = fnHelper_UItoUnit(ui);
	
	// Check for search/filter mode
	org_data = "fnInt8ToHex(ORIGDAT_BRW_CONTENTQUERY)";
	
	pageno = targetpageno;
	
	//// Existing live queries
	if(pageno && THIS_DATASET.rowcount)
	{
	    pages = fnHelper_DS_CalculatePageCount(THIS_DATASET.rowcount,THIS_DATASET.pagesize);
	    if(pageno > pages)
		pageno = pages; // End stop so something is returned
	    
	    ////// Calculate the page start & end
	    if(!start) start = fnHelper_Paging_CalculatePageTop(pageno, THIS_DATASET.rowcount, THIS_DATASET.pagesize) + THIS_DATASET.offset;
	    end = start + THIS_DATASET.offset + (THIS_DATASET.pagesize -1);
	    
	    ////// Fetch the details for each item
	    for(cursor = start; cursor <= end; cursor++)
	    {
		item++;
		// Count valid items
		if(cursor <= (THIS_DATASET.rowcount + THIS_DATASET.offset))
		    items++;
		
		// Blank the rest of the page if partial page fill
		else fnBrowser_DS_DeliverPageItem(ui, br, item, 0, "", "", "", "");
	    }	
	}
	//// New query
	else
	{
	    // Default to request a whole page. Row cound will come with replys.
	    start 	= 1;
	    items 	= THIS_DATASET.pagesize;
	    pageno 	= 1;
	}
	
	
	// Save the page thus far
	THIS_DATASET.pagetop 	= start;
	THIS_DATASET.pagenum 	= pageno;
	THIS_DATASET.linecount 	= items;
	
	// Watch for the current select item being off the end of the list
	//if(THIS_BRWSR.selected > items) fnBrowser_SetSelectItem(ui,br,Type_Cast(items));
	
	///// Get the refering browser used for some seeded queries
	seed_br = THIS_DATASET.seed_br;
	
	/////////// Query spec can be seeded or flat list of the browsers assigned category
	if(THIS_DATASET.isSeeded)
	{
	    queryseed_type 	= THIS_DATASET.queryseed_type;
	    queryseed 		= THIS_DATASET.queryseed;
	}
	
	querytype 	= THIS_DATASET.querytype;
	//grouptype 	= THIS_DATASET.querytype;
	
	// Setup the queryfilter
	queryfilter = THIS_DATASET.queryfilter;
	
	
	/// Debug
	fnSendDebugMsg('FETCH-PAGE: -----------------------------');
	if(THIS_DATASET.isSeeded)
	{
	    fnSendDebugMsg("'FETCH-PAGE: ',fnHelper_BrowserCatTOString(seed_br,0),' --> ',fnHelper_BrowserCatTOString(br,0)");
	    fnSendDebugMsg("'FETCH-PAGE: QueryType: ',querytype,'[',queryfilter,'] of subquery: ',queryseed_type,'[',queryseed,']'");
	}
	else 
	{
	    fnSendDebugMsg("'FETCH-PAGE: ',fnHelper_BrowserCatTOString(br,0)");
	    fnSendDebugMsg("'FETCH-PAGE: QueryType: ',querytype,'[',queryfilter,']'");
	}
	
	fnSendDebugMsg('FETCH-PAGE: -----------------------------');
	
	///// Send the request based on browser cat
	switch(br)
	{
	    // fnBLINKTX_API_**FindAudio**(integer when,integer org_grp, integer org_type, integer org_id, char org_data[],
	    // char srchCategory[], char srchValue[], char filtCategory[], char filtValue[], char srchType[],
	    // long startfrom, long itemcount, integer IdAsHTTP, integer ArtworkAsURL)
	    
	    // fnBLINKTX_API_**FindTracks**(integer when,integer org_grp, integer org_type, integer org_id, char org_data[],
	    // char filt1Category[], char filt1Value[], char filt2Category[], char filt2Value[], char srchString, char srchType[],
	    // long startfrom, long itemcount, integer IdAsHTTP, integer ArtworkAsURL)
	    
	    ////////////////////////////////// Audio Browsers
	    case BRWSR_CAT_TRACKS:
	    case BRWSR_CAT_ALLTRACKS:
	    {
		    
		    switch (seed_br) {
			case BRWSR_CAT_RADIOGENRES:
			    fnBLINKTX_API_FindAudio(SEND_NOW,unit,ORIGGRP_BR,Type_Cast(br),ui,"org_data",
				'Title',"",queryseed_type,queryseed,fnHelper_DS_SearchModeToString(THIS_DATASET.searchmode),start-1,items,0,1);
			default:
				fnBLINKTX_API_FindTracks(SEND_NOW,unit,ORIGGRP_BR,Type_Cast(br),ui,"org_data",
				"","",queryseed_type,queryseed,queryfilter,fnHelper_DS_SearchModeToString(THIS_DATASET.searchmode),start-1,items,0,1);
				// Start is -1 due to zero based BLink lists
		    }
		    
		    
		    
	    }
	    case BRWSR_CAT_ALBUMS:
	    case BRWSR_CAT_ALBUMCOVERS:
	    case BRWSR_CAT_ARTISTS:
	    case BRWSR_CAT_GENRES:
	    case BRWSR_CAT_PLAYLISTS:
	    case BRWSR_CAT_STATIONS:
	    case BRWSR_CAT_RADIOGENRES:
	    {
		fnBLINKTX_API_FindAudio(SEND_NOW,unit,ORIGGRP_BR,Type_Cast(br),ui,"org_data",
		    querytype,queryfilter,queryseed_type,queryseed,fnHelper_DS_SearchModeToString(THIS_DATASET.searchmode),start-1,items,0,1);
		// Start is -1 due to zero based BLink lists
	    }
	    case BRWSR_CAT_SIMILAR:
	    {				
		if(fnHelper_GetLibraryType(seed_br) ==  LIBRARY_AUDIO)
		{
		    fnBLINKTX_API_FindAudio(SEND_NOW,unit,ORIGGRP_BR,Type_Cast(br),ui,"org_data",
			    querytype,queryfilter,queryseed_type,queryseed,fnHelper_DS_SearchModeToString(THIS_DATASET.searchmode),start-1,items,0,1);
					    
		    // Start is -1 due to zero based BLink lists
		} else  // LIBRARY_VIDEO
		{
		    switch(seed_br)
		    {
			case BRWSR_CAT_MOVIES:
			case BRWSR_CAT_MOVIECOVERS:
			{
			//	fnBLINKTX_API_RequestRelatedMovies(SEND_NOW,ORIGGRP_BR,Type_Cast(br),ui,"org_data",
			//		querytype,queryfilter,queryseed_type,queryseed,fnHelper_DS_SearchModeToString(THIS_DATASET.searchmode),'DVD',7,start-1,items);
		
				//fnBLINKTX_SendServerPacket(SEND_NOW,ORIGGRP_BR,Type_Cast(br),ui,"org_data",MSG_RequestRelatedMovies,
			//		"'[All;;',queryseed,';;;;]','[',itoa(start-1),']','[',itoa(items),']','[]'", "");
			//      Start is -1 due to zero based BLink lists
			}
			default:
			{
			    //fnBLINKTX_API_FindMovies(SEND_NOW,ORIGGRP_BR,Type_Cast(br),ui,"org_data",
			    //	querytype,queryfilter,queryseed_type,queryseed,fnHelper_DS_SearchModeToString(THIS_DATASET.searchmode),'',7,start-1,items);
			    fnBLINKTX_API_FindMovies(SEND_NOW,ORIGGRP_BR,Type_Cast(br),ui,"org_data",
				queryseed_type,queryseed,fnHelper_DS_SearchModeToString(THIS_DATASET.searchmode),'',7,start-1,items);
			    //fnBLINKTX_API_FindMovieGroups(SEND_NOW,ORIGGRP_BR,Type_Cast(br),ui,"org_data",
				//    querytype,queryfilter,queryseed_type,queryseed,fnHelper_DS_SearchModeToString(THIS_DATASET.searchmode),'',7,start-1,items);
			}
		    }
		}
	    }
	    
	    /////////////////////////////////// DVD Browsers
	    case BRWSR_CAT_MOVIES:
	    {
		fnBLINKTX_API_FindMovies(SEND_NOW,ORIGGRP_BR,Type_Cast(br),ui,"org_data",
		    /*querytype,queryfilter,*/queryseed_type,queryseed,fnHelper_DS_SearchModeToString(THIS_DATASET.searchmode),'',7,start-1,items);
	    }
	    case BRWSR_CAT_MOVIECOVERS:
	    case BRWSR_CAT_ACTORS:
	    case BRWSR_CAT_DIRECTORS:
	    case BRWSR_CAT_MOVIEGENRES: 
	    {
		fnBLINKTX_API_FindMovieGroups(SEND_NOW,ORIGGRP_BR,Type_Cast(br),ui,"org_data",
		    querytype, queryfilter, queryseed_type, queryseed, fnHelper_DS_SearchModeToString(THIS_DATASET.searchmode), '', 7, start-1, items);
	    }
	    /////////////////////////////////// Play Q
	    case BRWSR_CAT_PLAYQ:
	    {
		integer zone;				
		zone = THIS_UI.curZone;
		
		fnBLINKTX_API_RequestAudioQueue(SEND_NOW,ORIGGRP_BR,Type_Cast(br),ui,"org_data",zone,start-1,items);	
	    }
	    default:
	    {
		// Check for an actual count of items to save sending bad queries
		if(items)
		{
		    // Watch for the current select item being off the end of the list
		    if(THIS_BRWSR.selected > items) fnBrowser_SetSelectItem(ui,br,Type_Cast(items));
		}
	    }			
	}
    }
}



Define_Function fnBrowser_PageUP(integer ui,br)
{
    CHECK_UI
    {
	CHECK_BROWSER
	{
	    integer pagecount;
	    integer new_pageno;
	    
	    pagecount	= THIS_DATASET.pagecount;
	    new_pageno 	= THIS_DATASET.pagenum - 1;
	    
	    /// Wrap if on the first page
	    if(new_pageno == 0) new_pageno = pagecount; 
	    
	    fnBrowser_DS_FetchPage(ui,br,new_pageno);
	    fnBrowserUIUpdate_SelectedItem(ui,br,1);
	}
    }
}

Define_Function fnBrowser_PageDW(integer ui,br)
{
    CHECK_UI
    {
	CHECK_BROWSER
	{
	    integer pagecount;
	    integer new_pageno;
	    
	    pagecount	= THIS_DATASET.pagecount;
	    new_pageno 	= THIS_DATASET.pagenum + 1;
	    
	    if(new_pageno > pagecount)
		new_pageno = 1;
	    
	    fnBrowser_DS_FetchPage(ui,br,new_pageno);
	    fnBrowserUIUpdate_SelectedItem(ui,br,1);
	}
    }
}

Define_Function fnBrowser_Search_SetMode(ui,integer mode)
{
	CHECK_UI
	{
		integer br;
		br = THIS_UI.curbrowser;
		
		CHECK_BROWSER
		{
			if(mode)
			{
				THIS_DATASET.searchmode = mode;
				THIS_DATASET.user_searchmode = mode; // Save this for later.
			}
			else
			{
				THIS_DATASET.searchmode = DS_SRCHMODE_NONE;
			}
		}
		
		fnBrowserUIUpdate_SearchMode(ui);
		fnBrowser_Search_SearchNow(ui);
	}
}

Define_Function fnBrowser_Search_CharEntry(integer ui, char character)
{
	CHECK_UI
	{
		if(character)
		{
			integer br;
			char charupper, charlower;
			integer searchnow;
			integer querylen;
			
			br = THIS_UI.curbrowser;
			querylen = Length_String(THIS_DATASET.queryfilter);
			
			charupper = Get_Buffer_Char(Upper_String("character"));
			charlower = Get_Buffer_Char(Lower_String("character"));
			
			switch(character)
			{
				case '<': // Deal with the backspace
				{
					if(querylen) THIS_DATASET.queryfilter = Left_String(THIS_DATASET.queryfilter,querylen-1);
				}
				default: // Otherwise just append the character
				{
					integer capitalize;
					
					// Pretty up the start of words
					if(querylen)
					{
						if(THIS_DATASET.queryfilter[querylen] == ' ')
							capitalize++;
					}
					else
						capitalize++;
						
					// Concatonate with upper or lower as appropriate
					if(capitalize) 	THIS_DATASET.queryfilter = "THIS_DATASET.queryfilter,charupper"
					else			THIS_DATASET.queryfilter = "THIS_DATASET.queryfilter,charlower"
				}
			}
			
			// Set the search type default or previously used mode
			if(THIS_DATASET.searchmode == DS_SRCHMODE_NONE)
			{
				if(THIS_DATASET.user_searchmode != DS_SRCHMODE_NONE) 
					fnBrowser_Search_SetMode(ui,THIS_DATASET.user_searchmode);
				else
					fnBrowser_Search_SetMode(ui,DS_SRCHMODE_CONTAINS); // Set a mode if none previously used
			}
			
			fnBrowserUIUpdate_SearchText(ui);
			fnBrowser_Search_SearchNow(ui);
		}
	}
}
Define_Function fnBrowser_Search_ClearSearch(ui)
{
	CHECK_UI
	{
		integer br;
		br = THIS_UI.curbrowser;
		
		CHECK_BROWSER
		{
			THIS_DATASET.queryfilter = "";
			THIS_DATASET.isSearch = FALSE;
			fnBrowserUIUpdate_SearchText(ui);
			
			fnBrowser_DS_CreateContentQuery(ui,br,FALSE);
			fnBrowserUIUpdate_BrowserIcons(ui);
		}
	}
}

Define_Function fnBrowser_Search_SearchNow(integer ui)
{
	CHECK_UI
	{
		integer br;
		br = THIS_UI.curbrowser;
		
		CHECK_BROWSER
		{
			local_var integer old_searchmode[MAX_USERINTERFACES];
			integer searchmode;
			
			searchmode = THIS_DATASET.searchmode;
			THIS_DATASET.isSearch = (THIS_DATASET.queryfilter != "");
			
			/////// Check for actual valid search mode
			if(THIS_DATASET.isSearch)
			{
				// Re-create the dataset with new params only changed and it is the jump mode
				if(searchmode == DS_SRCHMODE_JUMP)
				{
					if(old_searchmode[ui] != DS_SRCHMODE_JUMP) fnBrowser_DS_CreateContentQuery(ui,br,FALSE);
					
					// Get the page that starts with the search text
					fnBrowser_DS_CreateContentQuery(ui,br,FALSE);
				}
				else
					fnBrowser_DS_CreateContentQuery(ui,br,FALSE);
			}
			/////// Not a search so just get the normal page worth - takes care of when backspace used to clear the text
			else
				fnBrowser_DS_CreateContentQuery(ui,br,FALSE);
			
			// Update the icons
			fnBrowserUIUpdate_BrowserIcons(ui);
			old_searchmode[ui] = searchmode;
		}
	}
}

Define_Function fnBrowserUIUpdate_SearchText(ui)
{
	CHECK_UI
	{
		integer br;
		br = THIS_UI.curbrowser;
		
		CHECK_BROWSER
		{
			if(THIS_DATASET.queryfilter != "")
			{
				char sVerbose[32];
				
				switch(THIS_DATASET.searchmode)
				{
					case DS_SRCHMODE_BEGINS: sVerbose = "'Items Begining'";
					case DS_SRCHMODE_CONTAINS: sVerbose = "'Items Containing'";
					default: sVerbose = "'Search for'";
				}
				
				send_command THIS_UI.device,"'^UNI-',itoa(vtx_BrwsSearch_Text),',0,',CP1251ToUNI(THIS_DATASET.queryfilter)";
				send_command THIS_UI.device,"'^UNI-',itoa(vtx_BrwsSearch_TextVerbose),',0,', CP1251ToUNI(sVerbose),' "', CP1251ToUNI(THIS_DATASET.queryfilter),'"'";
			}
			else								
			{
				send_command THIS_UI.device,"'!T',vtx_BrwsSearch_Text,'Enter Search Text...'";
				send_command THIS_UI.device,"'!T',vtx_BrwsSearch_TextVerbose,'Enter Search Text...'";
			}
		}
	}
}

Define_Function fnBrowserUIUpdate_SearchMode(ui)
{
	CHECK_UI
	{
		integer br;
		br = THIS_UI.curbrowser;
		
		CHECK_BROWSER
		{
			integer m, modes;
			modes = Length_Array(btn_BrwsSearch_Modes);
			
			// Enable Search buttons as appropriate
			switch(br)
			{
			    case BRWSR_CAT_RADIOGENRES:
			    case BRWSR_CAT_PLAYLISTS:
			    {
				    fnTPAPI_Btn_SetVisible(THIS_UI.device,vtx_BrwsSearch_Enabled,FALSE);
				    fnTPAPI_Btn_SetVisible(THIS_UI.device,vtx_BrwsSearch_TextVerbose,FALSE);
			    }
			    default:
			    {
				    fnTPAPI_Btn_SetVisible(THIS_UI.device,vtx_BrwsSearch_Enabled,TRUE);
				    fnTPAPI_Btn_SetVisible(THIS_UI.device,vtx_BrwsSearch_TextVerbose,TRUE);
			    }
			}
			
			for(m=1; m <= modes; m++)
			{
				[THIS_UI.device, btn_BrwsSearch_Modes[m]] = m == THIS_DATASET.searchmode;
			}
		}
	}
}

Define_Function fnBrowserUIUpdate_PageNumber(integer ui, integer br)
{
	CHECK_UI
	CHECK_BROWSER
	{
		long pages, page, rowcount, absrow;
		integer vtx, lvl;
		pages 	 = THIS_DATASET.pagecount;
		page	 = THIS_DATASET.pagenum;
		rowcount = THIS_DATASET.rowcount;
		absrow	 = THIS_DATASET.pagetop;
		
		// Now display the page info on the panel.
		if(br == BRWSR_CAT_SIMILAR)
		{
			vtx = vtx_Brws_SimilarPageInfo;
			lvl = 0;
		}
		else
		{
			vtx = vtx_Brws_PageInfo;
			lvl = lvl_Brws_PageInfo;
		}
		
		if(pages and page)
		{
			if(THIS_UI.isDMS)
			{
				if(THIS_DATASET.isSearch)	send_command THIS_UI.device,"'!T',vtx,itoa(page),' of ',itoa(pages),' [Filtered]'";
				else						send_command THIS_UI.device,"'!T',vtx,itoa(page),' of ',itoa(pages)";
			}
			else
			{
				send_command THIS_UI.device,"'!T',vtx,itoa(page),' of ',itoa(pages)";
			}
			
			//// G3 Feedback
			if(fnIsAxlinkDev(THIS_UI.device))
			{
				integer eightbitlvl;
				
				if(absrow)
				{
					eightbitlvl = Type_Cast((absrow*255)/rowcount);
					send_level	THIS_UI.device,lvl,eightbitlvl;
				}
			}
			//// G4 Feedback
			else
			{	
				send_command THIS_UI.device,"'^BMF-',itoa(vtx),',1&2,%GL1%GH',itoa(rowcount)";
				send_level	THIS_UI.device,lvl,absrow;
			}
		}
		else
		{
			send_command THIS_UI.device,"'!T',vtx,'Empty'";
			send_level	THIS_UI.device,lvl,0;
		}
		
		/// Page number text now reset
		THIS_UI.resetpageinfo = 0;
	}
	else
	{
		send_command THIS_UI.device,"'!T',vtx_Brws_PageInfo,'Empty'";
		send_command THIS_UI.device,"'!T',vtx_Brws_SimilarPageInfo,'Empty'";
		send_level	THIS_UI.device,lvl_Brws_PageInfo,0;
	}
}
/////////////////////////////////////////////////////////////////////////////// Play Queue Operations
Define_Function fnBrowserUIUpdate_ItemAddedToQueue(integer ui)
{
	CHECK_UI
	{
		integer br, vtx;
		
		br = THIS_UI.curBrowser;
		
		CHECK_BROWSER
		{
			vtx = vtx_Brws_PageInfo;
			
			send_command THIS_UI.device,"'!T',vtx,'Selection Queued.'";
			
			// Flag that the Page number text was changed, so it can be resent when appropriate.
			THIS_UI.resetpageinfo = 1;
		}
	}
}
Define_Function fnBrowserUIUpdate_ItemRemovedFromQueue(integer ui)
{
	CHECK_UI
	{
		integer br, vtx;
		
		br = THIS_UI.curBrowser;
		
		CHECK_BROWSER
		{
			vtx = vtx_Brws_PageInfo;
			
			send_command THIS_UI.device,"'!T',vtx,'Removed Selected.'";
			
			// Flag that the Page number text was changed, so it can be resent when appropriate.
			THIS_UI.resetpageinfo = 1;
		}
	}
}

Define_Function fnBrowser_PlayQueueAddSelected(integer ui, integer br)
{
    CHECK_UI
    CHECK_BROWSER
    {
	integer z, zone, selitem, tbr;
	char grouptype[MAX_DS_GUID];
	
	tbr	= THIS_DATASET.seed_br;
	selitem = THIS_BRWSR.selected;
	zone 	= THIS_UI.curzone;
	z 	= zone; // Just a copy for the macros
	
	if(selitem)
	{
	    grouptype = fnHelper_BrowserCatToBLinkGroupType(br);
	    
	    // fnBLINKTX_API_AudioQueueAdd(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone,
	    //							char rootCategory[], char subCategory[], char filtCategory[], char filtValue[],
	    //							sinteger trackindex, integer playindex ,integer insertmode)
	    
	    // fnBLINKTX_API_AudioQueueAddIDs(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone,
	    //							char trackidlist[], integer playindex, integer insertmode)
	    
	    switch(br)
	    {
		case BRWSR_CAT_ARTISTS: 	
		case BRWSR_CAT_ALBUMS: 		
		case BRWSR_CAT_ALBUMCOVERS: 
		case BRWSR_CAT_GENRES: 		
		case BRWSR_CAT_ERAS: 		
		case BRWSR_CAT_PLAYLISTS:	
		{
		    fnBLINKTX_API_AudioQueueAdd(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",zone,grouptype,THIS_BRWSR.ds_items[selitem].text,"","",QADD_TRACK_ALL,0,QADD_INSMODE_APPEND);					
		}
		case BRWSR_CAT_ALLTRACKS:
		{
		    fnBLINKTX_API_AudioQueueAddIDs(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",zone,THIS_BRWSR.ds_items[selitem].id,0,QADD_INSMODE_APPEND);					
		}
		case BRWSR_CAT_TRACKS: 		
		{	
		    integer tbr_selected;
		    grouptype = fnHelper_BrowserCatToBLinkGroupType(THIS_DATASET.seed_br);
		    tbr_selected = THAT_BRWSR.selected;
		    if(tbr_selected)
		    {
			fnBLINKTX_API_AudioQueueAdd(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",zone,grouptype,THAT_BRWSR.ds_items[tbr_selected].text,"","",QADD_TRACK_ALL,THIS_BRWSR.ds_items[selitem].row-1,QADD_INSMODE_APPEND);
		    }
		}
		case BRWSR_CAT_SIMILAR: 		
		{					
		    switch(THIS_DATASET.seed_br)
		    {
			case BRWSR_CAT_ARTISTS: 	
			case BRWSR_CAT_ALBUMS: 		
			case BRWSR_CAT_ALBUMCOVERS: 
			case BRWSR_CAT_GENRES: 		
			case BRWSR_CAT_ERAS: 		
			case BRWSR_CAT_PLAYLISTS:	
			case BRWSR_CAT_ALLTRACKS:
			{
			    fnBLINKTX_API_AudioQueueAdd(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",zone,grouptype,THIS_BRWSR.ds_items[selitem].text,"","",QADD_TRACK_ALL,0,QADD_INSMODE_APPEND);
			}
		    }
		}
	    }
	    
	    // Show a breif confirmation
	    fnBrowserUIUpdate_ItemAddedToQueue(ui)
	}
    }
}

Define_Function fnBrowser_PlayQueueRemoveSelected(integer ui)
{
    CHECK_UI
    {
	integer br;
	
	br = BRWSR_CAT_PLAYQ;
	CHECK_BROWSER
	{
	    if(THIS_BRWSR.selected)
	    {
		long item_idx;
		integer z;
		
		z = THIS_UI.curzone;
		
		CHECK_ZONE
		if(THIS_BRWSR.selected)
		{					
		    item_idx = THIS_BRWSR.ds_items[THIS_BRWSR.selected].row;
		    
		    // Play Queue remove item command here
		    fnBLINKTX_API_AudioQueueRemove(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",z, item_idx-1)
		    fnBrowserUIUpdate_ItemRemovedFromQueue(ui);
		}
	    }
	}
    }
}

/**
    Команда от браузера: очистить список воспроизведения
    на входе	:	ui	- идентифкатор
    на выходе	:	*
*/
Define_Function fnBrowser_PlayQueueClear(integer ui)
{
    CHECK_UI
    {
	integer br, z;
	
	br = BRWSR_CAT_PLAYQ;
	z  = THIS_UI.curzone;
	
	CHECK_BROWSER
	CHECK_ZONE
	{
	    fnBLINKTX_API_AudioQueueClear(SEND_NOW, ORIGGRP_BR, Type_Cast(br), 0, "", z)
	}
    }
}
Define_Function fnBrowser_PlaySelected(integer ui, integer br)
{	
    CHECK_UI
    CHECK_BROWSER
    {
	integer z, zone, selitem, tbr;
	char grouptype[MAX_DS_GUID];
	
	tbr		= THIS_DATASET.seed_br;
	selitem = THIS_BRWSR.selected;
	zone 	= THIS_UI.curzone;
	z 		= zone; // Just a copy for the macros
	
	if(selitem)
	{
	    grouptype = fnHelper_BrowserCatToBLinkGroupType(br);
	    
	    // fnBLINKTX_API_AudioQueueAdd(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone,
	    //							char rootCategory[], char subCategory[], char filtCategory[], char filtValue[],
	    //							sinteger trackindex, integer playindex ,integer insertmode)
	    
	    // fnBLINKTX_API_AudioQueueAddIDs(integer when,integer org_grp, integer org_type, integer org_id, char org_data[], integer zone,
	    //							char trackidlist[], integer playindex, integer insertmode)
	    
	    switch(br)
	    {
		case BRWSR_CAT_ARTISTS: 	
		case BRWSR_CAT_ALBUMS: 		
		case BRWSR_CAT_ALBUMCOVERS: 
		case BRWSR_CAT_GENRES: 		
		case BRWSR_CAT_ERAS: 		
		case BRWSR_CAT_PLAYLISTS:	
		{
		    fnBLINKTX_API_AudioQueueAdd(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",zone,grouptype,THIS_BRWSR.ds_items[selitem].text,"","",QADD_TRACK_ALL,0,QADD_INSMODE_REPLACEPLAY);
		    //fnBLINKTX_API_AudioQueuePlay(SEND_DEFERED,ORIGGRP_BR,Type_Cast(br),0,"",zone,0);
		    fnBrowser_RestoreBrowser(ui,BRWSR_NOWPLAYING);
		}
		case BRWSR_CAT_ALLTRACKS:
		{
		    fnBLINKTX_API_AudioQueueAddIDs(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",zone,THIS_BRWSR.ds_items[selitem].id,0,QADD_INSMODE_REPLACEPLAY);
		    //fnBLINKTX_API_AudioQueuePlay(SEND_DEFERED,ORIGGRP_BR,Type_Cast(br),0,"",zone,0);
		    fnBrowser_RestoreBrowser(ui,BRWSR_NOWPLAYING);
		}
		case BRWSR_CAT_TRACKS: 		
		{	
		    integer tbr_selected;
		    grouptype = fnHelper_BrowserCatToBLinkGroupType(THIS_DATASET.seed_br);
		    tbr_selected = THAT_BRWSR.selected;
		    if(tbr_selected)
		    {
			fnBLINKTX_API_AudioQueueAdd(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",zone,grouptype,THAT_BRWSR.ds_items[tbr_selected].text,"","",QADD_TRACK_ALL,THIS_BRWSR.ds_items[selitem].row-1,QADD_INSMODE_REPLACEPLAY);
			fnBrowser_RestoreBrowser(ui,BRWSR_NOWPLAYING);
		    }
		}
		case BRWSR_CAT_MOVIEYEARS:	
		case BRWSR_CAT_MOVIEGENRES:	
		case BRWSR_CAT_RATING:		
		case BRWSR_CAT_ACTORS: 		
		case BRWSR_CAT_DIRECTORS:	
		{
		    // TODO: Message - Please select a movie
		}
		case BRWSR_CAT_MOVIES: 		
		case BRWSR_CAT_MOVIECOVERS:	
		{
//					fnBLINKTX_SendZonePacket(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",zone,MSG_PlayVideo,"'[DVD]','[]','[',THIS_BRWSR.ds_items[selitem].id,']','[]'","");
		    fnBLINKTX_API_PlayMovie(SEND_NOW, ORIGGRP_BR, Type_Cast(br), 0, "", zone, THIS_BRWSR.ds_items[selitem].id);
		    fnBrowser_RestoreBrowser(ui,BRWSR_NOWPLAYING);
		}
		case BRWSR_CAT_SIMILAR: 		
		{					
		    switch(THIS_DATASET.seed_br)
		    {
			case BRWSR_CAT_MOVIES:
			case BRWSR_CAT_MOVIECOVERS: 		
			case BRWSR_CAT_ACTORS: 		
			case BRWSR_CAT_DIRECTORS:	
			case BRWSR_CAT_MOVIEGENRES:
			{
			    // Movie play code here
			    fnBrowser_RestoreBrowser(ui,BRWSR_NOWPLAYING);
			}
			case BRWSR_CAT_ARTISTS: 	
			case BRWSR_CAT_ALBUMS: 		
			case BRWSR_CAT_ALBUMCOVERS: 
			case BRWSR_CAT_GENRES: 		
			case BRWSR_CAT_ERAS: 		
			case BRWSR_CAT_PLAYLISTS:	
			case BRWSR_CAT_ALLTRACKS:
			{
			    fnBLINKTX_API_AudioQueueAdd(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",zone,grouptype,THIS_BRWSR.ds_items[selitem].text,"","",QADD_TRACK_ALL,0,QADD_INSMODE_REPLACEPLAY);
			    //fnBLINKTX_API_AudioQueuePlay(SEND_DEFERED,ORIGGRP_BR,Type_Cast(br),0,"",zone,0);
			    fnBrowser_RestoreBrowser(ui,BRWSR_NOWPLAYING);							
			}
		    }
		}
		case BRWSR_CAT_PLAYQ:
		{					
		    fnBLINKTX_API_AudioQueuePlay(SEND_NOW,ORIGGRP_BR,Type_Cast(br),0,"",zone,THIS_BRWSR.ds_items[selitem].row-1);
		}
	    }
	}
    }
}

Define_Function integer fnBrowser_DS_CheckOk(integer ui, integer br)
{
    CHECK_UI
    CHECK_BROWSER
    {
	if(THIS_BRWSR.dataset.status >= DS_STATE_READY)
	{
	    return 1;
	}
    }
    
    return 0;
}


Define_Function fnBrowser_DefineForwardPath(integer ui, integer br, integer fwp, integer destBrowser)
{
    CHECK_UI
    CHECK_BROWSER
    {
	CHECK_PATH
	{
	    THIS_PATH.browser = destBrowser;
	    THIS_PATH.enabled = TRUE;
	    Set_Length_Array(THIS_BRWSR.fwdPaths,fwp);
	}
    }
}

Define_Function fnBrowser_ClearForwardPaths(integer ui, integer br)
{
    CHECK_UI
    CHECK_BROWSER
    {
	integer fwp, paths;
	paths = Max_Length_Array(THIS_BRWSR.fwdPaths);
	
	for(fwp=1; fwp <= paths; fwp++)
	{
	    THIS_PATH.browser = 0;
	    THIS_PATH.enabled = FALSE;
	}
	
	Set_Length_Array(THIS_BRWSR.fwdPaths,0);
    }
}

Define_Function fnBrowserUIUpdate_ForwardPaths(integer ui, integer targetbr)
{
    CHECK_UI
    {
	integer br;
	
	// Which browser to use
	if(targetbr)
	    br = targetbr
	else
	    br = THIS_UI.curBrowser;
	
	CHECK_BROWSER
	{
	    integer paths, fwp;
	    
	    paths = Max_Length_Array(THIS_BRWSR.fwdpaths);
		    
	    for(fwp=1; fwp <= paths; fwp++)
	    {
		// Enabled paths
		if(THIS_PATH.enabled)
		{
		    integer br_path;
		    br_path = THIS_PATH.browser;
		    
		    // Show the buttons
		    fnTPAPI_Btn_SetVisible(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],TRUE);
		    fnTPAPI_Btn_SetVisible(THIS_UI.device,vtx_BrwsFwdPath_Names[fwp],TRUE);
		    
		    // Set the icons and text
		    //fnTPAPI_Text_SetSimple(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],fnHelper_BrowserCatTOFonySymbolChar(br_path));
		    fnTPAPI_Text_SetSimple(THIS_UI.device,vtx_BrwsFwdPath_Names[fwp],fnHelper_BrowserCatTOString(br_path,TRUE));
		    
		    // Cover art special condition
		    fnTPAPI_PageFlip_ClearAll(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp]);
		    switch(br_path)
		    {
			case BRWSR_CAT_ALBUMCOVERS:
			{
			    fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],'Show',  'BLink-ContextMenu-MusicLibrary');
			    fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],'Show',  'BLink-Browser-Music-Covers');
			}
			case BRWSR_CAT_MOVIECOVERS:
			{
			    fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],'Show',  'BLink-ContextMenu-DVDLibrary');
			    fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],'Show',  'BLink-Browser-Video-Covers');
			}
			case BRWSR_CAT_RADIOGENRES:
			case BRWSR_CAT_PLAYLISTS:
			{
			    fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],'Show', 'BLink-ContextMenu-MusicLibrary');
			    fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],'Show', 'BLink-Browser-Music-Playlists');
			}
			default:
			{
			    //fnTPAPI_PageFlip_ClearAll(THIS_UI.device,vtx_BrwsFwdPath_Names[fwp]);
			    switch(fnHelper_GetLibraryType(br_path))
			    {
				case LIBRARY_AUDIO:
				{
				    fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],'Show','BLink-Browser-Music-Main');
				    fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],'Show','BLink-ContextMenu-MusicLibrary');
				}
				case LIBRARY_VIDEO: 
				{
				    fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],'Show','BLink-Browser-Video-Main');
				    fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],'Show','BLink-ContextMenu-DVDLibrary');
				}
			    }
			}
		    }
		}
		// Disabled Paths
		else
		{
		    // Turn the buttons off
		    fnTPAPI_Btn_SetVisible(THIS_UI.device,vtx_BrwsFwdPath_Icons[fwp],FALSE);
		    fnTPAPI_Btn_SetVisible(THIS_UI.device,vtx_BrwsFwdPath_Names[fwp],FALSE);
		}
	    }
	    
	    
	    ////////////////////////// Back button 
	    // Clear all page flips
	    fnTPAPI_PageFlip_ClearAll(THIS_UI.device,vtx_BrwsBackup);
	    
	    /// Now add appropriate page flips to the button itself
	    if(THIS_DATASET.isSeeded)
	    {
		switch(THIS_BRWSR.refBrowser)
		{
		    case BRWSR_CAT_ALBUMCOVERS:
		    {
			fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsBackup,'Show',  'BLink-ContextMenu-MusicLibrary');
			fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsBackup,'Show',  'BLink-Browser-Music-Covers');
		    }
		    case BRWSR_CAT_MOVIECOVERS:
		    {
			fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsBackup,'Show',  'BLink-ContextMenu-DVDLibrary');
			fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsBackup,'Show',  'BLink-Browser-Video-Covers');
		    }
		    case BRWSR_CAT_RADIOGENRES:
		    case BRWSR_CAT_PLAYLISTS:
		    {
			fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsBackup,'Show', 'BLink-ContextMenu-MusicLibrary');
			fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsBackup,'Show', 'BLink-Browser-Music-Playlists');
		    }
		    case BRWSR_CAT_NULL:
		    {
			// Dont add any.
		    }
		    default:
		    {
			switch(fnHelper_GetLibraryType(THIS_BRWSR.refBrowser))
			{
			    case LIBRARY_AUDIO:
			    {
				fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsBackup,'Show','BLink-Browser-Music-Main');
				fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsBackup,'Show','BLink-ContextMenu-MusicLibrary');
			    }
			    case LIBRARY_VIDEO: 
			    {
				fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsBackup,'Show','BLink-Browser-Video-Main');
				fnTPAPI_PageFlip_AddFlip(THIS_UI.device,vtx_BrwsBackup,'Show','BLink-ContextMenu-DVDLibrary');
			    }
			}
		    }
		}
	    }
	}
    }
}
Define_Function fnBrowser_DS_InitContentQuery(integer ui, integer br)
{
    CHECK_UI
    CHECK_BROWSER
    {
	switch(br)
	{
	    case BRWSR_CAT_ARTISTS:
	    {
		THIS_DATASET.querytype 		= 'Artist';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		//fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_ALBUMCOVERS);
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_ALBUMS);
		fnBrowser_DefineForwardPath(ui,br, 2, BRWSR_CAT_TRACKS);
		//fnBrowser_DefineForwardPath(ui,br, 3, BRWSR_CAT_MOVIES);
	    }
	    case BRWSR_CAT_ALBUMS:
	    {
		THIS_DATASET.querytype 		= 'Album';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_TRACKS);
	    }
	    case BRWSR_CAT_TRACKS:
	    {
		THIS_DATASET.querytype 		= 'Track';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
	    }
	    case BRWSR_CAT_ALLTRACKS:
	    {
		THIS_DATASET.querytype 		= 'Track';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
	    }
	    case BRWSR_CAT_ALBUMCOVERS:
	    {
		THIS_DATASET.querytype 		= 'Album';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_TRACKS);
	    }
	    case BRWSR_CAT_GENRES:
	    {
		THIS_DATASET.querytype 		= 'Genre';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_ALBUMS);
		fnBrowser_DefineForwardPath(ui,br, 2, BRWSR_CAT_TRACKS);
	    }
	    
	    case BRWSR_CAT_PLAYLISTS:
	    {
		THIS_DATASET.querytype 		= 'Playlist';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_TRACKS);
	    }
	    
	    /////////////////////////// Net Radio
	    case BRWSR_CAT_RADIOGENRES:
	    {
		THIS_DATASET.querytype 		= 'NetRadio';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_TRACKS);
	    }
	    case BRWSR_CAT_STATIONS:
	    {
		THIS_DATASET.querytype 		= 'NetRadio';  // <--- Yeah I know it should be NetRadioGenre
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_ALBUMS);
		fnBrowser_DefineForwardPath(ui,br, 2, BRWSR_CAT_TRACKS);
	    }
	    
	    case BRWSR_CAT_PLAYQ:
	    {
		THIS_DATASET.querytype 		= 'PlayQueue';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		// - There are none for the Play Queue
	    }
	    case BRWSR_CAT_MOVIES: {}
	    {
		THIS_DATASET.querytype 		= 'Title';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
	    }
	    case BRWSR_CAT_MOVIECOVERS:
	    {
		THIS_DATASET.querytype 		= 'Title';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
	    }			
	    case BRWSR_CAT_ACTORS:
	    {
		THIS_DATASET.querytype 		= 'Actor';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_MOVIES);
		fnBrowser_DefineForwardPath(ui,br, 2, BRWSR_CAT_MOVIECOVERS);
	    }
	    case BRWSR_CAT_DIRECTORS:
	    {
		THIS_DATASET.querytype 		= 'Director';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_MOVIES);
		fnBrowser_DefineForwardPath(ui,br, 2, BRWSR_CAT_MOVIECOVERS);
	    }
	    case BRWSR_CAT_MOVIEGENRES:
	    {
		THIS_DATASET.querytype 		= 'Genre';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_MOVIES);
		fnBrowser_DefineForwardPath(ui,br, 2, BRWSR_CAT_MOVIECOVERS);
	    }
	    case BRWSR_CAT_SIMILAR:
	    {
		THIS_DATASET.querytype 		= 'Album';
		THIS_DATASET.queryseed		= '';
		THIS_DATASET.queryfilter	= '';
		THIS_DATASET.pagesize		= BRWSR_MAX_PAGESIZE;
		THIS_DATASET.status			= DS_STATE_INITIALIZED;
		
		// Define forward paths
		fnBrowser_DefineForwardPath(ui,br, 1, BRWSR_CAT_TRACKS);
	    }
	}
    }
}

Define_Function fnBrowser_DS_CreateContentQuery(integer ui,integer br, integer disablewatch)
{
    CHECK_UI
    CHECK_BROWSER
    {
	THIS_DATASET.rowcount = 0;
	THIS_DATASET.pagenum = 0;
	fnBrowser_DS_FetchPage(ui,br,0);
    }
}

Define_Function fnBrowser_DS_InvalidateDatasets(uitarget)
{
    integer ui;
    
    if(uitarget)
	ui = uitarget
    else
	ui = Length_Array(dvPanels);
    
    while(ui)
    {
	integer br;
	
	for(br=1; br <= BRWSR_MAX_CATEGORIES; br++)
	{
		fnBrowser_DS_DestroyDataset(ui,br);
	}
	
	ui--;
	if(uitarget) break;
    }
}

Define_Function fnBrowser_DS_DestroyDataset(integer ui, integer br)
{
    CHECK_UI
    CHECK_BROWSER
    {
	THIS_DATASET.rowcount = 0;
	THIS_DATASET.status = DS_STATE_NULL;
	
	// Tell the server were done with the data if needed		
    }
}

/////////////////////////////////////////////////////////////////////////////// A-Z Track DB Browser Specials

Define_Function fnBrowser_DS_GetObjectCoverArtGuid(integer ui, integer br, char guid[])
{
    CHECK_UI
    CHECK_BROWSER
    {
	char org_data[32];
	
	// Check for search/filter mode
	org_data = "fnInt8ToHex(ORIGDAT_BRW_OBJECTCOVERART)";
    }
}


///////////////////////////////////////////////////////////////////// Play Queue handling
Define_Function fnBrowserNotifyChange_PlayQueue(integer z)
{
	// When the play Q Changes we only update the now playing selection track
	CHECK_ZONE
	{
		integer ui, uicount;
		uicount = Length_Array(uis);
		
		// Update the ui's attached to this zone
		for(ui=1; ui <= uicount; ui++)
		{
			// UI is looking at this zone?
			if(THIS_UI.curzone == z)
			{
				integer br;
				integer curitem_page;		
				br = BRWSR_CAT_PLAYQ;
				
				curitem_page = fnHelper_DS_CalculatePageNumber(THIS_ZONE.playqueue.position,THIS_DATASET.pagesize);
				
				// Check if the browser is looking at the correct page
				if(curitem_page == THIS_DATASET.pagenum)
				{
					long pagetop;
					integer	pageitem;
					pagetop = fnHelper_Paging_CalculatePageTop(curitem_page,THIS_ZONE.playqueue.length,THIS_DATASET.pagesize);
					pageitem = Type_Cast(THIS_ZONE.playqueue.position - pagetop)+1;
					fnBrowser_SetSelectItem(ui,br,pageitem);
					
				}
				// If not then move the browser to the correct page
				else
				{
					if(THIS_UI.curBrowser == BRWSR_CAT_PLAYQ)
						fnBrowser_DS_FetchPage(ui,br,curitem_page);
					// Highlighting the current item is taken care of when the page arrives.
				}
				
			}
		}
	}
}



///////////////////////////////////////////////////////////////////// Main Browser message routing function
Define_Function fnBrowserBLinkComm_ProcessReplys(_BLINK_PACKET ipktin)
{
    // Check this is actually a browser message
    if(ipktin.org_grp == ORIGGRP_BR)
    {
	/////////// Get the browser datatype so we can route specific messages correctly
	// Check first 8bit value encoded in the context origin data
	integer brdata_type;
	brdata_type = hextoi(mid_string(ipktin.org_data,1,2));
	
	
	/////////////////////////////////////////////////////////////// Check for very specific msgs
	if(brdata_type and (brdata_type != ORIGDAT_BRW_CONTENTQUERY))
	{
	    fnBrowserBLinkComm_ProcessSpecialReplys(ipktin);
	    return;
	}
	
	/////////////////////////////////////////////////////////////// Main Switch (param1)
	switch(ipktin.msgtype)
	{
	    /////////////////// Generic FindAudio message
	    case MSG_SendingFoundAudio: 		fnBrowserBLinkComm_HandleFoundAudioPage(ipktin);
	    
	    /////////////////// Generic FindTrack message
	    case MSG_SendingFoundTracks: 		fnBrowserBLinkComm_HandleFoundTracksPage(ipktin);
	    
	    /////////////////// Generic FindTrack message
	    case MSG_SendingAudioQueue: 		fnBrowserBLinkComm_HandleAudioQueuePage(ipktin);
	    
	    /////////////////// Generic FindMovies message
	    case MSG_SendingFoundMovies: 		fnBrowserBLinkComm_HandleFoundMoviesPage(ipktin);
	    
	    /////////////////// SubGroups message
	    case MSG_SendingSubGroups: 			fnBrowserBLinkComm_HandleSubGroupsPage(ipktin);
	    
	    /////////////////// SubGroups message
	    case MSG_SendingDistinctAlbums:		fnBrowserBLinkComm_HandleDistinctAlbumsPage(ipktin);
	    
	    /////////////////// SubGroups message
	    case MSG_SendingAlbumsOfSubGroup2:		fnBrowserBLinkComm_HandleAlbumsOfSubGroupPage(ipktin);
	    
	    /////////////////// GenreAlbums message
	    case MSG_SendingAlbumsOfGenre2:		fnBrowserBLinkComm_HandleAlbumsOfGenrePage(ipktin);
	    
	    /////////////////// TrackGroups message
	    case MSG_SendingTrackGrouping:		fnBrowserBLinkComm_HandleTrackGroupingPage(ipktin);
	    
	    /////////////////// DVD/Video Titles
	    case MSG_SendingMovies:			fnBrowserBLinkComm_HandleMoviesPage(ipktin);
	    
	    /////////////////// DVD/Video Groups
	    case MSG_SendingMovieGroups:		fnBrowserBLinkComm_HandleMovieGroupsPage(ipktin); 
	    
	    /////////////////// DVD/Video Similar Title
	    case MSG_SendingRelatedMovies:		fnBrowserBLinkComm_HandleRelatedMoviesPage(ipktin);
	}
    }
}
Define_Function fnBrowserBLinkComm_ProcessSpecialReplys(_BLINK_PACKET ipktin)
{
	integer brdata_type;
					
	// Check for info encoded in the context data
	brdata_type = hextoi(mid_string(ipktin.org_data,1,2));
	
	//switch(brdata_type)
//	{
//		case ORIGDAT_BRW_xxx:  	fnBrowserBLinkComm_Handle...
//		
//	}
	
}
Define_Function fnBrowserBLinkComm_ProcessMessages(_BLINK_PACKET ipktin)
{
	// Check this is actually a browser message
	if(ipktin.org_grp == ORIGGRP_BR)
	{
		
	}
}

Define_Function fnBrowserBLinkComm_HandleDataSetNotFound(_BLINK_PACKET ipktin)
{
	integer br, ui, ds;
	
	br = ipktin.org_type;
	ui = ipktin.org_id;
	
	// If we wound up here its because we tried to use a dataset ref and got
	//  told the server didnt know anything about it. Probably due to the
	//  connection being dropped. So we just recreate...
	
	CHECK_UI
	CHECK_BROWSER
	{
		// Recreate the dataset
		fnBrowser_DS_CreateContentQuery(ui,br,FALSE);
	}
}
Define_Function fnBrowserBLinkComm_HandleFoundAudioPage(_BLINK_PACKET ipktin)
{
	integer br, ui, ds;
	
	br = ipktin.org_type;
	ui = ipktin.org_id;
	
	CHECK_UI
	CHECK_BROWSER
	{
		// iDyl
		// [ItemCount;;TotalRows;;] ... [SendingAlbumsOfSubGroup] [GroupType] [SubGroup] [AlbumList] [StartIndex] [
		// [2;;2;;][][192.168.123.22][0;;20020206][SendingAlbumsOfSubGroup][Artist][Dido][No Angel;;White Flag;;][0][
		
		// BLink
		// *[SendingFoundAudio][][][20010106]
		//  [0;;12;;52] startindex;;itemcount;;totalrows
		//  [Artist;;]  srchCategory;;srchValue
		//  [;;]        filtCategory;;filtValue
		//  [Aimee Mann;;Air;;Ash;;Badly Drawn Boy;;Barry White;;Beatles;;Bee Gees;;Black Eyed Peas;;Blur;;Chemical Brothers;;Coldplay;;Craig David;;] srchCategory
		//  [] Artist for items (except when srchCategory is Artist?)
		//  [] Album for items
		//  [] Track IDs
		//  [;;;;;;;;;;;;;;;;;;;;;;;;] CoverArtURIs
		//  []# Appearing Track index
		
		// Check the content message is relavent
		//if(br_content == br)
		{
			char select_col[MAX_DS_SHORTFIELD];
			char select_text[MAX_DS_SHORTFIELD];
			
			char where_col[MAX_DS_SHORTFIELD];
			char where_text[MAX_DS_SHORTFIELD];
			char sCoverPort[8];
					
			integer totalrows;
			integer startindex;
			integer itemcount;
			integer i;
			integer doBlanking;
			
			
			sCoverPort = itoa(BLINKCOVER_PORT);
			startindex = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param1,';;',1))+1;
			itemcount = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param1,';;',2));
			totalrows =  atoi(fnHelper_GetDelimitedTokenAt(ipktin.param1,';;',3));
			
			if(THIS_DATASET.rowcount == 0) doBlanking = TRUE;
			THIS_DATASET.rowcount 	= totalrows;
			THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
			THIS_DATASET.pagetop	= startindex;
			THIS_DATASET.linecount 	= itemcount;
			THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
			
			// Set the state helper
			if(THIS_DATASET.rowcount == 0)  THIS_DATASET.status = DS_STATE_NORESULTS;
			else							THIS_DATASET.status = DS_STATE_READY;
			
			// Pull out the 'searchfor' & 'narrowby' fields			
			select_col = fnHelper_GetDelimitedTokenAt(ipktin.param2,';;',1);
			select_text = fnHelper_GetDelimitedTokenAt(ipktin.param2,';;',2);
			where_col = fnHelper_GetDelimitedTokenAt(ipktin.param3,';;',1);
			where_text = fnHelper_GetDelimitedTokenAt(ipktin.param3,';;',2);
			
			// Now the item values
			for(i=1; i <= THIS_DATASET.pagesize; i++)
			{
				// Deliver each page line
				if(i <= itemcount)
				{
				    char itemtext[MAX_DS_LONGFIELD];
				    char albumtext[MAX_DS_LONGFIELD];
				    char artisttext[MAX_DS_LONGFIELD];
				    char cover_path[MAX_DS_GUID];
				    
				    itemtext 	= fnHelper_GetDelimitedTokenAt(ipktin.param4,';;',i);
				    artisttext  = fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',i);
				    albumtext   = fnHelper_GetDelimitedTokenAt(ipktin.param6,';;',i);
				    
				    // Get the cover path and strip out the host and file name
				    cover_path  = fnHelper_GetDelimitedTokenAt(ipktin.param8,';;',i);
				    if(Length_String(cover_path) > 17)
				    {
					    
					    //Remove_String(cover_path,"':',sCoverPort,'/'",1); // Remove the host:port/ for now.
					    //cover_path = Left_String(cover_path,Length_Array(cover_path)-11);
				    }
				    
				    // Known cases where artist or album text will be blank
				    switch(select_col)
				    {
					    case 'Album':	
					    {
						    if(where_col == 'Artist') artisttext = where_text;							
						    albumtext = itemtext;
					    }
					    case 'Title':  // Music DVD's
					    {
						    switch(where_col)
						    {
							    case 'Album': albumtext = itemtext;
							    case 'Artist': artisttext = where_text;
						    }
					    }
				    }
				    
				    //cover_path = "'Audio/',artisttext,'/',albumtext";
				    // TODO: Use cover path data supplied in the packet
					
				    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, itemtext, albumtext, artisttext, cover_path);
				}
				// Blank off any empty page lines
				else
				    if(doBlanking)
					fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
			}
			
			// Update the UI
			//if(THIS_UI.curBrowser == br)
			{
				fnBrowserUIUpdate_PageNumber(ui,br);
				fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
			}
		}
	}
}
Define_Function fnBrowserBLinkComm_HandleFoundTracksPage(_BLINK_PACKET ipktin)
{
	integer br, ui, ds;
	
	br = ipktin.org_type;
	ui = ipktin.org_id;
	
	CHECK_UI
	CHECK_BROWSER
	{
		// BLink
		// [SendingFoundTracks][][][20030106]
		// [0;;8;;12;;] <startindex>;;<itemcount>;;<totalcount>
		// [Album;;Different Class] <filt1Category>;;<filt1Value>
		// [;;] <filt2Category>;;<filt2Value>
		//  <itemlist> [Bar Italia;;Common People;;Disco 2000;;Feeling Called Love;;I Spy;;Live Bed Show;;Mis-Shapes;;Monday Morning;;]
		//  <itemartists> [Pulp;;Pulp;;Pulp;;Pulp;;Pulp;;Pulp;;Pulp;;Pulp;;]
		//  <itemalbum> [Different Class;;Different Class;;Different Class;;Different Class;;Different Class;;Different Class;;Different Class;;Different Class;;]
		// [http://192.168.123.36:8081/audio/pulp/different+class/12+-+bar+italia.mp3;;http://192.168.123.36:8081/audio/pulp/different+class/03+-+common+people.mp3;;http://192.168.123.36:8081/audio/pulp/different+class/05+-+disco+2000.mp3;;http://192.168.123.36:8081/audio/pulp/different+class/09+-+feeling+called+love.mp3;;http://192.168.123.36:8081/audio/pulp/different+class/04+-+i+spy.mp3;;http://192.168.123.36:8081/audio/pulp/different+class/06+-+live+bed+show.mp3;;http://192.168.123.36:8081/audio/pulp/different+class/01+-+mis-shapes.mp3;;http://192.168.123.36:8081/audio/pulp/different+class/11+-+monday+morning.mp3;;]
		// [e:\Audio\Pulp\Different Class\folder.jpg;;e:\Audio\Pulp\Different Class\folder.jpg;;e:\Audio\Pulp\Different Class\folder.jpg;;e:\Audio\Pulp\Different Class\folder.jpg;;e:\Audio\Pulp\Different Class\folder.jpg;;e:\Audio\Pulp\Different Class\folder.jpg;;e:\Audio\Pulp\Different Class\folder.jpg;;e:\Audio\Pulp\Different Class\folder.jpg;;]
		// [12;;3;;5;;9;;4;;6;;1;;11;;]#
		
		// Check the content message is relavent
		//if(br_content == br)
		{
			char select_col[MAX_DS_SHORTFIELD];
			char select_text[MAX_DS_SHORTFIELD];
			
			char where_col[MAX_DS_SHORTFIELD];
			char where_text[MAX_DS_SHORTFIELD];
					
			integer totalrows;
			integer startindex;
			integer itemcount;
			integer i;
			integer doBlanking;
			
			startindex = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param1,';;',1))+1;
			itemcount = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param1,';;',2));
			totalrows =  atoi(fnHelper_GetDelimitedTokenAt(ipktin.param1,';;',3));
			
			if(THIS_DATASET.rowcount == 0) doBlanking = TRUE;
			THIS_DATASET.rowcount 	= totalrows;
			THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
			THIS_DATASET.pagetop	= startindex;
			THIS_DATASET.linecount 	= itemcount;
			THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
			
			// Set the state helper
			if(THIS_DATASET.rowcount == 0)  THIS_DATASET.status = DS_STATE_NORESULTS;
			else							THIS_DATASET.status = DS_STATE_READY;
			
			// Pull out the 'searchfor' & 'narrowby' fields			
			select_col = fnHelper_GetDelimitedTokenAt(ipktin.param2,';;',1);
			select_text = fnHelper_GetDelimitedTokenAt(ipktin.param2,';;',2);
			where_col = fnHelper_GetDelimitedTokenAt(ipktin.param3,';;',1);
			where_text = fnHelper_GetDelimitedTokenAt(ipktin.param3,';;',2);
			
			// Now the item values
			for(i=1; i <= THIS_DATASET.pagesize; i++)
			{
				// Deliver each page line
				if(i <= itemcount)
				{
					char itemtext[MAX_DS_LONGFIELD];
					char itemid[MAX_DS_LONGFIELD];
					char albumtext[MAX_DS_LONGFIELD];
					char artisttext[MAX_DS_LONGFIELD];
					char cover_path[MAX_DS_GUID];
					
					itemtext 	= fnHelper_GetDelimitedTokenAt(ipktin.param4,';;',i);
					artisttext  = fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',i);
					albumtext   = fnHelper_GetDelimitedTokenAt(ipktin.param6,';;',i);
					itemid		= fnHelper_GetDelimitedTokenAt(ipktin.param7,';;',i);
					
					// Get the cover path and strip out the host and file name
					cover_path  = fnHelper_GetDelimitedTokenAt(ipktin.param8,';;',i);
					if(Length_String(cover_path) > 17)
					{
						Remove_String(cover_path,"':8081/'",1); // Remove the host:port/ for now.
						cover_path = Left_String(cover_path,Length_Array(cover_path)-11);
					}
					
					// Known cases where artist or album text will be blank
					switch(select_col)
					{
						case 'Album':	
						{
							if(where_col == 'Artist') artisttext = where_text;							
							albumtext = itemtext;
						}
						case 'Title':  // Music DVD's
						{
							switch(where_col)
							{
								case 'Album': albumtext = itemtext;
								case 'Artist': artisttext = where_text;
							}
						}
					}
					
				    //cover_path = "'Audio/',artisttext,'/',albumtext";
				    // TODO: Use cover path data supplied in the packet
					
				    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, itemtext, itemid, artisttext, cover_path);
				}
				// Blank off any empty page lines
				else
				    if(doBlanking)
					fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
			}
			
			// Update the UI
			//if(THIS_UI.curBrowser == br)
			{
			    fnBrowserUIUpdate_PageNumber(ui,br);
			    fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
			}
		}
	}
}

Define_Function fnBrowserBLinkComm_HandleAudioQueuePage(_BLINK_PACKET ipktin)
{
    integer br, ui, z, ds;
    
    br = ipktin.org_type;
    ui = ipktin.org_id;
    z  = ipktin.isender;
    
    CHECK_UI
    CHECK_BROWSER
    {
	// BLink
	// [SendingAudioQueue][1][][200B0106]
	// [0][8][14][2]   Start, Count, Total, Current
	// [Chocolate;;Gleaming Auction;;Grazed Knees;;Half The Fun;;How To Be Dead;;Run;;Same;;Somewhere A Clock Is Ticking;;]
	// [\\idyl\audio\snow patrol\final straw\06 - chocolate.wav;;\\idyl\audio\snow patrol\final straw\03 - gleaming auction.wav;;\\idyl\audio\snow patrol\final straw\08 - grazed knees.wav;;\\idyl\audio\snow patrol\final straw\14 - half the fun.wav;;\\idyl\audio\snow patrol\final straw\01 - how to be dead.wav;;\\idyl\audio\snow patrol\final straw\07 - run.wav;;\\idyl\audio\snow patrol\final straw\12 - same.wav;;\\idyl\audio\snow patrol\final straw\11 - somewhere a clock is ticking.wav;;]
	// [][][]#
	
	// Check the content message is relavent
	//if(br_content == br)
	{
	    integer totalrows;
	    integer startindex;
	    integer itemcount;
	    long current_item;
	    integer hasCurrentItem;
	    integer i;
	    integer doBlanking;
	    
	    startindex = atoi(ipktin.param1)+1;
	    itemcount = atoi(ipktin.param2);
	    totalrows =  atoi(ipktin.param3);
	    current_item = atoi(ipktin.param4)+1;
	    
	    if(THIS_DATASET.rowcount == 0)
		doBlanking = TRUE;
	    THIS_DATASET.rowcount 	= totalrows;
	    THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
	    THIS_DATASET.pagetop	= startindex;
	    if(THIS_DATASET.linecount > itemcount)
		doBlanking = TRUE;
	    THIS_DATASET.linecount 	= itemcount;
	    THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
	    
	    // Save the playqueue position
	    THIS_ZONE.playqueue.position = current_item;
	    THIS_ZONE.playqueue.length   = totalrows;
	    
	    // Set the state helper
	    if(THIS_DATASET.rowcount == 0)
		THIS_DATASET.status = DS_STATE_NORESULTS;
	    else
		THIS_DATASET.status = DS_STATE_READY;
	    
	    // Now the item values
	    for(i=1; i <= THIS_DATASET.pagesize; i++)
	    {
		// Deliver each page line
		if(i <= itemcount)
		{
		    char itemtext[MAX_DS_LONGFIELD];
		    char albumtext[MAX_DS_LONGFIELD];
		    char artisttext[MAX_DS_LONGFIELD];
		    char cover_path[MAX_DS_GUID];
		    long item_row;
		    
		    itemtext = fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',i);
		    item_row = startindex+i-1;
		    //artisttext  = fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',i);
		    //albumtext   = fnHelper_GetDelimitedTokenAt(ipktin.param6,';;',i);
		    
		    // Get the cover path and strip out the host and file name
		    cover_path  = fnHelper_GetDelimitedTokenAt(ipktin.param6,';;',i);
		    if(Length_String(cover_path) > 17)
		    {
			Remove_String(cover_path,"':8081/'",1); // Remove the host:port/ for now.
			cover_path = Left_String(cover_path,Length_Array(cover_path)-11);
		    }
		    
		    //cover_path = "'Audio/',artisttext,'/',albumtext";
		    // TODO: Use cover path data supplied in the packet
		    
		    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, itemtext, albumtext, artisttext, cover_path);
		    if(item_row == current_item)
		    {
			THIS_BRWSR.selected = i;
			hasCurrentItem = TRUE;
		    }
		}
		// Blank off any empty page lines
		else
		    if(doBlanking)
			fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
	    }
	    
	    // Update the UI
	    //if(THIS_UI.curBrowser == br)
	    {
		if(hasCurrentItem == FALSE) THIS_BRWSR.selected = 0;
		fnBrowserUIUpdate_PageNumber(ui,br);
		fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	    }
	}
    }
}
Define_Function fnBrowserBLinkComm_HandleAudioQueueChangedNotification(_BLINK_PACKET ipktin)
{
	integer z;
	z = ipktin.isender;
	
	CHECK_ZONE
	{
		integer ui;
		
		for(ui=1; ui <= MAX_USERINTERFACES; ui++)
		{
			// Check for a UI set to this zone
			if(THIS_UI.curZone == z and THIS_UI.isonline)
			{
				integer br;
				br = BRWSR_CAT_PLAYQ
				
				// Check the UI is viewing the PlayQ
				if(THIS_UI.curBrowser == BRWSR_CAT_PLAYQ)
				{
					// Refresh the page
					fnBrowser_DS_FetchPage(ui,BRWSR_CAT_PLAYQ,THIS_BRWSR.dataset.pagenum);
				}
				else
				{
					THIS_BRWSR.dataset.status = DS_STATE_DIRTY;
				}
			}
		}
	}
}

Define_Function fnBrowserBLinkComm_HandleFoundMoviesPage(_BLINK_PACKET ipktin)
{
    integer br, ui, ds;
    
    br = ipktin.org_type;
    ui = ipktin.org_id;
    
    CHECK_UI
    CHECK_BROWSER
    {
	// [ItemCount;;TotalRows;;] ... [SendingAlbumsOfSubGroup] [GroupType] [SubGroup] [AlbumList] [StartIndex] [
	// [2;;2;;][][192.168.123.22][0;;20020206][SendingAlbumsOfSubGroup][Artist][Dido][No Angel;;White Flag;;][0][
	
	// Check the content message is relavent
	//if(br_content == br)
	{
	    char select_clause[MAX_DS_LONGFIELD];
	    char select_col[MAX_DS_SHORTFIELD];
	    char select_text[MAX_DS_SHORTFIELD];
	    
	    char where_clause[MAX_DS_LONGFIELD];
	    char where_col[MAX_DS_SHORTFIELD];
	    char where_text[MAX_DS_SHORTFIELD];
			    
	    integer totalrows;
	    integer startindex;
	    integer itemcount;
	    integer i;
	    integer doBlanking;
	    
	    startindex = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',1))+1;
	    itemcount = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',2));
	    totalrows =  atoi(fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',3));
	    
	    if(THIS_DATASET.rowcount == 0)
		doBlanking = TRUE;
	    THIS_DATASET.rowcount 	= totalrows;
	    THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
	    THIS_DATASET.pagetop	= startindex;
	    THIS_DATASET.linecount 	= itemcount;
	    THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
	    
	    // Set the state helper
	    if(THIS_DATASET.rowcount == 0)
		THIS_DATASET.status = DS_STATE_NORESULTS;
	    else
		THIS_DATASET.status = DS_STATE_READY;
	    
	    // Pull out the 'searchfor' & 'narrowby' fields
	    select_clause = fnHelper_GetDelimitedTokenAt(ipktin.param1,'::',1);
	    where_clause = fnHelper_GetDelimitedTokenAt(ipktin.param1,'::',2);
	    
	    if(select_clause != "")
	    {
		select_col = fnHelper_GetDelimitedTokenAt(select_clause,';;',1);
		select_text = fnHelper_GetDelimitedTokenAt(select_clause,';;',2);
	    }
	    
	    if(where_clause != "")
	    {
		where_col = fnHelper_GetDelimitedTokenAt(where_clause,';;',1);
		where_text = fnHelper_GetDelimitedTokenAt(where_clause,';;',2);
	    }
	    
	    
	    for(i=1; i <= THIS_DATASET.pagesize; i++)
	    {
		// Deliver each page line
		if(i <= itemcount)
		{
		    char itemtext[MAX_DS_LONGFIELD];
		    char qtext[MAX_DS_LONGFIELD];
		    char cover_path[MAX_DS_GUID];
		    char id[MAX_DS_GUID]
		    
		    itemtext	= fnHelper_GetDelimitedTokenAt(ipktin.param2,';;',i);
		    id		= fnHelper_GetDelimitedTokenAt(ipktin.param3,';;',i);
		    qtext  	= fnHelper_GetDelimitedTokenAt(ipktin.param4,';;',i);
		    
		    cover_path 	= fnHelper_MediaURLToCoverArtPath(id);
		    
		    // Known cases where artist or album text will be blank
		    switch(select_col)
		    {
			case 'Album':	
			{
			    if(where_col == 'Artist') {}//artisttext = where_text;							
			    //albumtext = itemtext;
			}
			case 'Title':  // Music DVD's
			{
			    switch(where_col)
			    {
				case 'Album': {}//albumtext = itemtext;
				case 'Artist': {}//artisttext = where_text;
			    }
			}
		    }

		    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, itemtext, id, qtext, cover_path);
		}
		// Blank off any empty page lines
		else
		    if(doBlanking)
			fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
	    }
	    
	    // Update the UI
	    //if(THIS_UI.curBrowser == br)
	    {
		fnBrowserUIUpdate_PageNumber(ui,br);
		fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	    }
	}
    }
}
Define_Function fnBrowserBLinkComm_HandleSubGroupsPage(_BLINK_PACKET ipktin)
{
    integer br, ui, ds;
    
    br = ipktin.org_type;
    ui = ipktin.org_id;
    
    CHECK_UI
    CHECK_BROWSER
    {
	// [TotalRows] ... [SendingSubGroups] [GroupType] [ContentList] [StartIndex] [ItemCount] [
	// [51][][192.168.123.22][0;;20010206][SendingSubGroups][Artist][Air;;Ash;;Badly Drawn Boy;;Barry White;;Beatles;;Bee Gees;;Black Eyed Peas;;Blur;;Chemical Brothers;;Coldplay;;][1][10][
	
	integer br_content;
	
	br_content = fnHelper_GroupTypeStringToCategory(ipktin.param1);
	
	// Check the content message is relavent
	if(br_content == br)
	{
	    integer totalrows;
	    integer startindex;
	    integer itemcount;
	    integer i;
	    integer doBlanking;
	    
	    totalrows = atoi(ipktin.param5);
	    startindex = atoi(ipktin.param3)+1;
	    itemcount = atoi(ipktin.param4);
	    
	    if(THIS_DATASET.rowcount == 0)
		doBlanking = TRUE;
	    THIS_DATASET.rowcount 	= totalrows;
	    THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
	    THIS_DATASET.pagetop	= startindex;
	    THIS_DATASET.linecount 	= itemcount;
	    THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
	    
	    // Set the state helper
	    if(THIS_DATASET.rowcount == 0)
		THIS_DATASET.status = DS_STATE_NORESULTS;
	    else
		THIS_DATASET.status = DS_STATE_READY;
	    
	    for(i=1; i <= THIS_DATASET.pagesize; i++)
	    {
		// Deliver each page line
		if(i <= itemcount)
		{
		    char itemtext[MAX_DS_LONGFIELD];
		    itemtext = fnHelper_GetDelimitedTokenAt(ipktin.param2,';;',i);
		    
		    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, itemtext, "", "", "");
		}
		// Blank off any empty page lines
		else
		    if(doBlanking)
			fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
	    }
	    
	    // Update the UI
	    //if(THIS_UI.curBrowser == br)
	    {
		fnBrowserUIUpdate_PageNumber(ui,br);
		fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	    }
	}
    }
}

Define_Function fnBrowserBLinkComm_HandleDistinctAlbumsPage(_BLINK_PACKET ipktin)
{
    integer br, ui, ds;
    
    br = ipktin.org_type;
    ui = ipktin.org_id;
    
    CHECK_UI
    CHECK_BROWSER
    {
	// [ItemCount;;TotalRows;;] ... [SendingDistinctAlbums] [GenreName] [AlbumList] [ArtistList] [StartIndex] [
	// [4;;1;;]...[0][SendingAlbumsOfGenre2][Dance][Outrospective;;][Faithless;;][0][
	
	// Check the content message is relavent
	//if(br_content == br)
	{
	    integer totalrows;
	    integer startindex;
	    integer itemcount;
	    integer i;
	    integer doBlanking;
	    
	    totalrows  = atoi(ipktin.param5);
	    startindex = atoi(ipktin.param3)+1;
	    itemcount  = atoi(ipktin.param4);
	    
	    if(THIS_DATASET.rowcount == 0)
		doBlanking = TRUE;
	    THIS_DATASET.rowcount 	= totalrows;
	    THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
	    THIS_DATASET.pagetop	= startindex;
	    THIS_DATASET.linecount 	= itemcount;
	    THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
	    
	    
	    // Set the state helper
	    if(THIS_DATASET.rowcount == 0)
		THIS_DATASET.status = DS_STATE_NORESULTS;
	    else
		THIS_DATASET.status = DS_STATE_READY;
	    
	    for(i=1; i <= THIS_DATASET.pagesize; i++)
	    {
		// Deliver each page line
		if(i <= itemcount)
		{
		    char albumtext[MAX_DS_LONGFIELD];
		    char artisttext[MAX_DS_LONGFIELD];
		    char cover_path[MAX_DS_GUID];
		    
		    albumtext 	= fnHelper_GetDelimitedTokenAt(ipktin.param1,';;',i);
		    artisttext 	= fnHelper_GetDelimitedTokenAt(ipktin.param2,';;',i);
		    cover_path = "'Audio/',artisttext,'/',albumtext";
		    
		    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, albumtext, albumtext, artisttext, cover_path);
		}
		// Blank off any empty page lines
		else
		    if(doBlanking)
			fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
	    }
	    
	    // Update the UI
	    //if(THIS_UI.curBrowser == br)
	    {
		fnBrowserUIUpdate_PageNumber(ui,br);
		fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	    }
	}
    }
}
Define_Function fnBrowserBLinkComm_HandleAlbumsOfSubGroupPage(_BLINK_PACKET ipktin)
{
    integer br, ui, ds;
    
    br = ipktin.org_type;
    ui = ipktin.org_id;
    
    CHECK_UI
    CHECK_BROWSER
    {
	// [ItemCount;;TotalRows;;] ... [SendingAlbumsOfSubGroup] [GroupType] [SubGroup] [AlbumList] [StartIndex] [
	// [2;;2;;][][192.168.123.22][0;;20020206][SendingAlbumsOfSubGroup][Artist][Dido][No Angel;;White Flag;;][0][
	
	// Check the content message is relavent
	//if(br_content == br)
	{
	    integer totalrows;
	    integer startindex;
	    integer itemcount;
	    integer i;
	    integer doBlanking;
	    
	    totalrows =  atoi(fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',2));
	    startindex = atoi(ipktin.param4)+1;
	    itemcount = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',1));
	    
	    if(THIS_DATASET.rowcount == 0) doBlanking = TRUE;
	    THIS_DATASET.rowcount 	= totalrows;
	    THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
	    THIS_DATASET.pagetop	= startindex;
	    THIS_DATASET.linecount 	= itemcount;
	    THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
	    
	    
	    // Set the state helper
	    if(THIS_DATASET.rowcount == 0)  THIS_DATASET.status = DS_STATE_NORESULTS;
	    else							THIS_DATASET.status = DS_STATE_READY;
	    
	    for(i=1; i <= THIS_DATASET.pagesize; i++)
	    {
		// Deliver each page line
		if(i <= itemcount)
		{
		    char itemtext[MAX_DS_LONGFIELD];
		    char cover_path[MAX_DS_LONGFIELD];
		    
		    itemtext = fnHelper_GetDelimitedTokenAt(ipktin.param3,';;',i);
		    cover_path = "'Audio/',ipktin.param2,'/',itemtext";
		    
		    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, itemtext, "", ipktin.param2, cover_path);
		}
		// Blank off any empty page lines
		else
		    if(doBlanking) fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
	    }
	    
	    // Update the UI
	    //if(THIS_UI.curBrowser == br)
	    {
		fnBrowserUIUpdate_PageNumber(ui,br);
		fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	    }
	}
    }
}

Define_Function fnBrowserBLinkComm_HandleAlbumsOfGenrePage(_BLINK_PACKET ipktin)
{
    integer br, ui, ds;
    
    br = ipktin.org_type;
    ui = ipktin.org_id;
    
    CHECK_UI
    CHECK_BROWSER
    {
	// [ItemCount;;TotalRows;;] ... [SendingAlbumsOfGenre] [GenreName] [AlbumList] [ArtistList] [StartIndex] [
	// [4;;1;;]...[0][SendingAlbumsOfGenre2][Dance][Outrospective;;][Faithless;;][0][
	
	// Check the content message is relavent
	//if(br_content == br)
	{
	    integer totalrows;
	    integer startindex;
	    integer itemcount;
	    integer i;
	    integer doBlanking;
	    
	    totalrows =  atoi(fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',2));
	    startindex = atoi(ipktin.param4)+1;
	    itemcount = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',1));
	    
	    if(THIS_DATASET.rowcount == 0) doBlanking = TRUE;
	    THIS_DATASET.rowcount 	= totalrows;
	    THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
	    THIS_DATASET.pagetop	= startindex;
	    THIS_DATASET.linecount 	= itemcount;
	    THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
	    
	    
	    // Set the state helper
	    if(THIS_DATASET.rowcount == 0)  THIS_DATASET.status = DS_STATE_NORESULTS;
	    else							THIS_DATASET.status = DS_STATE_READY;
	    
	    for(i=1; i <= THIS_DATASET.pagesize; i++)
	    {
		// Deliver each page line
		if(i <= itemcount)
		{
		    char albumtext[MAX_DS_LONGFIELD];
		    char artisttext[MAX_DS_LONGFIELD];
		    char cover_path[MAX_DS_LONGFIELD];
		    
		    albumtext 	= fnHelper_GetDelimitedTokenAt(ipktin.param2,';;',i);
		    artisttext 	= fnHelper_GetDelimitedTokenAt(ipktin.param3,';;',i);
		    cover_path = "'Audio/',artisttext,'/',albumtext";
		    
		    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, albumtext, albumtext, artisttext, cover_path);
		}
		// Blank off any empty page lines
		else
		    if(doBlanking)
			fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
	    }
	    
	    // Update the UI
	    //if(THIS_UI.curBrowser == br)
	    {
		fnBrowserUIUpdate_PageNumber(ui,br);
		fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	    }
	}
    }
}
Define_Function fnBrowserBLinkComm_HandleTrackGroupingPage(_BLINK_PACKET ipktin)
{
    integer br, ui, ds;
    
    br = ipktin.org_type;
    ui = ipktin.org_id;
    
    CHECK_UI
    CHECK_BROWSER
    {
	// [StartIndex;;TotalRows;;] ... [SendingTrackGrouping] [GroupType] [SubGroup] [TrackList] [] [
	// [0][][192.168.123.100][0;;20010206][SendingTrackGrouping][Genre][Pop][blistered heart;;New York Mining Disaster 1941;;...][][
	
	// Check the content message is relavent
	//if(br_content == br)
	{
	    integer totalrows;
	    integer startindex;
	    integer itemcount;
	    integer i;
	    integer endoflist;
	    integer doBlanking;
	    
	    totalrows =  atoi(fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',2));
	    startindex = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',1)) +1;
	    itemcount = 0; // This message doesnt tell us how many items are being returned we will have to count them.  :(
	    
	    if(THIS_DATASET.rowcount == 0)
		doBlanking = TRUE;
	    THIS_DATASET.rowcount 	= totalrows;
	    THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
	    THIS_DATASET.pagetop	= startindex;
	    THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
	    
	    // Set the state helper
	    if(THIS_DATASET.rowcount == 0)
		THIS_DATASET.status = DS_STATE_NORESULTS;
	    else
		THIS_DATASET.status = DS_STATE_READY;
	    
	    for(i=1; i <= THIS_DATASET.pagesize; i++)
	    {
		char itemtext[MAX_DS_LONGFIELD];
		if(!endoflist)	itemtext = fnHelper_GetDelimitedTokenAt(ipktin.param3,';;',i);
		
		// Deliver each page line
		if(itemtext != "" and endoflist == FALSE)
		{
		    THIS_DATASET.linecount = i;
		    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, itemtext, "", ipktin.param2, "");
		}
		// Blank off any empty page lines
		else
		{
		    endoflist = TRUE;
		    if(doBlanking)
			fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
		}
	    }
	    
	    // Update the UI
	    //if(THIS_UI.curBrowser == br)
	    {
		fnBrowserUIUpdate_PageNumber(ui,br);
		fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	    }
	}
    }
}

/**
*/
Define_Function fnBrowserBLinkComm_HandleMoviesPage(_BLINK_PACKET ipktin)
{
    integer br, ui, ds;
    
    br = ipktin.org_type;
    ui = ipktin.org_id;
    
    CHECK_UI
    CHECK_BROWSER
    {
	// [StartIndex] ... [SendingMovies] [] [TitlesList] [PathsList] [ItemCount;;TotalRows] [
	// [0][][192.168.123.100][;;20010206][SendingMovies][][A Bug's Life;;...;;][\\BLink\video\bugslife disk1a project file;;..;;][10;;71;;][
	
	// Check the content message is relavent
	//if(br_content == br)
	{
	    integer totalrows;
	    integer startindex;
	    integer itemcount;
	    integer i;
	    integer endoflist;
	    integer doBlanking;
	    
	    startindex = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param4,';;',1)) + 1;
	    itemcount = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param4,';;',2));
	    totalrows =  atoi(fnHelper_GetDelimitedTokenAt(ipktin.param4,';;',3));
	    
	    if(THIS_DATASET.rowcount == 0)
		doBlanking = TRUE;
	    THIS_DATASET.rowcount 	= totalrows;
	    THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
	    THIS_DATASET.pagetop	= startindex;
	    THIS_DATASET.linecount 	= itemcount;
	    THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
	    
	    
	    // Set the state helper
	    if(THIS_DATASET.rowcount == 0)
		THIS_DATASET.status = DS_STATE_NORESULTS;
	    else
		THIS_DATASET.status = DS_STATE_READY;
	    
	    for(i=1; i <= THIS_DATASET.pagesize; i++)
	    {
		char itemtext[MAX_DS_LONGFIELD];
		char id[MAX_DS_GUID];
		char cover_path[MAX_DS_GUID];
		
		/*if(!endoflist)	*/itemtext = fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',i);
		
		// Deliver each page line
		if(itemtext != "" and endoflist == FALSE)
		{
		    THIS_DATASET.linecount = i;
		    id = fnHelper_GetDelimitedTokenAt(ipktin.param7,';;',i);
		    cover_path = fnHelper_MediaURLToCoverArtPath(id);
		    id = fnHelper_GetDelimitedTokenAt(ipktin.param6,';;',i);
		    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, itemtext, id, "", cover_path);
		}
		// Blank off any empty page lines
		else
		{
		    endoflist = TRUE;
		    if(doBlanking)
			fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
		}
	    }
	    
	    // Update the UI
	    //if(THIS_UI.curBrowser == br)
	    {
		fnBrowserUIUpdate_PageNumber(ui,br);
		fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	    }
	}
    }
}

Define_Function fnBrowserBLinkComm_HandleRelatedMoviesPage(_BLINK_PACKET ipktin)
{
    integer br, ui, ds;
    
    br = ipktin.org_type;
    ui = ipktin.org_id;
    
    CHECK_UI
    CHECK_BROWSER
    {
	// [StartIndex] ... [SendingRelatedMovies] [] [TitlesList] [PathsList] [ItemCount;;TotalRows] [
	// [0][][192.168.123.100][;;20010206][SendingMovies][][A Bug's Life;;...;;][\\BLink\video\bugslife disk1a project file;;..;;][10;;71;;][
	
	// Check the content message is relavent
	//if(br_content == br)
	{
	    integer totalrows;
	    integer startindex;
	    integer itemcount;
	    integer i;
	    integer endoflist;
	    integer doBlanking;
	    
	    totalrows =  atoi(fnHelper_GetDelimitedTokenAt(ipktin.param4,';;',2));
	    startindex = atoi(ipktin.param5)+1;
	    itemcount = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',1));
	    
	    if(THIS_DATASET.rowcount == 0) doBlanking = TRUE;
	    THIS_DATASET.rowcount 	= totalrows;
	    THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
	    THIS_DATASET.pagetop	= startindex;
	    THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
	    
	    
	    // Set the state helper
	    if(THIS_DATASET.rowcount == 0)  THIS_DATASET.status = DS_STATE_NORESULTS;
	    else							THIS_DATASET.status = DS_STATE_READY;
	    
	    for(i=1; i <= THIS_DATASET.pagesize; i++)
	    {
		char itemtext[MAX_DS_LONGFIELD];
		char id[MAX_DS_GUID];
		char cover_path[MAX_DS_GUID];
		
		if(!endoflist)	itemtext = fnHelper_GetDelimitedTokenAt(ipktin.param2,';;',i);
		
		// Deliver each page line
		if(itemtext != "" and endoflist == FALSE)
		{
		    THIS_DATASET.linecount 	= i;
		    id = fnHelper_GetDelimitedTokenAt(ipktin.param3,';;',i);
		    cover_path = fnHelper_MediaURLToCoverArtPath(id);
		    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, itemtext, id, "", cover_path);
		}
		// Blank off any empty page lines
		else
		{
		    endoflist = TRUE;
		    if(doBlanking)
			fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
		}
	    }
	    
	    // Update the UI
	    //if(THIS_UI.curBrowser == br)
	    {
		fnBrowserUIUpdate_PageNumber(ui,br);
		fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	    }
	}
    }
}
Define_Function fnBrowserBLinkComm_HandleMovieGroupsPage(_BLINK_PACKET ipktin)
{
    integer br, ui, ds;
    
    br = ipktin.org_type;
    ui = ipktin.org_id;
    
    CHECK_UI
    CHECK_BROWSER
    {
	// [MaxRating] ... [SendingAlbumsOfSubGroup] [ContentType;;GroupType;;] [GroupsList] [StartIndex] [ItemCount;;TotalRows] [
	// [6][][192.168.123.100][;;20010206][SendingMovieGroups][DVD;;Actor;;][Aaron Ruell;;...;;][0][10;;289;;][
	
	// Check the content message is relavent
	//if(br_content == br)
	{
	    integer totalrows;
	    integer startindex;
	    integer itemcount;
	    integer i;
	    integer endoflist;
	    integer doBlanking;
	    char szType[64];
	    
	    startindex = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param4,';;',1)) + 1;
	    itemcount = atoi(fnHelper_GetDelimitedTokenAt(ipktin.param4,';;',2));
	    totalrows =  atoi(fnHelper_GetDelimitedTokenAt(ipktin.param4,';;',3));
	    
	    szType = fnHelper_GetDelimitedTokenAt(ipktin.param2,';;',1);
	    
	    if(THIS_DATASET.rowcount == 0)
		doBlanking = TRUE;
	    THIS_DATASET.rowcount 	= totalrows;
	    THIS_DATASET.pagecount	= fnHelper_DS_CalculatePageCount(totalrows,THIS_DATASET.pagesize);
	    THIS_DATASET.pagetop	= startindex;
	    THIS_DATASET.linecount 	= itemcount;
	    THIS_DATASET.pagenum 	= fnHelper_DS_CalculatePageNumber(startindex,THIS_DATASET.pagesize);
	    
	    // Set the state helper
	    if(THIS_DATASET.rowcount == 0)
		THIS_DATASET.status = DS_STATE_NORESULTS;
	    else
		THIS_DATASET.status = DS_STATE_READY;
		
	    for(i=1; i <= THIS_DATASET.pagesize; i++)
	    {
		char itemtext[MAX_DS_LONGFIELD];
		char id[MAX_DS_GUID];
		char cover_path[MAX_DS_GUID];
		
		if(!endoflist)	itemtext = fnHelper_GetDelimitedTokenAt(ipktin.param5,';;',i);
		
		// Deliver each page line
		if(itemtext != "" and endoflist == FALSE)
		{
		    THIS_DATASET.linecount 	= i;
		    cover_path = fnHelper_MediaURLToCoverArtPath(id);
		    fnBrowser_DS_DeliverPageItem(ui, br, i, startindex+i-1, itemtext, itemtext, "", cover_path);
		}
		// Blank off any empty page lines
		else
		{
		    endoflist = TRUE;
		    if(doBlanking)
			fnBrowser_DS_DeliverPageItem(ui, br, i, 0, "", "", "", "");
		}
	    }
	    
	    // Update the UI
	    //if(THIS_UI.curBrowser == br)
	    {
		fnBrowserUIUpdate_PageNumber(ui,br);
		fnBrowserUIUpdate_SelectedItem(ui,br,FALSE);
	    }
	}
    }
}
Define_Function fnBrowserCOMMS_NotifyState(integer newstate)
{
    switch(newstate)
    {
	case CNXST_CONNECTED:
	{
	}
	case CNXST_DISCONNECTED:
	{
	    // Invalidate the datasets
	    fnBrowser_DS_InvalidateDatasets(0);
	}
    }
}


/////////////////////////////////////////////////////////////////////////////// Playback functions
Define_Function fnPlayback_TransportFunction(integer z, integer func)
{
    CHECK_ZONE
    {
	switch(func)
	{
	    case TR_PLAY:
	    case TR_PAUSE:
	    {
		fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Pause');
	    }
	    case TR_STOP:	fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Stop');
	    /////// Next/Prev
	    case TR_FFWD:
	    {	
		fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'SkipRight'); // Next
	    }
	    case TR_REW:
	    {
		fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'SkipLeft'); // Prev
	    }
	    case TR_SFWD:	fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'ScanRight'); // Search Fwd
	    case TR_SREV:	fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'ScanLeft'); // Search Rev
	    case NAV_UP:	fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'CursorUp');
	    case NAV_DN:	fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'CursorDown');
	    case NAV_LT:	fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'CursorLeft');
	    case NAV_RT:	fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'CursorRight');
	    case NAV_SELECT:fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'OK');
	    case NAV_BACK:	fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Exit');  // Exit is Back??
	    case NAV_DVDMENU:fnBLINKTX_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Menu'); // Menu is DVD Menu??
	}
    }
}

/////////////////////////////////////////////////////////////////////////////// Playback functions
Define_Function fnPlayback_GUIFunction(integer z, integer func)
{
    CHECK_ZONE
    {
	switch(func)
	{	
	    case btn_GUI_Transport_Pause:	fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Pause');
	    case btn_GUI_Transport_Play:	fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Play');
	    case btn_GUI_Transport_Stop:	fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Stop');
	    case btn_GUI_Transport_SkipRight:	fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'SkipRight'); // Next
	    case btn_GUI_Transport_SkipLeft:	fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'SkipLeft'); // Prev
	    case btn_GUI_Transport_ScanRight:	fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'ScanRight'); // Search Fwd
	    case btn_GUI_Transport_ScanLeft:	fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'ScanLeft'); // Search Rev
	    case btn_NavCursorUp:		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'CursorUp');
	    case btn_NavCursorDown:    		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'CursorDown');		
	    case btn_NavCursorLeft:		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'CursorLeft');
	    case btn_NavCursorRight:		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'CursorRight');
	    case btn_NavCursorEnter:		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'OK');
	    case btn_NavMenu_Back:		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Exit');
	    case btn_NavMenu_Menu:		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Menu');
	    case btn_GUI_IR_Cycle_Browse:    	fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'CycleBrowseMode');
	    case btn_GUI_IR_Ch_Plus:		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'ChannelUp');
	    case btn_GUI_IR_Ch_Minus:		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'ChannelDown');
	    case btn_GUI_IR_Macro_Red:		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Red');
	    case btn_GUI_IR_Macro_Yellow:	fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Yellow');
	    case btn_GUI_IR_Macro_Green:	fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Green');
	    case btn_GUI_IR_Macro_Blue:		fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Blue');
	    case btn_0:				fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'0');
	    case btn_1:				fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'1');
	    case btn_2:				fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'2');
	    case btn_3:				fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'3');
	    case btn_4:				fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'4');
	    case btn_5:				fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'5');
	    case btn_6:				fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'6');
	    case btn_7:				fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'7');
	    case btn_8:				fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'8');
	    case btn_9:				fnBLINKTX_GUI_API_IRCmd(SEND_NOW,ORIGGRP_TR,0,0,"",z,'9');
	}
    }
}

Define_Function fnPlayback_PlayMode_Cycle(integer z)
{
    CHECK_ZONE
    {
	integer newMode;
	newMode = THIS_ZONE.playmode +1;
	
	if(newMode > PLAYMODE_SHUFFLE)
	    newMode = PLAYMODE_NORMAL; // AKA zero
	
	fnPlayback_PlayMode_Set(z, newMode);
    }
}

Define_Function fnPlayback_PlayMode_Set(integer z, integer playmode)
{
    CHECK_ZONE
    {
	if(playmode <= PLAYMODE_SHUFFLE)
	{
	    //THIS_ZONE.playmode = playmode;
    
	    switch(playmode)
	    {
		case PLAYMODE_NORMAL: fnBLINKTX_API_SetPlayMode(SEND_NOW,ORIGGRP_TR,0,0,"",z,"");
		case PLAYMODE_ONCE: fnBLINKTX_API_SetPlayMode(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Once');
		case PLAYMODE_REPEAT: fnBLINKTX_API_SetPlayMode(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Repeat');
		case PLAYMODE_SHUFFLE: fnBLINKTX_API_SetPlayMode(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Shuffle');
		case PLAYMODE_RANDOM: fnBLINKTX_API_SetPlayMode(SEND_NOW,ORIGGRP_TR,0,0,"",z,'Random');
	    }
	    // No feedback needed - BLink will notify us of the change
	}
    }
}

/**
    Выбор указанной зоны текущей
    на входе	:	ui	- интерфейс
			newZone	- номер зоны
    на выходе	:	*
*/
Define_Function fnPlayback_SetZone(integer ui, integer newZone)
{
    CHECK_UI
    {
	THIS_UI.curzone	= newZone;

	fnPlaybackUIUpdate_PlayMode(ui,newZone);
	fnPlaybackUIUpdate_Transport(ui,newZone);
	fnPlaybackUIUpdate_NowPlaying(ui,newZone);
	fnPlaybackUIUpdate_PlayTime(ui,newZone);
	fnPlaybackUIUpdate_PlayDuration(ui,newZone);
	fnPlaybackUIUpdate_PlayChapter(ui,newZone);
	fnPlaybackUIUpdate_PlayoutZone(ui);
	
	fnBrowser_ShowNowPlaying(ui);
	
	// Refresh the PlayQ browser
	fnBrowser_DS_CreateContentQuery(ui,BRWSR_CAT_PLAYQ,FALSE);
	fnBrowser_DS_InvalidateDatasets(ui);
	//fnBrowserUIUpdate_ClearPage(ui,THIS_UI.prevBrowser);
    }
}

/////////////////////////////////////////////////////////////////////////////// Playback UI
//// Update the UI with the latest error
Define_Function fnUIUpdate_ZoneError(integer z)
{

}

//// Update the UI with the new zone source value
Define_Function fnUIUpdate_ZoneSource(integer z)
{
	
}

//// Update the UI with the new play flag states
Define_Function fnPlaybackUIUpdate_PlayMode(integer uitarget, integer z)
{
    CHECK_ZONE
    {
	dev dvZoneUIs[MAX_USERINTERFACES];
	integer ui, uicount;
	
	// Selective ui update
	if(uitarget) ui = uitarget;
	else		 ui = 1;
	
	for( ; ui <= MAX_USERINTERFACES; ui++)
	{
	    if(THIS_UI.curzone == z)
	    {
		uicount++;
		dvZoneUIs[uicount] = THIS_UI.device;
		Set_Length_Array(dvZoneUIs,uicount);
	    }
	    if(uitarget) break;
	}
	
	if(uicount)
	{
	    [dvZoneUIs,btn_PlayMode_Once] 	= THIS_ZONE.playmode == PLAYMODE_ONCE;
	    [dvZoneUIs,btn_PlayMode_Repeat] = THIS_ZONE.playmode == PLAYMODE_REPEAT;
	    [dvZoneUIs,btn_PlayMode_Shuffle] = THIS_ZONE.playmode == PLAYMODE_SHUFFLE;
	}
    }
}

//// Update the UI with the new play flag states
Define_Function fnPlaybackUIUpdate_Transport(integer uitarget,integer z)
{
    CHECK_ZONE
    {
	dev dvZoneUIs[MAX_USERINTERFACES];
	integer ui, uicount;
	
	// Selective ui update
	if(uitarget) ui = uitarget;
	else		 ui = 1;
	
	for( ; ui <= MAX_USERINTERFACES; ui++)
	{
	    if(THIS_UI.curzone == z)
	    {
		uicount++;
		dvZoneUIs[uicount] = THIS_UI.device;
		Set_Length_Array(dvZoneUIs,uicount);
	    }
	    if(uitarget) break; // Just the 1?
	}
	
	if(uicount)
	{
	    //// Set the button feedback to indicate state
	    [dvZoneUIs,btn_PlayTransports[TR_PLAY]]  = THIS_ZONE.transport == TR_PLAY;
	    [dvZoneUIs,btn_PlayTransports[TR_STOP]]  = THIS_ZONE.transport == TR_STOP;
	    [dvZoneUIs,btn_PlayTransports[TR_PAUSE]] = THIS_ZONE.transport == TR_PAUSE;
	}
    }
}
Define_Function fnPlaybackUIUpdate_PlayTime(integer uitarget,integer z)
{
    CHECK_ZONE
    {
	dev dvZoneUIs[MAX_USERINTERFACES];
	dev dvG3ZoneUIs[MAX_USERINTERFACES];
	dev dvG4ZoneUIs[MAX_USERINTERFACES];
	integer uicount;
	
	uicount = fnGetZoneUIDeviceLists(uitarget, z, dvZoneUIs, dvG3ZoneUIs, dvG4ZoneUIs);
	
	if(uicount) 
	{
	    // Display the track time as reported by the unit
	    send_command dvZoneUIs,"'^UNI-',itoa(vtx_NowPlaying_Time),',0,',CP1251ToUNI(right_string(THIS_ZONE.playback.position,8))";
	    
	    //// Convert the time into seconds for the bargraph
	    {
		// But we can get the tiem from msecs.
		integer hh, mm, ss;
		long seconds, totalsecs;
		integer eightbit;
		
		hh = atoi(mid_string(THIS_ZONE.playback.position,1,4));
		mm = atoi(mid_string(THIS_ZONE.playback.position,6,2));
		ss = atoi(mid_string(THIS_ZONE.playback.position,9,2));
		
		seconds = THIS_ZONE.playback.position_secs; // Percentage returned by the BLinke at the moment.
		
		hh = atoi(mid_string(THIS_ZONE.playback.duration,1,4));
		mm = atoi(mid_string(THIS_ZONE.playback.duration,6,2));
		ss = atoi(mid_string(THIS_ZONE.playback.duration,9,2));
		
		totalsecs = THIS_ZONE.playback.duration_secs;  // Hopefully the API will give us the position in secs at some point
		
		send_command dvG4ZoneUIs,"'^BMF-',itoa(vtx_NowPlaying_TimeBar),',1&2,%GL0%GH',itoa(totalsecs)";
		send_level	dvG4ZoneUIs,lvl_NowPlaying_TimeBar,seconds;
		
		// Convert to 255 for G3
		if(totalsecs) eightbit = Type_Cast((seconds*255)/totalsecs);
		
		send_level	dvG3ZoneUIs,lvl_NowPlaying_TimeBar,eightbit;
	    }
	}
    }
}

Define_Function fnPlaybackUIUpdate_PlayDuration(integer uitarget, integer z)
{
    CHECK_ZONE
    {
	//// Build a list of devs for the feedback
	dev dvZoneUIs[MAX_USERINTERFACES];
	dev dvG3ZoneUIs[MAX_USERINTERFACES];
	dev dvG4ZoneUIs[MAX_USERINTERFACES];
	integer uicount;
	
	uicount = fnGetZoneUIDeviceLists(uitarget, z, dvZoneUIs, dvG3ZoneUIs, dvG4ZoneUIs);
	
	if(uicount) 
	{
	    send_command dvZoneUIs,"'^UNI-',itoa(vtx_NowPlaying_TrackLength),',0,',CP1251ToUNI(right_string(THIS_ZONE.playback.duration,8))";
	}
    }
}

Define_Function fnPlaybackUIUpdate_PlayChapter(integer uitarget, integer z)
{
    CHECK_ZONE
    {
	//// Build a list of devs for the feedback
	dev dvZoneUIs[MAX_USERINTERFACES];
	dev dvG3ZoneUIs[MAX_USERINTERFACES];
	dev dvG4ZoneUIs[MAX_USERINTERFACES];
	integer uicount;
	
	uicount = fnGetZoneUIDeviceLists(uitarget, z, dvZoneUIs, dvG3ZoneUIs, dvG4ZoneUIs);
	
	if(uicount) 
	{
	    char sChapterNumber[3];
	    
	    if(THIS_ZONE.nowplaying.video_guid != '')
	    {
		integer isMenu;
		integer chapter;
		
		isMenu = THIS_ZONE.playback.chapterismenu;
		chapter = THIS_ZONE.playback.chapter;
		
		// Work out how to display the chapter if available
		if(isMenu) // Track name contains track number
		    send_command dvZoneUIs,"'^UNI-', itoa(vtx_NowPlaying_Title),',0,[MENU] ',CP1251ToUNI(THIS_ZONE.nowplaying.name)";
		else if(chapter) 
		    send_command dvZoneUIs,"'^UNI-', itoa(vtx_NowPlaying_Title),',0,[Ch',format('%02.2d',chapter),'] ',CP1251ToUNI(THIS_ZONE.nowplaying.name)";
		else
		    send_command dvZoneUIs,"'^UNI-', itoa(vtx_NowPlaying_Title), CP1251ToUNI(THIS_ZONE.nowplaying.name)";
	    }
	}
    }
}

Define_Function fnPlaybackUIUpdate_NowPlaying(integer uitarget, integer z)
{
    CHECK_ZONE
    {
	//// Build a list of devs for the feedback
	dev dvZoneUIs[MAX_USERINTERFACES];
	dev dvG3ZoneUIs[MAX_USERINTERFACES];
	dev dvG4ZoneUIs[MAX_USERINTERFACES];
	integer uicount;
	
	uicount = fnGetZoneUIDeviceLists(uitarget, z, dvZoneUIs, dvG3ZoneUIs, dvG4ZoneUIs);
	
	if(uicount) 
	{
	    char guid[MAX_DS_GUID]
	    char album_guid[MAX_DS_GUID]
	    integer isVideo;
	    char sTrackNumber[3];
	    _COVERART_URL cover_urlstruct;
	    
	    guid 		= THIS_ZONE.nowplaying.guid;
	    album_guid 	= THIS_ZONE.nowplaying.album_guid;
	    isVideo		= Find_String(lower_string(album_guid),"'video/'",1);  // Attemp to detect video
	    sTrackNumber = left_string(THIS_ZONE.nowplaying.name,3);
	    fnHelper_CoverURIToHostPathFile(THIS_ZONE.nowplaying.album_guid, cover_urlstruct);
	    
	    // Work out how to display the track number if available
	    if(atoi(sTrackNumber) == THIS_ZONE.nowplaying.number) // Track name contains track number
		send_command dvZoneUIs,"'^UNI-', itoa(vtx_NowPlaying_Title),',0,',CP1251ToUNI(THIS_ZONE.nowplaying.name)";
	    else if(THIS_ZONE.nowplaying.number) 
		send_command dvZoneUIs,"'^UNI-', itoa(vtx_NowPlaying_Title),',0,',format('%02.2d',THIS_ZONE.nowplaying.number),'. ',CP1251ToUNI(THIS_ZONE.nowplaying.name)";
	    else
		send_command dvZoneUIs,"'^UNI-', itoa(vtx_NowPlaying_Title),',0,',CP1251ToUNI(THIS_ZONE.nowplaying.name)";
		    
	    // Standard text feilds
	    if(isVideo)
	    {
		send_command dvZoneUIs,"'^UNI-',itoa(vtx_NowPlaying_Artist),',0,',CP1251ToUNI(THIS_ZONE.nowplaying.artist)";
		send_command dvZoneUIs,"'^UNI-',itoa(vtx_NowPlaying_Album),',0,',CP1251ToUNI(THIS_ZONE.nowplaying.director)";
		send_command dvZoneUIs,"'^UNI-',itoa(vtx_NowPlaying_Genre),',0,',CP1251ToUNI(THIS_ZONE.nowplaying.genre)";
	    }
	    else
	    {
		send_command dvZoneUIs,"'^UNI-', itoa(vtx_NowPlaying_Artist),',0,',CP1251ToUNI(fnHelper_DS_PipeDelimitToCommaSep(THIS_ZONE.nowplaying.artist))";
		send_command dvZoneUIs,"'^UNI-', itoa(vtx_NowPlaying_Album),',0,',CP1251ToUNI(THIS_ZONE.nowplaying.album)";
		send_command dvZoneUIs,"'^UNI-', itoa(vtx_NowPlaying_Genre),',0,',CP1251ToUNI(fnHelper_DS_PipeDelimitToCommaSep(THIS_ZONE.nowplaying.genre))";
	    }
	    
	    /////// Cover Art			
	    fnSendDebugMsg("'NOW-PLAYING-MEDIA-URI : ',guid");
	    fnSendDebugMsg("'NOW-PLAYING-COVER-URL: ',album_guid");
	    
	    // Add the Dynamic image resource and save the resource name as the icon name
	    send_command dvG4ZoneUIs,"'^RAF-BLinkPlayCoverArt,%R0%N0'"; // G4 only
	    send_command dvG4ZoneUIs,"'^RMF-BLinkPlayCoverArt,%P0%H',cover_urlstruct.host,'%A',cover_urlstruct.path,'%F',cover_urlstruct.file"; // G4 only
	    // TEST send_command dvG4ZoneUIs,"'^RMF-BLinkPlayCoverArt,%P0%H',BLink.comms.url,':',itoa(BLink.about.coverart_port),'%Aaudio/beatles\magical mystery tour%Ffolder.jpg'"; // G4 only
	    // Assign the dynamic image to the button first removing any iconslot assigned
	    //Send_Command dvG4ZoneUIs,"'^ICO-',itoa(vtx_NowPlaying_CoverArt),',1&2,0'"; // G4
	    if(album_guid != "") // Check for probable content
		Send_Command dvG4ZoneUIs,"'^BMP-',itoa(vtx_NowPlaying_CoverArt),',1&2,BLinkPlayCoverArt'"; // G4 Only
	    else
		Send_Command dvG4ZoneUIs,"'^BMP-',itoa(vtx_NowPlaying_CoverArt),',1&2,dummy.jpg'"; // G4 Only
	}
    }
}

Define_Function fnPlaybackUIUpdate_DMS_Status(integer uitarget, integer z)
{
    // Tranport, playflags, elapsed time.
    CHECK_ZONE
    {
	dev dvZoneUIs[MAX_USERINTERFACES];
	dev dvG3ZoneUIs[MAX_USERINTERFACES];
	dev dvG4ZoneUIs[MAX_USERINTERFACES];
	integer uicount;
	
	uicount = fnGetZoneUIDeviceLists(uitarget, z, dvZoneUIs, dvG3ZoneUIs, dvG4ZoneUIs);
	
	if(uicount) 
	{
	    char sTransport[16];
	    char sPlayMode[8];
	    
	    sTransport = fnHelper_TransportFnToStateString(THIS_ZONE.transport);
	    
	    // Update the textual play flag buttons
	    switch(THIS_ZONE.playmode)
	    {
		case PLAYMODE_NORMAL: 	sPlayMode = '[Normal]';
		case PLAYMODE_ONCE: 	sPlayMode = '[Once]';
		case PLAYMODE_REPEAT: 	sPlayMode = '[Repeat]';
		case PLAYMODE_SHUFFLE: 	sPlayMode = '[Shuffle]';
		default: sPlayMode = '';
	    }
	    
	    // Display the track time as reported by the unit
	    send_command dvZoneUIs,"'!T',vtx_DMS_PlayingStatus,'Elapsed ',right_string(THIS_ZONE.playback.position,8),'  ',
								'[',sTransport,'] ',sPlayMode";
	}
    }
}
//// Update the current Playour zone for the UI
Define_Function fnPlaybackUIUpdate_PlayoutZone(integer ui)
{
    CHECK_UI
    {
	integer z;
	for(z=1; z <= MAX_ZONES; z++)
	{
	    if(z = THIS_UI.curzone)
	    {
		[THIS_UI.device,btn_PlayPlayoutZone[z]] = 1;
		if(THIS_ZONE.label == "")
		    send_command THIS_UI.device,"'!T',vtx_PlayCurrentZone,'Output ',itoa(z)";
		else
		    send_command THIS_UI.device,"'!T',vtx_PlayCurrentZone,THIS_ZONE.label";
	    }
	    else
		[THIS_UI.device,btn_PlayPlayoutZone[z]] = 0;
	}
    }
}

/**
    Обновление информации указаной зоны
    на входе	:	zone	- номер зоны (0 - обновить все зоны)
    на выходе	:	*
*/
Define_Function fnPlaybackUIUpdate_ZoneNames(integer zone)
{
    integer z;
    
    // Get the lists of panel types
    dev dvUIs[MAX_USERINTERFACES];
    dev dvG3UIs[MAX_USERINTERFACES];
    dev dvG4UIs[MAX_USERINTERFACES];
    
    fnGetUIDeviceLists(0, dvUIs, dvG3UIs, dvG4UIs);
    
    // Just one zone or all
    if(zone)
	z = zone;
    else
	z = 1;
    
    for( ; z <= MAX_ZONES; z++)
    {		
	// Existing zones
	if(THIS_ZONE.name != "")
	{
	    if(THIS_ZONE.isOnline == TRUE)
		send_command dvPanels,"'^ENA-',itoa(vtx_PlayPlayoutZone[z]),',1'";
    
	    // Show the button
	    send_command dvPanels,"'^SHO-',itoa(vtx_PlayPlayoutZone[z]),',1'";
    
	    // Update the labels
	    if(THIS_ZONE.label != "")
	    {
		char label[MAX_PARAMVAL];
		
		label = THIS_ZONE.label;
		if(!THIS_ZONE.isOnline) label = "label,' [Offline]'"
		send_command dvPanels,"'!T',vtx_PlayPlayoutZone[z],label";
	    }
	    else
		send_command dvPanels,"'!T',vtx_PlayPlayoutZone[z],'Output ',itoa(z)";
	    
	    if(THIS_ZONE.isOnline == FALSE)
		send_command dvPanels,"'^ENA-',itoa(vtx_PlayPlayoutZone[z]),',0'";
	}
	// None existing zones
	else 
	{
	    // Disable the button
	    send_command dvPanels,"'^SHO-',itoa(vtx_PlayPlayoutZone[z]),',0'";
	    send_command dvPanels,"'!T',vtx_PlayPlayoutZone[z],'- -'";
	}
	
	// Just the one?
	if(zone) break;
    }
}



Define_Function fnUIUpdate_About(integer uitarget)
{
    dev dvUIs[MAX_USERINTERFACES];
    integer ui, uicount;
    
    // Selective ui update
    if(uitarget)
	ui = uitarget;
    else
	ui = 1;
    
    for( ; ui <= MAX_USERINTERFACES; ui++)
    {
	if(THIS_UI.isonline)
	{
	    uicount++;
	    dvUIs[uicount] = THIS_UI.device;
	    Set_Length_Array(dvUIs,uicount);
	}
	if(uitarget) break;
    }
    
    if(uicount)
    {
	send_command dvUIs,"'!T',vtx_About_Server,BLink.about.vendor,' ',BLink.about.productname";
	send_command dvUIs,"'!T',vtx_About_Serial,BLink.about.serialno";
	send_command dvUIs,"'!T',vtx_About_BLinkSoft,BLink.about.softver";
	send_command dvUIs,"'!T',vtx_About_APIVer,ftoa(BLink.about.apiver)";
	send_command dvUIs,"'!T',vtx_About_IPAddress,'Base: ',BLink.comms[UNIT_SERVER].url";
	send_command dvUIs,"'!T',vtx_About_Outputs,'Total: ',itoa(blink.total_zonecount),'. Base: ',itoa(blink.server_zonecount),'. Links: ',itoa(blink.unit_count-1),'.'";
	send_command dvUIs,"'!T',vtx_About_Module,MODULE_VERSION,' ',__DATE__,' ',__TIME__";
    }
}
Define_Function fnUIUpdate_CommState(integer uitarget)
{
    dev dvUIs[MAX_USERINTERFACES];
    integer ui, uicount;
    
    // Selective ui update
    if(uitarget)
	ui = uitarget;
    else
	ui = 1;
    
    for( ; ui <= MAX_USERINTERFACES; ui++)
    {
	if(THIS_UI.isonline)
	{
	    uicount++;
	    dvUIs[uicount] = THIS_UI.device;
	    Set_Length_Array(dvUIs,uicount);
	}
	if(uitarget)
	    break;
    }
    
    if(uicount)
    {
	integer unit, unit_count;
	integer online_count;
	integer trying_count;
	integer offline_count;
	
	unit_count = Length_Array(dvBlinkComms);
	
	for(unit=1; unit <= unit_count; unit++)
	{
	    switch(blink.comms[unit].state)
	    {
		case CNXST_DISCONNECTED: offline_count++;
		case CNXST_TRYING:       trying_count++; 
		case CNXST_CONNECTED:	 online_count++;
	    }
	}
	
	// About page text
	if(online_count == unit_count) // All online
	    send_command dvUIs,"'!T',vtx_About_CommState,'Ok. All ',itoa(online_count),' Units Online.'";
	else
	    send_command dvUIs,"'!T',vtx_About_CommState,itoa(online_count),' Online. ',itoa(offline_count),' Offline. ',itoa(trying_count),' Trying.'";
	
	// About page buttons
	[dvUIs,btn_Comms_Connect] 	= online_count > 0;
	[dvUIs,btn_Comms_Disconnect] = online_count == 0;
    }
}


Define_Function fnBrowserUIUpdate_CDDriveState()
{
	
}
///////////////////////////////////////////////////////////////////////////////
// UI API

Define_Function fnUIAPI_DrillDown(integer ui, char sCategory[])
{
    CHECK_UI
    {
	integer br;

	br = fnHelper_StringToCategory(sCategory);
	
	CHECK_BROWSER
	{
		
	}
    }
}

Define_Function fnUIAPI_SetBrowserCategory(integer ui, char sCategory[])
{
    CHECK_UI
    {
	integer br;
	
	br = fnHelper_StringToCategory(sCategory);
	
	CHECK_BROWSER
	{
	    fnBrowser_SetBrowseCategory(ui,br,0);
	}
    }
}

Define_Function fnUIAPI_PlayQueueClear(integer z)
{
    CHECK_ZONE
    {
	// Clear the queue
    }
}


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
DEFINE_EVENT

///////// The Browser list item select buttons
BUTTON_EVENT[dvPanels,btn_BrwsList_CoverFields] // Main Browser
BUTTON_EVENT[dvPanels,btn_BrwsList_Fields] // Main Browser
{
    Release:
    {
	integer item, ui,br;
	item = 0;
	
	// Figure the UI
	ui = fnGetLastUI(button.input.device,dvPanels);	
	item = fnGetLastBtn(button.input.channel,btn_BrwsList_Fields);
	if(!item) item = fnGetLastBtn(button.input.channel,btn_BrwsList_CoverFields);
	
	CHECK_UI
	{
	    br = THIS_UI.curbrowser;
	    
	    if(item)
	    {
		if(!THIS_UI.drillbtn_hold) fnBrowser_SetSelectItem(ui,br,item);
		if(THIS_UI.resetpageinfo) fnBrowserUIUpdate_PageNumber(ui,br);
	    }
	    
	    THIS_UI.drillbtn_hold = 0;
	}
    }
    Hold[20]: /// Drill Down/Seed Browser with current selection
    {
	integer item, ui,br,destbr;
	item = 0;
	
	// Figure the UI
	ui = fnGetLastUI(button.input.device,dvPanels);	
	item = fnGetLastBtn(button.input.channel,btn_BrwsList_Fields);
	
	if(item)
	{
	    CHECK_UI
	    {
		THIS_UI.drillbtn_hold = 1;
		
		br = THIS_UI.curbrowser;
		CHECK_BROWSER
		{
		    fnBrowser_SetSelectItem(ui,br,item);
		    fnBrowser_SeedBrowser(ui,br,destbr,TRUE);
		    fnBrowser_RestoreBrowser(ui,destbr);
		    if(THIS_UI.resetpageinfo) fnBrowserUIUpdate_PageNumber(ui,destbr);
		}
	    }
	}
    }
}

BUTTON_EVENT[dvPanels,btn_BrwsList_SimilarMedia] // Simimilar paralell browser
{
	Release:
	{
		integer item, ui,br;
		item = 0;
		
		// Figure the UI
		ui = fnGetLastUI(button.input.device,dvPanels);	
		item = fnGetLastBtn(button.input.channel,btn_BrwsList_SimilarMedia);
		
		CHECK_UI
		{
			br = BRWSR_CAT_SIMILAR;
			
			if(item)
			{
				if(!THIS_UI.drillbtn_hold) fnBrowser_SetSelectItem(ui,br,item);
				if(THIS_UI.resetpageinfo) fnBrowserUIUpdate_PageNumber(ui,br);
			}
			
			THIS_UI.drillbtn_hold = 0;
		}
	}
	Hold[20]: /// Drill Down/Seed Browser with current selection
	{
		integer item, ui,br,destbr;
		item = 0;
		
		// Figure the UI
		ui = fnGetLastUI(button.input.device,dvPanels);	
		item = fnGetLastBtn(button.input.channel,btn_BrwsList_SimilarMedia);
		
		if(item)
		{
			CHECK_UI
			{
				THIS_UI.drillbtn_hold = 1;
				
				br = BRWSR_CAT_SIMILAR;
				CHECK_BROWSER
				{
					fnBrowser_SetSelectItem(ui,br,item);
					fnBrowser_SeedBrowser(ui,br,destbr,FALSE);
					fnBrowser_RestoreBrowser(ui,destbr);
					if(THIS_UI.resetpageinfo) fnBrowserUIUpdate_PageNumber(ui,destbr);
				}
			}
		}
		
	}
}

// Browser category selection
BUTTON_EVENT[dvPanels,btn_BrwsCategories]
{	
    Push:
    {
	integer ui, br;
	ui = fnGetLastUI(button.input.device,dvPanels);
	br = fnGetLastBtn(button.input.channel,btn_BrwsCategories);
	
	CHECK_UI
	CHECK_BROWSER
	{
	    if(THIS_UI.curBrowser == br)
		fnBrowser_SetBrowseCategory(ui,br,1);
	    else
		fnBrowser_SetBrowseCategory(ui,br,0);
	}
    }
}

BUTTON_EVENT[dvPanels,btn_BrwsFwdPath_Paths]
{
    Push:
    {
	integer ui, br, fwdpath;
	ui = fnGetLastUI(button.input.device,dvPanels);
	fwdpath = fnGetLastBtn(button.input.channel,btn_BrwsFwdPath_Paths);
	
	CHECK_UI
	{
	    br = THIS_UI.curbrowser;
	    CHECK_BROWSER
	    {
		fnBrowser_UseFwdPath(ui,fwdpath);
	    }
	}
    }
}

// Shared browser controls
BUTTON_EVENT[dvPanels,btn_BrwsPaging]
{
    Push:
    {
	integer ui, btn;
	ui = fnGetLastUI(button.input.device,dvPanels);
	btn = fnGetLastBtn(button.input.channel,btn_BrwsPaging);
	
	CHECK_UI
	{
	    integer br;
	    
	    br = THIS_UI.curbrowser
	    
	    CHECK_BROWSER
	    {
		switch(btn)
		{
		    case 1: fnBrowser_PageUP(ui,br); // Page Up One
		    case 2: fnBrowser_PageDW(ui,br); // Page Down One
		}
	    }
	}
    }
}

BUTTON_EVENT[dvPanels,btn_BrwsSimilar_Paging] // Similar/Related browser paging
{
    Push:
    {
	integer ui, btn;
	ui = fnGetLastUI(button.input.device,dvPanels);
	btn = fnGetLastBtn(button.input.channel,btn_BrwsSimilar_Paging);
	
	switch(btn)
	{
	    case 1: fnBrowser_PageUP(ui,BRWSR_CAT_SIMILAR); // Page Up One
	    case 2: fnBrowser_PageDW(ui,BRWSR_CAT_SIMILAR); // Page Down One
	}
    }
}
BUTTON_EVENT[dvPanels,btn_BrwsSelection]
{
    Push:
    {
	integer ui, btn;
	ui = fnGetLastUI(button.input.device,dvPanels);
	btn = fnGetLastBtn(button.input.channel,btn_BrwsSelection);
	
	switch(btn)
	{
	    case 1: fnBrowser_ItemSelectUP(ui); // Item selection Up One
	    case 2: fnBrowser_ItemSelectDW(ui); // Item selection Down One
	}
    }
	//Hold[5,REPEAT]:
//	{
//		integer ui, btn;
//		
//		ui = fnGetLastUI(button.input.device,dvPanels);
//		btn = fnGetLastBtn(button.input.channel,btn_BrwsSelection);
//		
//		switch(btn)
//		{
//			case 1: fnBrowser_ItemSelectUP(ui); // Item selection Up One
//			case 2: fnBrowser_ItemSelectDW(ui); // Item selection Down One
//		}
//	}
}

/**
    Нажатие на кнопку: Воспроизвести выбранное
*/
BUTTON_EVENT[dvPanels, btn_PlaySelected]
{
    Push:
    {
	integer ui,br;
	ui = fnGetLastUI(button.input.device,dvPanels);
	CHECK_UI
	{
	    // Check which browser was last in use
	    br = THIS_UI.lastselected_br;
	    CHECK_BROWSER
	    {
		fnBrowser_PlaySelected(ui,br);
	    }
	}
    }
}

/**
    Нажатие на кнопку: Воспроизвести выбранное
*/
BUTTON_EVENT[dvPanels,btn_DMS_PlayAction] // Multifunction Btn. PUSH: Adds to Queue; HOLD: Plays Selected. 
{
	Hold[20]: ///// Play Now
	{
		integer ui,br;
		ui = fnGetLastUI(button.input.device,dvPanels);
		
		CHECK_UI
		{
			THIS_UI.playaddbtn_hold = 1;
			
			br = THIS_UI.curbrowser;
			
			CHECK_BROWSER
			{
				//////// PlayQueue remove selected
				if(br == BRWSR_CAT_PLAYQ)
				{
					fnBrowser_PlayQueueRemoveSelected(ui);
					fnBrowserUIUpdate_ItemRemovedFromQueue(ui);
				}
				//////// Other Browsers Play Selected
				else
				{
					fnBrowser_PlaySelected(ui,br);
					if(THIS_UI.isDMS)
					{
						// Flip the page to the now playing page
						fnBrowser_ShowNowPlaying(ui);
					}				
				}
			}
		}
	}
	Release: ///// Add Selected to Queue
	{
		integer ui, br;
		
		ui = fnGetLastUI(button.input.device,dvPanels);
		
		CHECK_UI
		{
			br = THIS_UI.curBrowser;
			
			CHECK_BROWSER
			{
				// Only if no HOLD activated
				if(!THIS_UI.playaddbtn_hold)
				{
					///////// Action when on the PlayQueue
					if(br == BRWSR_CAT_PLAYQ) 
					{
						fnBrowser_PlaySelected(ui,br);
						if(THIS_UI.isDMS)
						{
							// Flip the page to the now playing page
							fnBrowser_ShowNowPlaying(ui);
						}
					}
					///////// Action for other browsers
					else
					{
						fnBrowser_PlayQueueAddSelected(ui,br);
						fnBrowserUIUpdate_ItemAddedToQueue(ui);
					}
				}
			}
			
			THIS_UI.playaddbtn_hold = 0;
		}
	}
}

BUTTON_EVENT[dvPanels,btn_BrwsRestore]
{
    Release: 
    {
	integer ui,br;
	ui = fnGetLastUI(button.input.device,dvPanels);
	CHECK_UI
	{
	    br = THIS_UI.prevBrowser;
	    
	    CHECK_BROWSER fnBrowser_RestoreBrowser(ui,br);
	    else fnBrowser_LibraryHome(ui);
	}
    }
}

BUTTON_EVENT[dvPanels,btn_BrwsTop]
{
    Release: 
    {
	integer ui,br;
	ui = fnGetLastUI(button.input.device,dvPanels);
	fnBrowser_LibraryHome(ui);
    }
}


BUTTON_EVENT[dvPanels,btn_BrwsBackup]
{
    Release:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);
	
	fnBrowser_BackUp(ui);
    }
}
BUTTON_EVENT[dvPanels,btn_Page_MediaLibrary]
{
    Push:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);
	
	fnBrowser_LibraryHome(ui);
    }
}

/**
    Обработчик нажатия на кнопку Library Audio
*/
BUTTON_EVENT[dvPanels,btn_Page_LibraryAudio]
{
    Push:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);
	
	fnBrowser_SetLibrary(ui,LIBRARY_AUDIO);
	//if(THIS_UI.lastAudioBr) fnBrowser_RestoreBrowser(ui,THIS_UI.lastAudioBr);
	//else 					fnBrowser_RestoreBrowser(ui,BRWSR_CAT_ALBUMS);
    }
}

/**
    Обработчик нажатия на кнопку Library Video
*/
BUTTON_EVENT[dvPanels,btn_Page_LibraryVideo]
{
    Push:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);
	
	fnBrowser_SetLibrary(ui,LIBRARY_VIDEO);
	if(THIS_UI.lastVideoBr) fnBrowser_RestoreBrowser(ui,THIS_UI.lastVideoBr);
	//else 					fnBrowser_RestoreBrowser(ui,BRWSR_CAT_MOVIES);
    }
}

/**
	Обработчик нажатия на кнопку Now Playing
*/
BUTTON_EVENT[dvPanels,btn_Page_NowPlaying]
{
    Push:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);

	fnBrowser_ShowNowPlaying(ui);
    }
}

/**
    Обработка кнопки добавления выбранного в список воспроизведения
    на входе	:	*
    на выходе	:	*
*/
BUTTON_EVENT[dvPanels, btn_BrwsAdd2Queue]
{
    Push:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);
	
	CHECK_UI
	{
	    integer br;
	    br = THIS_UI.curBrowser;
	    
	    CHECK_BROWSER
	    {
		fnBrowser_PlayQueueAddSelected(ui,br);
	    }
	}
    }
}

/**
    Обработка кнопки удаления элемента из списка воспроизведения
    на входе	:	*
    на выходе	:	*
*/
BUTTON_EVENT[dvPanels, btn_BrwsRemoveFromQueue]
{
    Push:
    {
    }
    Release:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);
	
	fnBrowser_PlayQueueRemoveSelected(ui);
    }
    Hold[30]: // For G3 as less room on CP4a
    {
	integer ui;
	
	ui = fnGetLastUI(button.input.device,dvPanels);
	
	fnBrowser_PlayQueueClear(ui);
    }
}

/**
    Обработка кнопки очистка списка воспроизведения
    на входе	:	*
    на выходе	:	*
*/
BUTTON_EVENT[dvPanels,btn_BrwsClearQueue]
{
    Push:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);
	
	fnBrowser_PlayQueueClear(ui);
    }
}
// Browser View Change

// Searching
BUTTON_EVENT[dvPanels,btn_BrwsSearch_Modes]
{
    Push:
    {
	integer ui, mode;
	ui = fnGetLastUI(button.input.device,dvPanels);
	mode = fnGetLastBtn(button.input.channel,btn_BrwsSearch_Modes);
	
	fnBrowser_Search_SetMode(ui,mode);
    }
}

BUTTON_EVENT[dvPanels, btn_BrwsSearch_Clear]
{
    Push:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);
	
	fnBrowser_Search_ClearSearch(ui);
    }
}

// Transport Control
BUTTON_EVENT[dvPanels,btn_PlayTransports]
{
    Push:
    {
	integer ui, func, z;
	ui = fnGetLastUI(button.input.device,dvPanels);
	func = fnGetLastBtn(button.input.channel,btn_PlayTransports);
	
	CHECK_UI
	{
	    z = THIS_UI.curzone;
	    fnPlayback_TransportFunction(z,func);
	}
    }
    Hold[5,REPEAT]:
    {
	integer ui, func, z;
	
	ui = fnGetLastUI(button.input.device,dvPanels);
	func = fnGetLastBtn(button.input.channel,btn_PlayTransports);
	
	CHECK_UI
	{
	    z = THIS_UI.curzone;
	    select
	    {
		active(func == TR_SFWD or func == TR_SREV): fnPlayback_TransportFunction(z,func);
	    }
	}
    }
}

BUTTON_EVENT[dvPanels,btn_GUI_IR]
{
    Push:
    {
	integer ui, z; 
	ui = fnGetLastUI(button.input.device,dvPanels);
	    
	CHECK_UI
	{		
	    z = THIS_UI.curzone;
		
	    CHECK_ZONE
	    {
		fnPlayback_GUIFunction(z, button.input.channel);
	    }
	}
    }
}

/**
    Обработка кнопки переключение режима воспроизведения
    на входе	:	*
    на выходе	:	*
*/
BUTTON_EVENT[dvPanels, btn_PlayModes]
{
    Push:
    {
	integer ui, playmode;
	ui = fnGetLastUI(button.input.device,dvPanels);
	playmode = fnGetLastBtn(button.input.channel,btn_PlayModes);
	
	CHECK_UI
	{
	    integer z;
	    z = THIS_UI.curzone;
	    
	    CHECK_ZONE
	    {
		if(THIS_ZONE.playmode == playmode)
		    fnPlayback_PlayMode_Set(z,PLAYMODE_NORMAL);
		else
		    fnPlayback_PlayMode_Set(z,playmode);
	    }
	}
    }
}

BUTTON_EVENT[dvPanels,btn_PlayMode_Cycle]
{
    Push:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);
	CHECK_UI
	{
	    integer z;
	    z = THIS_UI.curzone;
	    
	    fnPlayback_PlayMode_Cycle(z);
	}
    }
}

/**
    Обработка кнопки воспроизведение зоны
    на входе	:	*
    на выходе	:	*
*/
BUTTON_EVENT[dvPanels, btn_PlayPlayoutZone]
{
    Push:
    {
	integer ui, z;
	ui = fnGetLastUI(button.input.device,dvPanels);
	z = fnGetLastBtn(button.input.channel,btn_PlayPlayoutZone);
	
	CHECK_ZONE
	{
	    fnPlayback_SetZone(ui,z);
	}
    }
}

/**
    Обработка кнопки получения информации о сервере
    на входе	:	*
    на выходе	:	*
*/
BUTTON_EVENT[dvPanels,btn_About_GetInfo]
{
    Push:
    {
	integer ui;
	ui = fnGetLastUI(button.input.device,dvPanels);
	
	CHECK_UI
	{
	    fnUIUpdate_About(ui);
	    fnUIUpdate_CommState(ui);
	}
    }
}

/**
    Обработка кнопки Connect
    на входе	:	*
    на выходе	:	*
*/
BUTTON_EVENT[dvPanels,btn_Comms_Connect]
{
    Push:
    {
	integer u;
	u = Length_Array(dvBLinkComms);
	
	while(u)
	{
	    fnCOMMS_SetMaintainanceState(u,CNXST_CONNECTED);
	    u--;
	}
    }
}

/**
    Обработка кнопки Disconnect
    на входе	:	*
    на выходе	:	*
*/
BUTTON_EVENT[dvPanels,btn_Comms_Disconnect]
{
    Push:
    {
	integer u;
	u = Length_Array(dvBLinkComms);
	
	while(u)
	{
	    fnCOMMS_SetMaintainanceState(u,CNXST_DISCONNECTED);
	    u--;
	}
    }
}

///////// Panel Data Events
DATA_EVENT[dvPanels]
{
    Online:
    {
	integer ui;
	
	ui = fnGetLastUI(data.device,dvPanels);
	CHECK_UI
	{
	    // Get the device type
	    DEVICE_INFO(data.device,THIS_UI.devinfo);
	    THIS_UI.isonline = TRUE;
	    THIS_UI.device = data.device;
	    
	    // Do the official initialisation
	    fnBrowser_InitUI(ui);
	}
    }
    String:
    {
	integer ui;
	
	ui = fnGetLastUI(data.device,dvPanels);
	CHECK_UI
	{
	    select
	    {
		active(left_string(data.text,11) == 'BLINK.SRCH-'):
		{
		    char character;
		    character = data.text[Length_String(data.text)];
		    fnBrowser_Search_CharEntry(ui,character);
		}
		active(1):
		{
		    fnAPI_ProcessCommand(ui,data.text);
		}
	    }
	}
    }
    Offline:
    {
	integer ui;
	
	ui = fnGetLastUI(data.device,dvPanels);
	CHECK_UI
	{
	    THIS_UI.isonline = 0;
	    THIS_UI.initialised = FALSE;
	    //fnBrowser_DS_InvalidateDatasets(ui);
	}
    }
}

///////// General Startup Initialization
DATA_EVENT[vdvModule]
{
    Online:
    {
	// Basic initialisation at startup
	fnBrowser_Init();
    }
}

TIMELINE_EVENT[TL_SENDCMD_QUEUE]
{
    fnDeviceSendCmdQ_DeQueueCommand(sendcmd_queue);
}
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
DEFINE_PROGRAM

// END OF FILE ////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////