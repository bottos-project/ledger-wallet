/*
 * MIT License, see root folder for full license.
 */

#include "ui.h"
#include "blue_elements.h"
#include "glyphs.h"
#include "utils.h"

/** default font */
#define DEFAULT_FONT BAGL_FONT_OPEN_SANS_EXTRABOLD_11px | BAGL_FONT_ALIGNMENT_CENTER

#define DEFAULT_FONT_BLUE BAGL_FONT_OPEN_SANS_LIGHT_14px | BAGL_FONT_ALIGNMENT_CENTER | BAGL_FONT_ALIGNMENT_MIDDLE

/** text description font. */
#define TX_DESC_FONT BAGL_FONT_OPEN_SANS_REGULAR_11px | BAGL_FONT_ALIGNMENT_CENTER

/** the timer */
int exit_timer;

/** display for the timer */
char timer_desc[MAX_TIMER_TEXT_WIDTH];

/** UI state enum */
enum UI_STATE uiState;

/** UI state flag */
#ifdef TARGET_NANOX
#include "ux.h"
ux_state_t G_ux;
bolos_ux_params_t G_ux_params;
#else // TARGET_NANOX
ux_state_t ux;
#endif // TARGET_NANOX

/** notification to restart the hash */
unsigned char hashTainted;

/** notification to refresh the view, if we are displaying the public key */
unsigned char publicKeyNeedsRefresh;

/** the hash. */
cx_sha256_t hash;

/** index of the current screen. */
unsigned int curr_scr_ix;

/** max index for all screens. */
unsigned int max_scr_ix;

/** raw transaction data. */
unsigned char raw_tx[MAX_TX_RAW_LENGTH];

/** current index into raw transaction. */
unsigned int raw_tx_ix;

/** current length of raw transaction. */
unsigned int raw_tx_len;

// 展示待签名的hash
unsigned char sign_hash[12];

/** all text descriptions. */
char tx_desc[MAX_TX_TEXT_SCREENS][MAX_TX_TEXT_LINES][MAX_TX_TEXT_WIDTH];

/** currently displayed text description. */
char curr_tx_desc[MAX_TX_TEXT_LINES+2][MAX_TX_TEXT_WIDTH];

/** currently displayed public key */
char current_public_key[MAX_TX_TEXT_LINES][MAX_TX_TEXT_WIDTH];

/** UI was touched indicating the user wants to exit the app */
static const bagl_element_t *io_seproxyhal_touch_exit(const bagl_element_t *e);

/** UI was touched indicating the user wants to deny te signature request */
static const bagl_element_t *io_seproxyhal_touch_deny(const bagl_element_t *e);

/** display the UI for signing a transaction */
static void ui_sign(void);


/** sets the tx_desc variables to no information */
static void clear_tx_desc(void);

/** return app to dashboard */
static const bagl_element_t *bagl_ui_DASHBOARD_blue_button(const bagl_element_t *e);
/** goes to settings menu (pubkey display) on blue */
static const bagl_element_t *bagl_ui_SETTINGS_blue_button(const bagl_element_t *e);
/** returns to ONT app on blue */
static const bagl_element_t *bagl_ui_LEFT_blue_button(const bagl_element_t *e);


////////////////////////////////////  NANO X //////////////////////////////////////////////////
#ifdef TARGET_NANOX

UX_STEP_NOCB(
    ux_confirm_single_flow_1_step, 
    pnn, 
    {
      &C_icon_eye,
      "Review",
      "Transaction"
    });
UX_STEP_NOCB(
    ux_confirm_single_flow_2_step, 
    bn, 
    {
      "Type",
      curr_tx_desc[0]
    });
UX_STEP_NOCB(
    ux_confirm_single_flow_3_step, 
    bn, 
    {
      "Amount",
      curr_tx_desc[1],
    });
UX_STEP_NOCB(
    ux_confirm_single_flow_4_step, 
    bnnn, 
    {
      "Destination Address",
      curr_tx_desc[2],
      curr_tx_desc[3],
      curr_tx_desc[4]
    });
UX_STEP_VALID(
    ux_confirm_single_flow_5_step, 
    pb,
    io_seproxyhal_touch_approve(NULL), 
    {
      &C_icon_validate_14,
      "Accept",
    });
UX_STEP_VALID(
    ux_confirm_single_flow_6_step, 
    pb, 
    io_seproxyhal_touch_deny(NULL),
    {
      &C_icon_crossmark,
      "Reject",
    });
UX_FLOW(ux_confirm_single_flow,
  &ux_confirm_single_flow_1_step,
  &ux_confirm_single_flow_2_step,
  &ux_confirm_single_flow_3_step,
  &ux_confirm_single_flow_4_step,
  &ux_confirm_single_flow_5_step,
  &ux_confirm_single_flow_6_step
);



UX_STEP_NOCB(
    ux_display_public_flow_step, 
    bnnn, 
    {
      "Address",
      current_public_key[0],
      current_public_key[1],
      current_public_key[2]
    });
UX_STEP_VALID(
    ux_display_public_go_back_step, 
    pb, 
    ui_idle(),
    {
      &C_icon_back,
      "Back",
    });

UX_FLOW(ux_display_public_flow,
  &ux_display_public_flow_step,
  &ux_display_public_go_back_step
);

void display_account_address(){
	if(G_ux.stack_count == 0) {
			ux_stack_push();
		}
	ux_flow_init(0, ux_display_public_flow, NULL);
}

UX_STEP_NOCB(
    ux_idle_flow_1_step, 
    nn, 
    {
      "Application",
      "is ready",
    });
UX_STEP_VALID(
    ux_idle_flow_2_step,
    pbb,
    display_account_address(),
    {
      &C_icon_eye,
      "Display",
	  "Account"
    });
UX_STEP_NOCB(
    ux_idle_flow_3_step, 
    bn, 
    {
      "Version",
      APPVERSION,
    });
UX_STEP_VALID(
    ux_idle_flow_4_step,
    pb,
    os_sched_exit(-1),
    {
      &C_icon_dashboard,
      "Quit",
    });

UX_FLOW(ux_idle_flow,
  &ux_idle_flow_1_step,
  &ux_idle_flow_2_step,
  &ux_idle_flow_3_step,
  &ux_idle_flow_4_step
);


#endif
////////////////////////////////////////////////////////////////////////////////////////////////



/** UI struct for the idle screen */
static const bagl_element_t bagl_ui_idle_nanos[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0, 0, BAGL_FILL, 0x000000, 0xFFFFFF, 0,            0},                         NULL,        0, 0, 0, NULL, NULL, NULL,},
        /* center text */
        {{BAGL_LABELINE,  0x02, 0,   12, 128, 11, 0, 0, 0,         0xFFFFFF, 0x000000,
                 DEFAULT_FONT,                                                                       0},                         "Welcome Bottos", 0, 0, 0, NULL, NULL, NULL,},
        /* second line of description of current version */
		{	{	BAGL_LABELINE, 0x02, 10, 28, 108, 11, 0x80 | 10, 0, 0, 0xFFFFFF, 0x000000, TX_DESC_FONT, 0 },  "Version 1.0.0", 0, 0, 0, NULL, NULL, NULL, },
        /* left icon is a X */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0, 0, 0,         0xFFFFFF, 0x000000, 0,            BAGL_GLYPH_ICON_CROSS},     NULL,        0, 0, 0, NULL, NULL, NULL,},

/* */
};

/** UI struct for the idle screen, Blue.*/
static const bagl_element_t bagl_ui_idle_blue[] = {
    BG_FILL,
    HEADER_TEXT("Bottos"),
    HEADER_BUTTON_R(DASHBOARD),
    HEADER_BUTTON_L(SETTINGS),
    
    BODY_ONT_ICON,
    TEXT_CENTER(OPEN_TITLE, _Y(270), COLOUR_BLACK, FONT_L),
    TEXT_CENTER(OPEN_MESSAGE1, _Y(310), COLOUR_BLACK, FONT_S),
    TEXT_CENTER(OPEN_MESSAGE2, _Y(330), COLOUR_BLACK, FONT_S),
    TEXT_CENTER(OPEN_MESSAGE3, _Y(450), COLOUR_GREY, FONT_XS)
};

/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_idle_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            // only  main ui
            // ui_public_key_1();
            break;
        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            io_seproxyhal_touch_exit(NULL);
            break;
    }

    return 0;
}



/** UI struct for the top "test" screen, Nano S. */
const bagl_element_t bagl_ui_test_nanos[] = {
  // type                               userid    x    y   w    h  str rad fill      fg        bg      fid iid  txt   touchparams...       ]
  {{BAGL_RECTANGLE                      , 0x00,   0,   0, 128,  32, 0, 0, BAGL_FILL, 0x000000, 0xFFFFFF, 0, 0}, NULL, 0, 0, 0, NULL, NULL, NULL},

  {{BAGL_ICON                           , 0x00,   3,  12,   7,   7, 0, 0, 0        , 0xFFFFFF, 0x000000, 0, BAGL_GLYPH_ICON_CROSS  }, NULL, 0, 0, 0, NULL, NULL, NULL },
  {{BAGL_ICON                           , 0x00, 117,  13,   8,   6, 0, 0, 0        , 0xFFFFFF, 0x000000, 0, BAGL_GLYPH_ICON_CHECK  }, NULL, 0, 0, 0, NULL, NULL, NULL },

  //{{BAGL_ICON                           , 0x01,  31,   9,  14,  14, 0, 0, 0        , 0xFFFFFF, 0x000000, 0, BAGL_GLYPH_ICON_EYE_BADGE  }, NULL, 0, 0, 0, NULL, NULL, NULL },
  {{BAGL_LABELINE                       , 0x01,   0,  12, 128,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, "Are you sure?", 0, 0, 0, NULL, NULL, NULL },
 };

unsigned int test_touch_cancle(const bagl_element_t *e) {
    G_io_apdu_buffer[0] = 0x69;
    G_io_apdu_buffer[1] = 0x01;
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

unsigned int test_touch_ok(const bagl_element_t *e) {
    G_io_apdu_buffer[0] = 0x69;
    G_io_apdu_buffer[1] = 0x98;
    G_io_apdu_buffer[2] = 0x90;
    G_io_apdu_buffer[3] = 0x00;
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 4);
    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}


static unsigned int bagl_ui_test_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            test_touch_ok(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            test_touch_cancle(NULL);
            break;
    }
    return 0;
}


//--------------------------confirm sign menu----------------------------------------

/** UI struct for the idle screen */
static const bagl_element_t bagl_ui_sign_hash_nanos[] = {
// { {type, userid, x, y, width, height, stroke, radius, fill, fgcolor, bgcolor, font_id, icon_id},
// text, touch_area_brim, overfgcolor, overbgcolor, tap, out, over,
// },
        {{BAGL_RECTANGLE, 0x00, 0,   0,  128, 32, 0, 0, BAGL_FILL, 0x000000, 0xFFFFFF, 0,            0},                         NULL,        0, 0, 0, NULL, NULL, NULL,},
        /* center text */
        {{BAGL_LABELINE,  0x02, 0,   12, 128, 11, 0, 0, 0,         0xFFFFFF, 0x000000,
                 DEFAULT_FONT,                                                                       0},                         "Confirm Sign Tx ?", 0, 0, 0, NULL, NULL, NULL,},
        /* second line of description of current version */
		{	{	BAGL_LABELINE, 0x02, 10, 28, 108, 11, 0x80 | 10, 0, 0, 0xFFFFFF, 0x000000, TX_DESC_FONT, 0 },  sign_hash, 0, 0, 0, NULL, NULL, NULL, },
        /* left icon is a X */
        {{BAGL_ICON,      0x00, 3,   12, 7,   7,  0, 0, 0,         0xFFFFFF, 0x000000, 0,        BAGL_GLYPH_ICON_CROSS},     NULL,        0, 0, 0, NULL, NULL, NULL,},

        /* left icon is a V */
        {{BAGL_ICON,      0x00, 117,   12, 7,   7,  0, 0, 0,         0xFFFFFF, 0x000000, 0,    BAGL_GLYPH_ICON_CHECK},     NULL,        0, 0, 0, NULL, NULL, NULL,},

/* */
};

unsigned int sign_touch_cancle(const bagl_element_t *e) {
    G_io_apdu_buffer[0] = 0x69;
    G_io_apdu_buffer[1] = 0x01;
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

unsigned int sign_touch_ok(const bagl_element_t *e) {
    
    volatile unsigned int tx = 0;
    unsigned char *in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

    // 首先获取BIP44路径
    unsigned char *bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;
    unsigned int bip44_path[BIP44_PATH_LEN];
    uint8_t i;
    for (i = 0; i < BIP44_PATH_LEN; i++) {
            bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
        bip44_in += 4;
    }
    // 获取待签名的hash值
    unsigned char hash[32];
    unsigned char* hash_ptr = G_io_apdu_buffer + APDU_HEADER_LENGTH + BIP44_PATH_LEN*4;
    for (i = 0; i < sizeof(hash); i++){
        hash[i] = *(hash_ptr + i);
    }

    cx_ecfp_private_key_t privateKey;
    unsigned char privateKeyData[32];
    os_perso_derive_node_bip32(CX_CURVE_256K1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);
    cx_ecdsa_init_private_key(CX_CURVE_256K1, privateKeyData, 32, &privateKey);
    os_memset(privateKeyData, 0, sizeof(privateKeyData));

    // generate the public key.
    cx_ecfp_public_key_t publicKey;
    cx_ecdsa_init_public_key(CX_CURVE_256K1, NULL, 0, &publicKey);
    cx_ecfp_generate_pair(CX_CURVE_256K1, &publicKey, &privateKey, 1);
    
    // 进行签名
    uint8_t signature[100];
    unsigned int info = 0;
    os_memset(signature, 0, sizeof(signature));
    uint8_t signatureLength;
    signatureLength =
        cx_ecdsa_sign(&privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256,
                    hash,
                    sizeof(hash), signature, sizeof(signature),  &info);
    os_memset(&privateKey, 0, sizeof(privateKey));
    G_io_apdu_buffer[0] = 27;
    if (info & CX_ECCINFO_PARITY_ODD) {
    G_io_apdu_buffer[0]++;
    }
    if (info & CX_ECCINFO_xGTn) {
    G_io_apdu_buffer[0] += 2;
    }
    uint8_t rLength = signature[3];
    uint8_t sLength = signature[4 + rLength + 1];
    uint8_t rOffset = (rLength == 33 ? 1 : 0);
    uint8_t sOffset = (sLength == 33 ? 1 : 0);
    os_memmove(G_io_apdu_buffer + 1, signature + 4 + rOffset, 32);
    os_memmove(G_io_apdu_buffer + 1 + 32, signature + 4 + rLength + 2 + sOffset, 32);
    
    // os_memmove(G_io_apdu_buffer+1+32+32, publicKey.W, 65);
    // os_memmove(G_io_apdu_buffer+1+32+32+65, hash, 32);
    tx = 65;

    G_io_apdu_buffer[tx++] = 0x90;
    G_io_apdu_buffer[tx++] = 0x00;
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, tx);

    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

void update_sign_hash() {
        // 获取待签名的hash值
    unsigned char hash[32];
    unsigned char* hash_ptr = G_io_apdu_buffer + APDU_HEADER_LENGTH + BIP44_PATH_LEN*4;
    for (uint8_t i = 0; i < sizeof(hash); i++){
        hash[i] = *(hash_ptr + i);
    }
    os_memset(sign_hash, 0, sizeof(sign_hash));
    hex_to_str(hash, sign_hash, 2);
    sign_hash[4] = '*';
    sign_hash[5] = '*';
    sign_hash[6] = '*';
    hex_to_str(hash+30, sign_hash+7, 2);
}

static unsigned int bagl_ui_sign_hash_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            sign_touch_ok(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            sign_touch_cancle(NULL);
            break;
    }
    return 0;
}
//------------------------------------confirm sign menu end--------------------------------------------------



/** if the user wants to exit go back to the app dashboard. */
static const bagl_element_t *io_seproxyhal_touch_exit(const bagl_element_t *e) {
    // Go back to the dashboard
    os_sched_exit(0);
    return NULL; // do not redraw the widget
}

/** copy the current row of the tx_desc buffer into curr_tx_desc to display on the screen */
static void copy_tx_desc(void) {
    os_memmove(curr_tx_desc, tx_desc[curr_scr_ix], CURR_TX_DESC_LEN);
    curr_tx_desc[0][MAX_TX_TEXT_WIDTH - 1] = '\0';
    curr_tx_desc[1][MAX_TX_TEXT_WIDTH - 1] = '\0';
    curr_tx_desc[2][MAX_TX_TEXT_WIDTH - 1] = '\0';
}

/** processes the transaction approval. the UI is only displayed when all of the TX has been sent over for signing. */
const bagl_element_t *io_seproxyhal_touch_approve(const bagl_element_t *e) {
    unsigned int tx = 0;

    if (G_io_apdu_buffer[2] == P1_LAST) {
        unsigned int raw_tx_len_except_bip44 = raw_tx_len - BIP44_BYTE_LENGTH;
        // Update and sign the hash
        cx_hash(&hash.header, 0, raw_tx, raw_tx_len_except_bip44, NULL, 0);

        unsigned char *bip44_in = raw_tx + raw_tx_len_except_bip44;

        /** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
        unsigned int bip44_path[BIP44_PATH_LEN];
        uint32_t i;
        for (i = 0; i < BIP44_PATH_LEN; i++) {
            bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
            bip44_in += 4;
        }

        unsigned char privateKeyData[32];
        os_perso_derive_node_bip32(CX_CURVE_256R1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);

        cx_ecfp_private_key_t privateKey;
        cx_ecdsa_init_private_key(CX_CURVE_256R1, privateKeyData, 32, &privateKey);

        // Hash is finalized, send back the signature
        unsigned char tmp[32];
        unsigned char result[32];

        cx_hash(&hash.header, CX_LAST, raw_tx, 0, tmp, 32);

        cx_sha256_init(&hash);
        cx_hash(&hash.header, CX_LAST, tmp, 32, tmp, 32);

        cx_sha256_init(&hash);
        cx_hash(&hash.header, CX_LAST, tmp, 32, result, 32);
#if CX_APILEVEL >= 8
        tx = cx_ecdsa_sign((void*) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result, sizeof(result), G_io_apdu_buffer, sizeof(G_io_apdu_buffer), NULL);
#else
		tx = cx_ecdsa_sign((void*) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result, sizeof(result), G_io_apdu_buffer);
#endif
        // G_io_apdu_buffer[0] &= 0xF0; // discard the parity information
        hashTainted = 1;
#ifndef TARGET_NANOS
        clear_tx_desc();
#endif
        raw_tx_ix = 0;
        raw_tx_len = 0;

        // add hash to the response, so we can see where the bug is.
        G_io_apdu_buffer[tx++] = 0xFF;
        G_io_apdu_buffer[tx++] = 0xFF;
        for (int ix = 0; ix < 32; ix++) {
            G_io_apdu_buffer[tx++] = tmp[ix];
        }
    }
    G_io_apdu_buffer[tx++] = 0x90;
    G_io_apdu_buffer[tx++] = 0x00;
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, tx);
    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

/** deny signing. */
static const bagl_element_t *io_seproxyhal_touch_deny(const bagl_element_t *e) {
    hashTainted = 1;
#ifndef TARGET_NANOS
        clear_tx_desc();
#endif    raw_tx_ix = 0;
    raw_tx_len = 0;
    G_io_apdu_buffer[0] = 0x69;
    G_io_apdu_buffer[1] = 0x85;
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

static unsigned int bagl_ui_idle_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
}

static unsigned int bagl_ui_public_key_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
}

static unsigned int bagl_ui_top_sign_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
}


/** show the idle screen. */
void ui_idle(void) {
    uiState = UI_IDLE;

#if defined(TARGET_BLUE)
        UX_DISPLAY(bagl_ui_idle_blue, NULL);
#elif defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_idle_nanos, NULL);
#elif defined(TARGET_NANOX)
    // reserve a display stack slot if none yet
    if(G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_idle_flow, NULL);
#endif // #if TARGET_ID
}

/**ui 显示. */
void ui_test(void) {

#if defined(TARGET_BLUE)
        UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
#elif defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_test_nanos, NULL);
#elif defined(TARGET_NANOX)
    // reserve a display stack slot if none yet
    if(G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_confirm_single_flow, NULL);
#endif // #if TARGET_ID
}

/**ui 显示. */
void ui_confirm_sign(void) {
#if defined(TARGET_BLUE)
        UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
#elif defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_sign_hash_nanos, NULL);
#elif defined(TARGET_NANOX)
    // reserve a display stack slot if none yet
    if(G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_confirm_single_flow, NULL);
#endif // #if TARGET_ID
}

/** returns the length of the transaction in the buffer. */
unsigned int get_apdu_buffer_length() {
    unsigned int len0 = G_io_apdu_buffer[APDU_BODY_LENGTH_OFFSET];
    return len0;
}

/** set the blue menu bar colour */
void ui_set_menu_bar_colour(void) {
#if defined(TARGET_BLUE)
    UX_SET_STATUS_BAR_COLOR(COLOUR_WHITE, COLOUR_ONT_GREEN);
    clear_tx_desc();
#endif // #if TARGET_ID
}

/** sets the tx_desc variables to no information */
static void clear_tx_desc(void) {
    for(uint8_t i=0; i<MAX_TX_TEXT_SCREENS; i++) {
        for(uint8_t j=0; j<MAX_TX_TEXT_LINES; j++) {
            tx_desc[i][j][0] = '\0';
            tx_desc[i][j][MAX_TX_TEXT_WIDTH - 1] = '\0';
        }
    }
    
    strncpy(tx_desc[1][0], NO_INFO, sizeof(NO_INFO));
    strncpy(tx_desc[2][0], NO_INFO, sizeof(NO_INFO));
}

/** returns to dashboard */
static const bagl_element_t *bagl_ui_DASHBOARD_blue_button(const bagl_element_t *e)
{
    os_sched_exit(0);
    return NULL;
}

// /** goes to settings menu (pubkey display) on blue */
// static const bagl_element_t *bagl_ui_SETTINGS_blue_button(const bagl_element_t *e)
// {
//     UX_DISPLAY(bagl_ui_public_key_blue, NULL);
//     return NULL;
// }

// /** returns to ONT app on blue */
// static const bagl_element_t *bagl_ui_LEFT_blue_button(const bagl_element_t *e)
// {
//     ui_idle();
//     return NULL;
// }
