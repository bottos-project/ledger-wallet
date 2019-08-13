
bin/app.elf:     file format elf32-littlearm


Disassembly of section .text:

c0d00000 <main>:
    // command has been processed, DO NOT reset the current APDU transport
    return 1;
}

/** boot up the app and intialize it */
__attribute__((section(".boot"))) int main(void) {
c0d00000:	b5b0      	push	{r4, r5, r7, lr}
c0d00002:	b08c      	sub	sp, #48	; 0x30
    // exit critical section
    __asm volatile("cpsie i");
c0d00004:	b662      	cpsie	i

    curr_scr_ix = 0;
c0d00006:	4825      	ldr	r0, [pc, #148]	; (c0d0009c <main+0x9c>)
c0d00008:	2400      	movs	r4, #0
c0d0000a:	6004      	str	r4, [r0, #0]
    max_scr_ix = 0;
c0d0000c:	4824      	ldr	r0, [pc, #144]	; (c0d000a0 <main+0xa0>)
c0d0000e:	6004      	str	r4, [r0, #0]
    raw_tx_ix = 0;
c0d00010:	4824      	ldr	r0, [pc, #144]	; (c0d000a4 <main+0xa4>)
c0d00012:	6004      	str	r4, [r0, #0]
    hashTainted = 1;
c0d00014:	4824      	ldr	r0, [pc, #144]	; (c0d000a8 <main+0xa8>)
c0d00016:	2101      	movs	r1, #1
c0d00018:	7001      	strb	r1, [r0, #0]
    uiState = UI_IDLE;
c0d0001a:	4824      	ldr	r0, [pc, #144]	; (c0d000ac <main+0xac>)
c0d0001c:	7001      	strb	r1, [r0, #0]

    // ensure exception will work as planned
    os_boot();
c0d0001e:	f000 fd93 	bl	c0d00b48 <os_boot>

    UX_INIT();
c0d00022:	4823      	ldr	r0, [pc, #140]	; (c0d000b0 <main+0xb0>)
c0d00024:	22b0      	movs	r2, #176	; 0xb0
c0d00026:	4621      	mov	r1, r4
c0d00028:	f000 fe3c 	bl	c0d00ca4 <os_memset>
c0d0002c:	ad01      	add	r5, sp, #4

    BEGIN_TRY
    {
        TRY
c0d0002e:	4628      	mov	r0, r5
c0d00030:	f004 f94c 	bl	c0d042cc <setjmp>
c0d00034:	8528      	strh	r0, [r5, #40]	; 0x28
c0d00036:	491f      	ldr	r1, [pc, #124]	; (c0d000b4 <main+0xb4>)
c0d00038:	4208      	tst	r0, r1
c0d0003a:	d002      	beq.n	c0d00042 <main+0x42>
c0d0003c:	a801      	add	r0, sp, #4
            Timer_Set();

            // run main event loop.
            bottos_main();
        }
        CATCH_OTHER(e)
c0d0003e:	8504      	strh	r4, [r0, #40]	; 0x28
c0d00040:	e019      	b.n	c0d00076 <main+0x76>
c0d00042:	a801      	add	r0, sp, #4

    UX_INIT();

    BEGIN_TRY
    {
        TRY
c0d00044:	f000 fd83 	bl	c0d00b4e <try_context_set>
        {
            io_seproxyhal_init();
c0d00048:	f001 f826 	bl	c0d01098 <io_seproxyhal_init>
c0d0004c:	2000      	movs	r0, #0
                // restart IOs
                BLE_power(1, NULL);
            }
#endif

            USB_power(0);
c0d0004e:	f003 ff5b 	bl	c0d03f08 <USB_power>
            USB_power(1);
c0d00052:	2001      	movs	r0, #1
c0d00054:	f003 ff58 	bl	c0d03f08 <USB_power>

            // init the public key display to "no public key".
            //display_no_public_key();

            // set menu bar colour for blue
            ui_set_menu_bar_colour();
c0d00058:	f003 f808 	bl	c0d0306c <ui_set_menu_bar_colour>

            // show idle screen.
            ui_idle();
c0d0005c:	f002 fe04 	bl	c0d02c68 <ui_idle>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d00060:	4815      	ldr	r0, [pc, #84]	; (c0d000b8 <main+0xb8>)
c0d00062:	4916      	ldr	r1, [pc, #88]	; (c0d000bc <main+0xbc>)
c0d00064:	6001      	str	r1, [r0, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d00066:	4816      	ldr	r0, [pc, #88]	; (c0d000c0 <main+0xc0>)
c0d00068:	2104      	movs	r1, #4
c0d0006a:	a216      	add	r2, pc, #88	; (adr r2, c0d000c4 <main+0xc4>)
c0d0006c:	2308      	movs	r3, #8
c0d0006e:	f001 fd0d 	bl	c0d01a8c <snprintf>

            // set timer
            Timer_Set();

            // run main event loop.
            bottos_main();
c0d00072:	f000 fb03 	bl	c0d0067c <bottos_main>
        }
        CATCH_OTHER(e)
        {
        }
        FINALLY
c0d00076:	f000 fed7 	bl	c0d00e28 <try_context_get>
c0d0007a:	a901      	add	r1, sp, #4
c0d0007c:	4288      	cmp	r0, r1
c0d0007e:	d103      	bne.n	c0d00088 <main+0x88>
c0d00080:	f000 fed4 	bl	c0d00e2c <try_context_get_previous>
c0d00084:	f000 fd63 	bl	c0d00b4e <try_context_set>
c0d00088:	a801      	add	r0, sp, #4
        {
        }
    }
    END_TRY;
c0d0008a:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d0008c:	2800      	cmp	r0, #0
c0d0008e:	d102      	bne.n	c0d00096 <main+0x96>
}
c0d00090:	2000      	movs	r0, #0
c0d00092:	b00c      	add	sp, #48	; 0x30
c0d00094:	bdb0      	pop	{r4, r5, r7, pc}
        }
        FINALLY
        {
        }
    }
    END_TRY;
c0d00096:	f000 fec2 	bl	c0d00e1e <os_longjmp>
c0d0009a:	46c0      	nop			; (mov r8, r8)
c0d0009c:	20001c44 	.word	0x20001c44
c0d000a0:	20001c48 	.word	0x20001c48
c0d000a4:	20001b80 	.word	0x20001b80
c0d000a8:	20001b7c 	.word	0x20001b7c
c0d000ac:	20001b84 	.word	0x20001b84
c0d000b0:	20001b88 	.word	0x20001b88
c0d000b4:	0000ffff 	.word	0x0000ffff
c0d000b8:	20001c38 	.word	0x20001c38
c0d000bc:	00001002 	.word	0x00001002
c0d000c0:	20001c3c 	.word	0x20001c3c
c0d000c4:	00006425 	.word	0x00006425

c0d000c8 <io_exchange_al>:
#define P1_CONFIRM 0x01

#define P1_NO_CONFIRM 0x00

/** some kind of event loop */
unsigned short io_exchange_al(unsigned char channel, unsigned short tx_len) {
c0d000c8:	b5b0      	push	{r4, r5, r7, lr}
c0d000ca:	4605      	mov	r5, r0
c0d000cc:	2007      	movs	r0, #7
    switch (channel & ~(IO_FLAGS)) {
c0d000ce:	4028      	ands	r0, r5
c0d000d0:	2400      	movs	r4, #0
c0d000d2:	2801      	cmp	r0, #1
c0d000d4:	d013      	beq.n	c0d000fe <io_exchange_al+0x36>
c0d000d6:	2802      	cmp	r0, #2
c0d000d8:	d113      	bne.n	c0d00102 <io_exchange_al+0x3a>
        case CHANNEL_KEYBOARD:
            break;

            // multiplexed io exchange over a SPI channel and TLV encapsulated protocol
        case CHANNEL_SPI:
            if (tx_len) {
c0d000da:	2900      	cmp	r1, #0
c0d000dc:	d008      	beq.n	c0d000f0 <io_exchange_al+0x28>
                io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d000de:	480c      	ldr	r0, [pc, #48]	; (c0d00110 <io_exchange_al+0x48>)
c0d000e0:	f002 f878 	bl	c0d021d4 <io_seproxyhal_spi_send>

                if (channel & IO_RESET_AFTER_REPLIED) {
c0d000e4:	b268      	sxtb	r0, r5
c0d000e6:	2800      	cmp	r0, #0
c0d000e8:	da09      	bge.n	c0d000fe <io_exchange_al+0x36>
                    reset();
c0d000ea:	f001 ff0d 	bl	c0d01f08 <reset>
c0d000ee:	e006      	b.n	c0d000fe <io_exchange_al+0x36>
                }
                // nothing received from the master so far
                //(it's a tx transaction)
                return 0;
            } else {
                return io_seproxyhal_spi_recv(G_io_apdu_buffer, sizeof(G_io_apdu_buffer), 0);
c0d000f0:	21ff      	movs	r1, #255	; 0xff
c0d000f2:	3152      	adds	r1, #82	; 0x52
c0d000f4:	4806      	ldr	r0, [pc, #24]	; (c0d00110 <io_exchange_al+0x48>)
c0d000f6:	2200      	movs	r2, #0
c0d000f8:	f002 f898 	bl	c0d0222c <io_seproxyhal_spi_recv>
c0d000fc:	4604      	mov	r4, r0
        default:
            hashTainted = 1;
            THROW(INVALID_PARAMETER);
    }
    return 0;
}
c0d000fe:	4620      	mov	r0, r4
c0d00100:	bdb0      	pop	{r4, r5, r7, pc}
            } else {
                return io_seproxyhal_spi_recv(G_io_apdu_buffer, sizeof(G_io_apdu_buffer), 0);
            }

        default:
            hashTainted = 1;
c0d00102:	4804      	ldr	r0, [pc, #16]	; (c0d00114 <io_exchange_al+0x4c>)
c0d00104:	2101      	movs	r1, #1
c0d00106:	7001      	strb	r1, [r0, #0]
            THROW(INVALID_PARAMETER);
c0d00108:	2002      	movs	r0, #2
c0d0010a:	f000 fe88 	bl	c0d00e1e <os_longjmp>
c0d0010e:	46c0      	nop			; (mov r8, r8)
c0d00110:	200018f8 	.word	0x200018f8
c0d00114:	20001b7c 	.word	0x20001b7c

c0d00118 <io_seproxyhal_display>:

	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
c0d00118:	b580      	push	{r7, lr}
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d0011a:	f001 f931 	bl	c0d01380 <io_seproxyhal_display_default>
}
c0d0011e:	bd80      	pop	{r7, pc}

c0d00120 <io_event>:

unsigned char io_event(unsigned char channel) {
c0d00120:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00122:	b085      	sub	sp, #20
    // nothing done with the event, throw an error on the transport layer if
    // needed

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
c0d00124:	4df6      	ldr	r5, [pc, #984]	; (c0d00500 <io_event+0x3e0>)
c0d00126:	7829      	ldrb	r1, [r5, #0]
c0d00128:	48f6      	ldr	r0, [pc, #984]	; (c0d00504 <io_event+0x3e4>)
c0d0012a:	290c      	cmp	r1, #12
c0d0012c:	dc36      	bgt.n	c0d0019c <io_event+0x7c>
c0d0012e:	2905      	cmp	r1, #5
c0d00130:	d07f      	beq.n	c0d00232 <io_event+0x112>
c0d00132:	290c      	cmp	r1, #12
c0d00134:	d000      	beq.n	c0d00138 <io_event+0x18>
c0d00136:	e0f3      	b.n	c0d00320 <io_event+0x200>
    exit_timer = MAX_EXIT_TIMER;
    Timer_UpdateDescription();
}

static void Timer_Restart() {
    if (exit_timer != MAX_EXIT_TIMER) {
c0d00138:	49f3      	ldr	r1, [pc, #972]	; (c0d00508 <io_event+0x3e8>)
c0d0013a:	680a      	ldr	r2, [r1, #0]
c0d0013c:	4282      	cmp	r2, r0
c0d0013e:	d006      	beq.n	c0d0014e <io_event+0x2e>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d00140:	6008      	str	r0, [r1, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d00142:	48f2      	ldr	r0, [pc, #968]	; (c0d0050c <io_event+0x3ec>)
c0d00144:	2104      	movs	r1, #4
c0d00146:	a2f2      	add	r2, pc, #968	; (adr r2, c0d00510 <io_event+0x3f0>)
c0d00148:	2308      	movs	r3, #8
c0d0014a:	f001 fc9f 	bl	c0d01a8c <snprintf>

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
        case SEPROXYHAL_TAG_FINGER_EVENT:
            Timer_Restart();
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d0014e:	4cf1      	ldr	r4, [pc, #964]	; (c0d00514 <io_event+0x3f4>)
c0d00150:	2001      	movs	r0, #1
c0d00152:	7620      	strb	r0, [r4, #24]
c0d00154:	2600      	movs	r6, #0
c0d00156:	61e6      	str	r6, [r4, #28]
c0d00158:	4620      	mov	r0, r4
c0d0015a:	3018      	adds	r0, #24
c0d0015c:	f001 fff6 	bl	c0d0214c <os_ux>
c0d00160:	61e0      	str	r0, [r4, #28]
c0d00162:	f001 faec 	bl	c0d0173e <ux_check_status_default>
c0d00166:	69e0      	ldr	r0, [r4, #28]
c0d00168:	49eb      	ldr	r1, [pc, #940]	; (c0d00518 <io_event+0x3f8>)
c0d0016a:	4288      	cmp	r0, r1
c0d0016c:	d100      	bne.n	c0d00170 <io_event+0x50>
c0d0016e:	e276      	b.n	c0d0065e <io_event+0x53e>
c0d00170:	2800      	cmp	r0, #0
c0d00172:	d100      	bne.n	c0d00176 <io_event+0x56>
c0d00174:	e273      	b.n	c0d0065e <io_event+0x53e>
c0d00176:	49e9      	ldr	r1, [pc, #932]	; (c0d0051c <io_event+0x3fc>)
c0d00178:	4288      	cmp	r0, r1
c0d0017a:	d000      	beq.n	c0d0017e <io_event+0x5e>
c0d0017c:	e1d2      	b.n	c0d00524 <io_event+0x404>
c0d0017e:	f000 ffab 	bl	c0d010d8 <io_seproxyhal_init_ux>
c0d00182:	f000 ffaf 	bl	c0d010e4 <io_seproxyhal_init_button>
c0d00186:	60a6      	str	r6, [r4, #8]
c0d00188:	6820      	ldr	r0, [r4, #0]
c0d0018a:	2800      	cmp	r0, #0
c0d0018c:	d100      	bne.n	c0d00190 <io_event+0x70>
c0d0018e:	e266      	b.n	c0d0065e <io_event+0x53e>
c0d00190:	69e0      	ldr	r0, [r4, #28]
c0d00192:	49e1      	ldr	r1, [pc, #900]	; (c0d00518 <io_event+0x3f8>)
c0d00194:	4288      	cmp	r0, r1
c0d00196:	d000      	beq.n	c0d0019a <io_event+0x7a>
c0d00198:	e124      	b.n	c0d003e4 <io_event+0x2c4>
c0d0019a:	e260      	b.n	c0d0065e <io_event+0x53e>
c0d0019c:	290d      	cmp	r1, #13
c0d0019e:	d07a      	beq.n	c0d00296 <io_event+0x176>
c0d001a0:	290e      	cmp	r1, #14
c0d001a2:	d000      	beq.n	c0d001a6 <io_event+0x86>
c0d001a4:	e0bc      	b.n	c0d00320 <io_event+0x200>
        UX_REDISPLAY();
    }
}

static void Timer_Tick() {
    if (exit_timer > 0) {
c0d001a6:	4dd8      	ldr	r5, [pc, #864]	; (c0d00508 <io_event+0x3e8>)
c0d001a8:	6828      	ldr	r0, [r5, #0]
c0d001aa:	2801      	cmp	r0, #1
c0d001ac:	db0a      	blt.n	c0d001c4 <io_event+0xa4>
        exit_timer--;
c0d001ae:	1e40      	subs	r0, r0, #1
c0d001b0:	6028      	str	r0, [r5, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d001b2:	17c1      	asrs	r1, r0, #31
c0d001b4:	0dc9      	lsrs	r1, r1, #23
c0d001b6:	1840      	adds	r0, r0, r1
c0d001b8:	1243      	asrs	r3, r0, #9
c0d001ba:	48d4      	ldr	r0, [pc, #848]	; (c0d0050c <io_event+0x3ec>)
c0d001bc:	2104      	movs	r1, #4
c0d001be:	a2d4      	add	r2, pc, #848	; (adr r2, c0d00510 <io_event+0x3f0>)
c0d001c0:	f001 fc64 	bl	c0d01a8c <snprintf>
            }
        });
#else
//		UX_REDISPLAY();
            Timer_Tick();
            if (publicKeyNeedsRefresh == 1) {
c0d001c4:	4cd6      	ldr	r4, [pc, #856]	; (c0d00520 <io_event+0x400>)
c0d001c6:	7820      	ldrb	r0, [r4, #0]
c0d001c8:	2801      	cmp	r0, #1
c0d001ca:	d000      	beq.n	c0d001ce <io_event+0xae>
c0d001cc:	e130      	b.n	c0d00430 <io_event+0x310>
                UX_REDISPLAY();
c0d001ce:	f000 ff83 	bl	c0d010d8 <io_seproxyhal_init_ux>
c0d001d2:	f000 ff87 	bl	c0d010e4 <io_seproxyhal_init_button>
c0d001d6:	4dcf      	ldr	r5, [pc, #828]	; (c0d00514 <io_event+0x3f4>)
c0d001d8:	2000      	movs	r0, #0
c0d001da:	60a8      	str	r0, [r5, #8]
c0d001dc:	6829      	ldr	r1, [r5, #0]
c0d001de:	2900      	cmp	r1, #0
c0d001e0:	d024      	beq.n	c0d0022c <io_event+0x10c>
c0d001e2:	69e9      	ldr	r1, [r5, #28]
c0d001e4:	4acc      	ldr	r2, [pc, #816]	; (c0d00518 <io_event+0x3f8>)
c0d001e6:	4291      	cmp	r1, r2
c0d001e8:	d11e      	bne.n	c0d00228 <io_event+0x108>
c0d001ea:	e01f      	b.n	c0d0022c <io_event+0x10c>
c0d001ec:	6869      	ldr	r1, [r5, #4]
c0d001ee:	4288      	cmp	r0, r1
c0d001f0:	d21c      	bcs.n	c0d0022c <io_event+0x10c>
c0d001f2:	f002 f805 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d001f6:	2800      	cmp	r0, #0
c0d001f8:	d118      	bne.n	c0d0022c <io_event+0x10c>
c0d001fa:	68a8      	ldr	r0, [r5, #8]
c0d001fc:	68e9      	ldr	r1, [r5, #12]
c0d001fe:	2638      	movs	r6, #56	; 0x38
c0d00200:	4370      	muls	r0, r6
c0d00202:	682a      	ldr	r2, [r5, #0]
c0d00204:	1810      	adds	r0, r2, r0
c0d00206:	2900      	cmp	r1, #0
c0d00208:	d002      	beq.n	c0d00210 <io_event+0xf0>
c0d0020a:	4788      	blx	r1
c0d0020c:	2800      	cmp	r0, #0
c0d0020e:	d007      	beq.n	c0d00220 <io_event+0x100>
c0d00210:	2801      	cmp	r0, #1
c0d00212:	d103      	bne.n	c0d0021c <io_event+0xfc>
c0d00214:	68a8      	ldr	r0, [r5, #8]
c0d00216:	4346      	muls	r6, r0
c0d00218:	6828      	ldr	r0, [r5, #0]
c0d0021a:	1980      	adds	r0, r0, r6
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d0021c:	f001 f8b0 	bl	c0d01380 <io_seproxyhal_display_default>
        });
#else
//		UX_REDISPLAY();
            Timer_Tick();
            if (publicKeyNeedsRefresh == 1) {
                UX_REDISPLAY();
c0d00220:	68a8      	ldr	r0, [r5, #8]
c0d00222:	1c40      	adds	r0, r0, #1
c0d00224:	60a8      	str	r0, [r5, #8]
c0d00226:	6829      	ldr	r1, [r5, #0]
c0d00228:	2900      	cmp	r1, #0
c0d0022a:	d1df      	bne.n	c0d001ec <io_event+0xcc>
                publicKeyNeedsRefresh = 0;
c0d0022c:	2000      	movs	r0, #0
c0d0022e:	7020      	strb	r0, [r4, #0]
c0d00230:	e215      	b.n	c0d0065e <io_event+0x53e>
    exit_timer = MAX_EXIT_TIMER;
    Timer_UpdateDescription();
}

static void Timer_Restart() {
    if (exit_timer != MAX_EXIT_TIMER) {
c0d00232:	49b5      	ldr	r1, [pc, #724]	; (c0d00508 <io_event+0x3e8>)
c0d00234:	680a      	ldr	r2, [r1, #0]
c0d00236:	4282      	cmp	r2, r0
c0d00238:	d006      	beq.n	c0d00248 <io_event+0x128>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d0023a:	6008      	str	r0, [r1, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d0023c:	48b3      	ldr	r0, [pc, #716]	; (c0d0050c <io_event+0x3ec>)
c0d0023e:	2104      	movs	r1, #4
c0d00240:	a2b3      	add	r2, pc, #716	; (adr r2, c0d00510 <io_event+0x3f0>)
c0d00242:	2308      	movs	r3, #8
c0d00244:	f001 fc22 	bl	c0d01a8c <snprintf>
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
            break;

        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
            Timer_Restart();
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d00248:	4cb2      	ldr	r4, [pc, #712]	; (c0d00514 <io_event+0x3f4>)
c0d0024a:	2001      	movs	r0, #1
c0d0024c:	7620      	strb	r0, [r4, #24]
c0d0024e:	2600      	movs	r6, #0
c0d00250:	61e6      	str	r6, [r4, #28]
c0d00252:	4620      	mov	r0, r4
c0d00254:	3018      	adds	r0, #24
c0d00256:	f001 ff79 	bl	c0d0214c <os_ux>
c0d0025a:	61e0      	str	r0, [r4, #28]
c0d0025c:	f001 fa6f 	bl	c0d0173e <ux_check_status_default>
c0d00260:	69e0      	ldr	r0, [r4, #28]
c0d00262:	49ad      	ldr	r1, [pc, #692]	; (c0d00518 <io_event+0x3f8>)
c0d00264:	4288      	cmp	r0, r1
c0d00266:	d100      	bne.n	c0d0026a <io_event+0x14a>
c0d00268:	e1f9      	b.n	c0d0065e <io_event+0x53e>
c0d0026a:	2800      	cmp	r0, #0
c0d0026c:	d100      	bne.n	c0d00270 <io_event+0x150>
c0d0026e:	e1f6      	b.n	c0d0065e <io_event+0x53e>
c0d00270:	49aa      	ldr	r1, [pc, #680]	; (c0d0051c <io_event+0x3fc>)
c0d00272:	4288      	cmp	r0, r1
c0d00274:	d000      	beq.n	c0d00278 <io_event+0x158>
c0d00276:	e18f      	b.n	c0d00598 <io_event+0x478>
c0d00278:	f000 ff2e 	bl	c0d010d8 <io_seproxyhal_init_ux>
c0d0027c:	f000 ff32 	bl	c0d010e4 <io_seproxyhal_init_button>
c0d00280:	60a6      	str	r6, [r4, #8]
c0d00282:	6820      	ldr	r0, [r4, #0]
c0d00284:	2800      	cmp	r0, #0
c0d00286:	d100      	bne.n	c0d0028a <io_event+0x16a>
c0d00288:	e1e9      	b.n	c0d0065e <io_event+0x53e>
c0d0028a:	69e0      	ldr	r0, [r4, #28]
c0d0028c:	49f9      	ldr	r1, [pc, #996]	; (c0d00674 <io_event+0x554>)
c0d0028e:	4288      	cmp	r0, r1
c0d00290:	d000      	beq.n	c0d00294 <io_event+0x174>
c0d00292:	e0ca      	b.n	c0d0042a <io_event+0x30a>
c0d00294:	e1e3      	b.n	c0d0065e <io_event+0x53e>
            break;

        case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
            //Timer_Restart();
            if (UX_DISPLAYED()) {
c0d00296:	4cf6      	ldr	r4, [pc, #984]	; (c0d00670 <io_event+0x550>)
c0d00298:	6860      	ldr	r0, [r4, #4]
c0d0029a:	68a1      	ldr	r1, [r4, #8]
c0d0029c:	4281      	cmp	r1, r0
c0d0029e:	d300      	bcc.n	c0d002a2 <io_event+0x182>
c0d002a0:	e1dd      	b.n	c0d0065e <io_event+0x53e>
                // perform actions after all screen elements have been displayed
            } else {
                UX_DISPLAYED_EVENT();
c0d002a2:	2001      	movs	r0, #1
c0d002a4:	7620      	strb	r0, [r4, #24]
c0d002a6:	2500      	movs	r5, #0
c0d002a8:	61e5      	str	r5, [r4, #28]
c0d002aa:	4620      	mov	r0, r4
c0d002ac:	3018      	adds	r0, #24
c0d002ae:	f001 ff4d 	bl	c0d0214c <os_ux>
c0d002b2:	61e0      	str	r0, [r4, #28]
c0d002b4:	f001 fa43 	bl	c0d0173e <ux_check_status_default>
c0d002b8:	69e0      	ldr	r0, [r4, #28]
c0d002ba:	49ee      	ldr	r1, [pc, #952]	; (c0d00674 <io_event+0x554>)
c0d002bc:	4288      	cmp	r0, r1
c0d002be:	d100      	bne.n	c0d002c2 <io_event+0x1a2>
c0d002c0:	e1cd      	b.n	c0d0065e <io_event+0x53e>
c0d002c2:	49ed      	ldr	r1, [pc, #948]	; (c0d00678 <io_event+0x558>)
c0d002c4:	4288      	cmp	r0, r1
c0d002c6:	d100      	bne.n	c0d002ca <io_event+0x1aa>
c0d002c8:	e19c      	b.n	c0d00604 <io_event+0x4e4>
c0d002ca:	2800      	cmp	r0, #0
c0d002cc:	d100      	bne.n	c0d002d0 <io_event+0x1b0>
c0d002ce:	e1c6      	b.n	c0d0065e <io_event+0x53e>
c0d002d0:	6820      	ldr	r0, [r4, #0]
c0d002d2:	2800      	cmp	r0, #0
c0d002d4:	d100      	bne.n	c0d002d8 <io_event+0x1b8>
c0d002d6:	e18a      	b.n	c0d005ee <io_event+0x4ce>
c0d002d8:	68a0      	ldr	r0, [r4, #8]
c0d002da:	6861      	ldr	r1, [r4, #4]
c0d002dc:	4288      	cmp	r0, r1
c0d002de:	d300      	bcc.n	c0d002e2 <io_event+0x1c2>
c0d002e0:	e185      	b.n	c0d005ee <io_event+0x4ce>
c0d002e2:	f001 ff8d 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d002e6:	2800      	cmp	r0, #0
c0d002e8:	d000      	beq.n	c0d002ec <io_event+0x1cc>
c0d002ea:	e180      	b.n	c0d005ee <io_event+0x4ce>
c0d002ec:	68a0      	ldr	r0, [r4, #8]
c0d002ee:	68e1      	ldr	r1, [r4, #12]
c0d002f0:	2538      	movs	r5, #56	; 0x38
c0d002f2:	4368      	muls	r0, r5
c0d002f4:	6822      	ldr	r2, [r4, #0]
c0d002f6:	1810      	adds	r0, r2, r0
c0d002f8:	2900      	cmp	r1, #0
c0d002fa:	d002      	beq.n	c0d00302 <io_event+0x1e2>
c0d002fc:	4788      	blx	r1
c0d002fe:	2800      	cmp	r0, #0
c0d00300:	d007      	beq.n	c0d00312 <io_event+0x1f2>
c0d00302:	2801      	cmp	r0, #1
c0d00304:	d103      	bne.n	c0d0030e <io_event+0x1ee>
c0d00306:	68a0      	ldr	r0, [r4, #8]
c0d00308:	4345      	muls	r5, r0
c0d0030a:	6820      	ldr	r0, [r4, #0]
c0d0030c:	1940      	adds	r0, r0, r5
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d0030e:	f001 f837 	bl	c0d01380 <io_seproxyhal_display_default>
        case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
            //Timer_Restart();
            if (UX_DISPLAYED()) {
                // perform actions after all screen elements have been displayed
            } else {
                UX_DISPLAYED_EVENT();
c0d00312:	68a0      	ldr	r0, [r4, #8]
c0d00314:	1c40      	adds	r0, r0, #1
c0d00316:	60a0      	str	r0, [r4, #8]
c0d00318:	6821      	ldr	r1, [r4, #0]
c0d0031a:	2900      	cmp	r1, #0
c0d0031c:	d1dd      	bne.n	c0d002da <io_event+0x1ba>
c0d0031e:	e166      	b.n	c0d005ee <io_event+0x4ce>
#endif
            break;

            // unknown events are acknowledged
        default:
            UX_DEFAULT_EVENT();
c0d00320:	4cd3      	ldr	r4, [pc, #844]	; (c0d00670 <io_event+0x550>)
c0d00322:	2001      	movs	r0, #1
c0d00324:	7620      	strb	r0, [r4, #24]
c0d00326:	2500      	movs	r5, #0
c0d00328:	61e5      	str	r5, [r4, #28]
c0d0032a:	4620      	mov	r0, r4
c0d0032c:	3018      	adds	r0, #24
c0d0032e:	f001 ff0d 	bl	c0d0214c <os_ux>
c0d00332:	61e0      	str	r0, [r4, #28]
c0d00334:	f001 fa03 	bl	c0d0173e <ux_check_status_default>
c0d00338:	69e0      	ldr	r0, [r4, #28]
c0d0033a:	49cf      	ldr	r1, [pc, #828]	; (c0d00678 <io_event+0x558>)
c0d0033c:	4288      	cmp	r0, r1
c0d0033e:	d000      	beq.n	c0d00342 <io_event+0x222>
c0d00340:	e092      	b.n	c0d00468 <io_event+0x348>
c0d00342:	f000 fec9 	bl	c0d010d8 <io_seproxyhal_init_ux>
c0d00346:	f000 fecd 	bl	c0d010e4 <io_seproxyhal_init_button>
c0d0034a:	60a5      	str	r5, [r4, #8]
c0d0034c:	6820      	ldr	r0, [r4, #0]
c0d0034e:	2800      	cmp	r0, #0
c0d00350:	d100      	bne.n	c0d00354 <io_event+0x234>
c0d00352:	e184      	b.n	c0d0065e <io_event+0x53e>
c0d00354:	69e0      	ldr	r0, [r4, #28]
c0d00356:	49c7      	ldr	r1, [pc, #796]	; (c0d00674 <io_event+0x554>)
c0d00358:	4288      	cmp	r0, r1
c0d0035a:	d120      	bne.n	c0d0039e <io_event+0x27e>
c0d0035c:	e17f      	b.n	c0d0065e <io_event+0x53e>
c0d0035e:	6860      	ldr	r0, [r4, #4]
c0d00360:	4285      	cmp	r5, r0
c0d00362:	d300      	bcc.n	c0d00366 <io_event+0x246>
c0d00364:	e17b      	b.n	c0d0065e <io_event+0x53e>
c0d00366:	f001 ff4b 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d0036a:	2800      	cmp	r0, #0
c0d0036c:	d000      	beq.n	c0d00370 <io_event+0x250>
c0d0036e:	e176      	b.n	c0d0065e <io_event+0x53e>
c0d00370:	68a0      	ldr	r0, [r4, #8]
c0d00372:	68e1      	ldr	r1, [r4, #12]
c0d00374:	2538      	movs	r5, #56	; 0x38
c0d00376:	4368      	muls	r0, r5
c0d00378:	6822      	ldr	r2, [r4, #0]
c0d0037a:	1810      	adds	r0, r2, r0
c0d0037c:	2900      	cmp	r1, #0
c0d0037e:	d002      	beq.n	c0d00386 <io_event+0x266>
c0d00380:	4788      	blx	r1
c0d00382:	2800      	cmp	r0, #0
c0d00384:	d007      	beq.n	c0d00396 <io_event+0x276>
c0d00386:	2801      	cmp	r0, #1
c0d00388:	d103      	bne.n	c0d00392 <io_event+0x272>
c0d0038a:	68a0      	ldr	r0, [r4, #8]
c0d0038c:	4345      	muls	r5, r0
c0d0038e:	6820      	ldr	r0, [r4, #0]
c0d00390:	1940      	adds	r0, r0, r5
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d00392:	f000 fff5 	bl	c0d01380 <io_seproxyhal_display_default>
#endif
            break;

            // unknown events are acknowledged
        default:
            UX_DEFAULT_EVENT();
c0d00396:	68a0      	ldr	r0, [r4, #8]
c0d00398:	1c45      	adds	r5, r0, #1
c0d0039a:	60a5      	str	r5, [r4, #8]
c0d0039c:	6820      	ldr	r0, [r4, #0]
c0d0039e:	2800      	cmp	r0, #0
c0d003a0:	d1dd      	bne.n	c0d0035e <io_event+0x23e>
c0d003a2:	e15c      	b.n	c0d0065e <io_event+0x53e>

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
        case SEPROXYHAL_TAG_FINGER_EVENT:
            Timer_Restart();
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d003a4:	6860      	ldr	r0, [r4, #4]
c0d003a6:	4286      	cmp	r6, r0
c0d003a8:	d300      	bcc.n	c0d003ac <io_event+0x28c>
c0d003aa:	e158      	b.n	c0d0065e <io_event+0x53e>
c0d003ac:	f001 ff28 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d003b0:	2800      	cmp	r0, #0
c0d003b2:	d000      	beq.n	c0d003b6 <io_event+0x296>
c0d003b4:	e153      	b.n	c0d0065e <io_event+0x53e>
c0d003b6:	68a0      	ldr	r0, [r4, #8]
c0d003b8:	68e1      	ldr	r1, [r4, #12]
c0d003ba:	2538      	movs	r5, #56	; 0x38
c0d003bc:	4368      	muls	r0, r5
c0d003be:	6822      	ldr	r2, [r4, #0]
c0d003c0:	1810      	adds	r0, r2, r0
c0d003c2:	2900      	cmp	r1, #0
c0d003c4:	d002      	beq.n	c0d003cc <io_event+0x2ac>
c0d003c6:	4788      	blx	r1
c0d003c8:	2800      	cmp	r0, #0
c0d003ca:	d007      	beq.n	c0d003dc <io_event+0x2bc>
c0d003cc:	2801      	cmp	r0, #1
c0d003ce:	d103      	bne.n	c0d003d8 <io_event+0x2b8>
c0d003d0:	68a0      	ldr	r0, [r4, #8]
c0d003d2:	4345      	muls	r5, r0
c0d003d4:	6820      	ldr	r0, [r4, #0]
c0d003d6:	1940      	adds	r0, r0, r5
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d003d8:	f000 ffd2 	bl	c0d01380 <io_seproxyhal_display_default>

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
        case SEPROXYHAL_TAG_FINGER_EVENT:
            Timer_Restart();
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d003dc:	68a0      	ldr	r0, [r4, #8]
c0d003de:	1c46      	adds	r6, r0, #1
c0d003e0:	60a6      	str	r6, [r4, #8]
c0d003e2:	6820      	ldr	r0, [r4, #0]
c0d003e4:	2800      	cmp	r0, #0
c0d003e6:	d1dd      	bne.n	c0d003a4 <io_event+0x284>
c0d003e8:	e139      	b.n	c0d0065e <io_event+0x53e>
            break;

        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
            Timer_Restart();
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d003ea:	6860      	ldr	r0, [r4, #4]
c0d003ec:	4286      	cmp	r6, r0
c0d003ee:	d300      	bcc.n	c0d003f2 <io_event+0x2d2>
c0d003f0:	e135      	b.n	c0d0065e <io_event+0x53e>
c0d003f2:	f001 ff05 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d003f6:	2800      	cmp	r0, #0
c0d003f8:	d000      	beq.n	c0d003fc <io_event+0x2dc>
c0d003fa:	e130      	b.n	c0d0065e <io_event+0x53e>
c0d003fc:	68a0      	ldr	r0, [r4, #8]
c0d003fe:	68e1      	ldr	r1, [r4, #12]
c0d00400:	2538      	movs	r5, #56	; 0x38
c0d00402:	4368      	muls	r0, r5
c0d00404:	6822      	ldr	r2, [r4, #0]
c0d00406:	1810      	adds	r0, r2, r0
c0d00408:	2900      	cmp	r1, #0
c0d0040a:	d002      	beq.n	c0d00412 <io_event+0x2f2>
c0d0040c:	4788      	blx	r1
c0d0040e:	2800      	cmp	r0, #0
c0d00410:	d007      	beq.n	c0d00422 <io_event+0x302>
c0d00412:	2801      	cmp	r0, #1
c0d00414:	d103      	bne.n	c0d0041e <io_event+0x2fe>
c0d00416:	68a0      	ldr	r0, [r4, #8]
c0d00418:	4345      	muls	r5, r0
c0d0041a:	6820      	ldr	r0, [r4, #0]
c0d0041c:	1940      	adds	r0, r0, r5
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d0041e:	f000 ffaf 	bl	c0d01380 <io_seproxyhal_display_default>
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
            break;

        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
            Timer_Restart();
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d00422:	68a0      	ldr	r0, [r4, #8]
c0d00424:	1c46      	adds	r6, r0, #1
c0d00426:	60a6      	str	r6, [r4, #8]
c0d00428:	6820      	ldr	r0, [r4, #0]
c0d0042a:	2800      	cmp	r0, #0
c0d0042c:	d1dd      	bne.n	c0d003ea <io_event+0x2ca>
c0d0042e:	e116      	b.n	c0d0065e <io_event+0x53e>
        Timer_Set();
    }
}

static bool Timer_Expired() {
    return exit_timer <= 0;
c0d00430:	6828      	ldr	r0, [r5, #0]
            Timer_Tick();
            if (publicKeyNeedsRefresh == 1) {
                UX_REDISPLAY();
                publicKeyNeedsRefresh = 0;
            } else {
                if (Timer_Expired()) {
c0d00432:	2800      	cmp	r0, #0
c0d00434:	dc00      	bgt.n	c0d00438 <io_event+0x318>
c0d00436:	e0e1      	b.n	c0d005fc <io_event+0x4dc>
c0d00438:	2101      	movs	r1, #1
c0d0043a:	0209      	lsls	r1, r1, #8
c0d0043c:	460a      	mov	r2, r1
c0d0043e:	32ff      	adds	r2, #255	; 0xff
c0d00440:	4010      	ands	r0, r2
static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
}

static void Timer_UpdateDisplay() {
    if ((exit_timer % EXIT_TIMER_REFRESH_INTERVAL) == (EXIT_TIMER_REFRESH_INTERVAL / 2)) {
c0d00442:	4288      	cmp	r0, r1
c0d00444:	d000      	beq.n	c0d00448 <io_event+0x328>
c0d00446:	e10a      	b.n	c0d0065e <io_event+0x53e>
        UX_REDISPLAY();
c0d00448:	f000 fe46 	bl	c0d010d8 <io_seproxyhal_init_ux>
c0d0044c:	f000 fe4a 	bl	c0d010e4 <io_seproxyhal_init_button>
c0d00450:	4c87      	ldr	r4, [pc, #540]	; (c0d00670 <io_event+0x550>)
c0d00452:	2000      	movs	r0, #0
c0d00454:	60a0      	str	r0, [r4, #8]
c0d00456:	6821      	ldr	r1, [r4, #0]
c0d00458:	2900      	cmp	r1, #0
c0d0045a:	d100      	bne.n	c0d0045e <io_event+0x33e>
c0d0045c:	e0ff      	b.n	c0d0065e <io_event+0x53e>
c0d0045e:	69e1      	ldr	r1, [r4, #28]
c0d00460:	4a84      	ldr	r2, [pc, #528]	; (c0d00674 <io_event+0x554>)
c0d00462:	4291      	cmp	r1, r2
c0d00464:	d148      	bne.n	c0d004f8 <io_event+0x3d8>
c0d00466:	e0fa      	b.n	c0d0065e <io_event+0x53e>
#endif
            break;

            // unknown events are acknowledged
        default:
            UX_DEFAULT_EVENT();
c0d00468:	6820      	ldr	r0, [r4, #0]
c0d0046a:	2800      	cmp	r0, #0
c0d0046c:	d100      	bne.n	c0d00470 <io_event+0x350>
c0d0046e:	e0be      	b.n	c0d005ee <io_event+0x4ce>
c0d00470:	68a0      	ldr	r0, [r4, #8]
c0d00472:	6861      	ldr	r1, [r4, #4]
c0d00474:	4288      	cmp	r0, r1
c0d00476:	d300      	bcc.n	c0d0047a <io_event+0x35a>
c0d00478:	e0b9      	b.n	c0d005ee <io_event+0x4ce>
c0d0047a:	f001 fec1 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d0047e:	2800      	cmp	r0, #0
c0d00480:	d000      	beq.n	c0d00484 <io_event+0x364>
c0d00482:	e0b4      	b.n	c0d005ee <io_event+0x4ce>
c0d00484:	68a0      	ldr	r0, [r4, #8]
c0d00486:	68e1      	ldr	r1, [r4, #12]
c0d00488:	2538      	movs	r5, #56	; 0x38
c0d0048a:	4368      	muls	r0, r5
c0d0048c:	6822      	ldr	r2, [r4, #0]
c0d0048e:	1810      	adds	r0, r2, r0
c0d00490:	2900      	cmp	r1, #0
c0d00492:	d002      	beq.n	c0d0049a <io_event+0x37a>
c0d00494:	4788      	blx	r1
c0d00496:	2800      	cmp	r0, #0
c0d00498:	d007      	beq.n	c0d004aa <io_event+0x38a>
c0d0049a:	2801      	cmp	r0, #1
c0d0049c:	d103      	bne.n	c0d004a6 <io_event+0x386>
c0d0049e:	68a0      	ldr	r0, [r4, #8]
c0d004a0:	4345      	muls	r5, r0
c0d004a2:	6820      	ldr	r0, [r4, #0]
c0d004a4:	1940      	adds	r0, r0, r5
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d004a6:	f000 ff6b 	bl	c0d01380 <io_seproxyhal_display_default>
#endif
            break;

            // unknown events are acknowledged
        default:
            UX_DEFAULT_EVENT();
c0d004aa:	68a0      	ldr	r0, [r4, #8]
c0d004ac:	1c40      	adds	r0, r0, #1
c0d004ae:	60a0      	str	r0, [r4, #8]
c0d004b0:	6821      	ldr	r1, [r4, #0]
c0d004b2:	2900      	cmp	r1, #0
c0d004b4:	d1dd      	bne.n	c0d00472 <io_event+0x352>
c0d004b6:	e09a      	b.n	c0d005ee <io_event+0x4ce>
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
}

static void Timer_UpdateDisplay() {
    if ((exit_timer % EXIT_TIMER_REFRESH_INTERVAL) == (EXIT_TIMER_REFRESH_INTERVAL / 2)) {
        UX_REDISPLAY();
c0d004b8:	6861      	ldr	r1, [r4, #4]
c0d004ba:	4288      	cmp	r0, r1
c0d004bc:	d300      	bcc.n	c0d004c0 <io_event+0x3a0>
c0d004be:	e0ce      	b.n	c0d0065e <io_event+0x53e>
c0d004c0:	f001 fe9e 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d004c4:	2800      	cmp	r0, #0
c0d004c6:	d000      	beq.n	c0d004ca <io_event+0x3aa>
c0d004c8:	e0c9      	b.n	c0d0065e <io_event+0x53e>
c0d004ca:	68a0      	ldr	r0, [r4, #8]
c0d004cc:	68e1      	ldr	r1, [r4, #12]
c0d004ce:	2538      	movs	r5, #56	; 0x38
c0d004d0:	4368      	muls	r0, r5
c0d004d2:	6822      	ldr	r2, [r4, #0]
c0d004d4:	1810      	adds	r0, r2, r0
c0d004d6:	2900      	cmp	r1, #0
c0d004d8:	d002      	beq.n	c0d004e0 <io_event+0x3c0>
c0d004da:	4788      	blx	r1
c0d004dc:	2800      	cmp	r0, #0
c0d004de:	d007      	beq.n	c0d004f0 <io_event+0x3d0>
c0d004e0:	2801      	cmp	r0, #1
c0d004e2:	d103      	bne.n	c0d004ec <io_event+0x3cc>
c0d004e4:	68a0      	ldr	r0, [r4, #8]
c0d004e6:	4345      	muls	r5, r0
c0d004e8:	6820      	ldr	r0, [r4, #0]
c0d004ea:	1940      	adds	r0, r0, r5
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d004ec:	f000 ff48 	bl	c0d01380 <io_seproxyhal_display_default>
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
}

static void Timer_UpdateDisplay() {
    if ((exit_timer % EXIT_TIMER_REFRESH_INTERVAL) == (EXIT_TIMER_REFRESH_INTERVAL / 2)) {
        UX_REDISPLAY();
c0d004f0:	68a0      	ldr	r0, [r4, #8]
c0d004f2:	1c40      	adds	r0, r0, #1
c0d004f4:	60a0      	str	r0, [r4, #8]
c0d004f6:	6821      	ldr	r1, [r4, #0]
c0d004f8:	2900      	cmp	r1, #0
c0d004fa:	d1dd      	bne.n	c0d004b8 <io_event+0x398>
c0d004fc:	e0af      	b.n	c0d0065e <io_event+0x53e>
c0d004fe:	46c0      	nop			; (mov r8, r8)
c0d00500:	20001800 	.word	0x20001800
c0d00504:	00001002 	.word	0x00001002
c0d00508:	20001c38 	.word	0x20001c38
c0d0050c:	20001c3c 	.word	0x20001c3c
c0d00510:	00006425 	.word	0x00006425
c0d00514:	20001b88 	.word	0x20001b88
c0d00518:	b0105044 	.word	0xb0105044
c0d0051c:	b0105055 	.word	0xb0105055
c0d00520:	20001c40 	.word	0x20001c40

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
        case SEPROXYHAL_TAG_FINGER_EVENT:
            Timer_Restart();
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d00524:	88a0      	ldrh	r0, [r4, #4]
c0d00526:	9004      	str	r0, [sp, #16]
c0d00528:	6820      	ldr	r0, [r4, #0]
c0d0052a:	9003      	str	r0, [sp, #12]
c0d0052c:	79ee      	ldrb	r6, [r5, #7]
c0d0052e:	79ab      	ldrb	r3, [r5, #6]
c0d00530:	796f      	ldrb	r7, [r5, #5]
c0d00532:	792a      	ldrb	r2, [r5, #4]
c0d00534:	78ed      	ldrb	r5, [r5, #3]
c0d00536:	68e1      	ldr	r1, [r4, #12]
c0d00538:	4668      	mov	r0, sp
c0d0053a:	6005      	str	r5, [r0, #0]
c0d0053c:	6041      	str	r1, [r0, #4]
c0d0053e:	0212      	lsls	r2, r2, #8
c0d00540:	433a      	orrs	r2, r7
c0d00542:	021b      	lsls	r3, r3, #8
c0d00544:	4333      	orrs	r3, r6
c0d00546:	9803      	ldr	r0, [sp, #12]
c0d00548:	9904      	ldr	r1, [sp, #16]
c0d0054a:	f000 fe4b 	bl	c0d011e4 <io_seproxyhal_touch_element_callback>
c0d0054e:	6820      	ldr	r0, [r4, #0]
c0d00550:	2800      	cmp	r0, #0
c0d00552:	d04c      	beq.n	c0d005ee <io_event+0x4ce>
c0d00554:	68a0      	ldr	r0, [r4, #8]
c0d00556:	6861      	ldr	r1, [r4, #4]
c0d00558:	4288      	cmp	r0, r1
c0d0055a:	d248      	bcs.n	c0d005ee <io_event+0x4ce>
c0d0055c:	f001 fe50 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d00560:	2800      	cmp	r0, #0
c0d00562:	d144      	bne.n	c0d005ee <io_event+0x4ce>
c0d00564:	68a0      	ldr	r0, [r4, #8]
c0d00566:	68e1      	ldr	r1, [r4, #12]
c0d00568:	2538      	movs	r5, #56	; 0x38
c0d0056a:	4368      	muls	r0, r5
c0d0056c:	6822      	ldr	r2, [r4, #0]
c0d0056e:	1810      	adds	r0, r2, r0
c0d00570:	2900      	cmp	r1, #0
c0d00572:	d002      	beq.n	c0d0057a <io_event+0x45a>
c0d00574:	4788      	blx	r1
c0d00576:	2800      	cmp	r0, #0
c0d00578:	d007      	beq.n	c0d0058a <io_event+0x46a>
c0d0057a:	2801      	cmp	r0, #1
c0d0057c:	d103      	bne.n	c0d00586 <io_event+0x466>
c0d0057e:	68a0      	ldr	r0, [r4, #8]
c0d00580:	4345      	muls	r5, r0
c0d00582:	6820      	ldr	r0, [r4, #0]
c0d00584:	1940      	adds	r0, r0, r5
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d00586:	f000 fefb 	bl	c0d01380 <io_seproxyhal_display_default>

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
        case SEPROXYHAL_TAG_FINGER_EVENT:
            Timer_Restart();
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d0058a:	68a0      	ldr	r0, [r4, #8]
c0d0058c:	1c40      	adds	r0, r0, #1
c0d0058e:	60a0      	str	r0, [r4, #8]
c0d00590:	6821      	ldr	r1, [r4, #0]
c0d00592:	2900      	cmp	r1, #0
c0d00594:	d1df      	bne.n	c0d00556 <io_event+0x436>
c0d00596:	e02a      	b.n	c0d005ee <io_event+0x4ce>
            break;

        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
            Timer_Restart();
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d00598:	6920      	ldr	r0, [r4, #16]
c0d0059a:	2800      	cmp	r0, #0
c0d0059c:	d003      	beq.n	c0d005a6 <io_event+0x486>
c0d0059e:	78e9      	ldrb	r1, [r5, #3]
c0d005a0:	0849      	lsrs	r1, r1, #1
c0d005a2:	f000 ff2f 	bl	c0d01404 <io_seproxyhal_button_push>
c0d005a6:	6820      	ldr	r0, [r4, #0]
c0d005a8:	2800      	cmp	r0, #0
c0d005aa:	d020      	beq.n	c0d005ee <io_event+0x4ce>
c0d005ac:	68a0      	ldr	r0, [r4, #8]
c0d005ae:	6861      	ldr	r1, [r4, #4]
c0d005b0:	4288      	cmp	r0, r1
c0d005b2:	d21c      	bcs.n	c0d005ee <io_event+0x4ce>
c0d005b4:	f001 fe24 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d005b8:	2800      	cmp	r0, #0
c0d005ba:	d118      	bne.n	c0d005ee <io_event+0x4ce>
c0d005bc:	68a0      	ldr	r0, [r4, #8]
c0d005be:	68e1      	ldr	r1, [r4, #12]
c0d005c0:	2538      	movs	r5, #56	; 0x38
c0d005c2:	4368      	muls	r0, r5
c0d005c4:	6822      	ldr	r2, [r4, #0]
c0d005c6:	1810      	adds	r0, r2, r0
c0d005c8:	2900      	cmp	r1, #0
c0d005ca:	d002      	beq.n	c0d005d2 <io_event+0x4b2>
c0d005cc:	4788      	blx	r1
c0d005ce:	2800      	cmp	r0, #0
c0d005d0:	d007      	beq.n	c0d005e2 <io_event+0x4c2>
c0d005d2:	2801      	cmp	r0, #1
c0d005d4:	d103      	bne.n	c0d005de <io_event+0x4be>
c0d005d6:	68a0      	ldr	r0, [r4, #8]
c0d005d8:	4345      	muls	r5, r0
c0d005da:	6820      	ldr	r0, [r4, #0]
c0d005dc:	1940      	adds	r0, r0, r5
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d005de:	f000 fecf 	bl	c0d01380 <io_seproxyhal_display_default>
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
            break;

        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
            Timer_Restart();
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d005e2:	68a0      	ldr	r0, [r4, #8]
c0d005e4:	1c40      	adds	r0, r0, #1
c0d005e6:	60a0      	str	r0, [r4, #8]
c0d005e8:	6821      	ldr	r1, [r4, #0]
c0d005ea:	2900      	cmp	r1, #0
c0d005ec:	d1df      	bne.n	c0d005ae <io_event+0x48e>
c0d005ee:	6860      	ldr	r0, [r4, #4]
c0d005f0:	68a1      	ldr	r1, [r4, #8]
c0d005f2:	4281      	cmp	r1, r0
c0d005f4:	d333      	bcc.n	c0d0065e <io_event+0x53e>
c0d005f6:	f001 fe03 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d005fa:	e030      	b.n	c0d0065e <io_event+0x53e>
            if (publicKeyNeedsRefresh == 1) {
                UX_REDISPLAY();
                publicKeyNeedsRefresh = 0;
            } else {
                if (Timer_Expired()) {
                    os_sched_exit(0);
c0d005fc:	2000      	movs	r0, #0
c0d005fe:	f001 fd8f 	bl	c0d02120 <os_sched_exit>
c0d00602:	e02c      	b.n	c0d0065e <io_event+0x53e>
        case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
            //Timer_Restart();
            if (UX_DISPLAYED()) {
                // perform actions after all screen elements have been displayed
            } else {
                UX_DISPLAYED_EVENT();
c0d00604:	f000 fd68 	bl	c0d010d8 <io_seproxyhal_init_ux>
c0d00608:	f000 fd6c 	bl	c0d010e4 <io_seproxyhal_init_button>
c0d0060c:	60a5      	str	r5, [r4, #8]
c0d0060e:	6820      	ldr	r0, [r4, #0]
c0d00610:	2800      	cmp	r0, #0
c0d00612:	d024      	beq.n	c0d0065e <io_event+0x53e>
c0d00614:	69e0      	ldr	r0, [r4, #28]
c0d00616:	4917      	ldr	r1, [pc, #92]	; (c0d00674 <io_event+0x554>)
c0d00618:	4288      	cmp	r0, r1
c0d0061a:	d11e      	bne.n	c0d0065a <io_event+0x53a>
c0d0061c:	e01f      	b.n	c0d0065e <io_event+0x53e>
c0d0061e:	6860      	ldr	r0, [r4, #4]
c0d00620:	4285      	cmp	r5, r0
c0d00622:	d21c      	bcs.n	c0d0065e <io_event+0x53e>
c0d00624:	f001 fdec 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d00628:	2800      	cmp	r0, #0
c0d0062a:	d118      	bne.n	c0d0065e <io_event+0x53e>
c0d0062c:	68a0      	ldr	r0, [r4, #8]
c0d0062e:	68e1      	ldr	r1, [r4, #12]
c0d00630:	2538      	movs	r5, #56	; 0x38
c0d00632:	4368      	muls	r0, r5
c0d00634:	6822      	ldr	r2, [r4, #0]
c0d00636:	1810      	adds	r0, r2, r0
c0d00638:	2900      	cmp	r1, #0
c0d0063a:	d002      	beq.n	c0d00642 <io_event+0x522>
c0d0063c:	4788      	blx	r1
c0d0063e:	2800      	cmp	r0, #0
c0d00640:	d007      	beq.n	c0d00652 <io_event+0x532>
c0d00642:	2801      	cmp	r0, #1
c0d00644:	d103      	bne.n	c0d0064e <io_event+0x52e>
c0d00646:	68a0      	ldr	r0, [r4, #8]
c0d00648:	4345      	muls	r5, r0
c0d0064a:	6820      	ldr	r0, [r4, #0]
c0d0064c:	1940      	adds	r0, r0, r5
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d0064e:	f000 fe97 	bl	c0d01380 <io_seproxyhal_display_default>
        case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
            //Timer_Restart();
            if (UX_DISPLAYED()) {
                // perform actions after all screen elements have been displayed
            } else {
                UX_DISPLAYED_EVENT();
c0d00652:	68a0      	ldr	r0, [r4, #8]
c0d00654:	1c45      	adds	r5, r0, #1
c0d00656:	60a5      	str	r5, [r4, #8]
c0d00658:	6820      	ldr	r0, [r4, #0]
c0d0065a:	2800      	cmp	r0, #0
c0d0065c:	d1df      	bne.n	c0d0061e <io_event+0x4fe>
            UX_DEFAULT_EVENT();
            break;
    }

    // close the event if not done previously (by a display or whatever)
    if (!io_seproxyhal_spi_is_status_sent()) {
c0d0065e:	f001 fdcf 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d00662:	2800      	cmp	r0, #0
c0d00664:	d101      	bne.n	c0d0066a <io_event+0x54a>
        io_seproxyhal_general_status();
c0d00666:	f000 fbe7 	bl	c0d00e38 <io_seproxyhal_general_status>
    }

    // command has been processed, DO NOT reset the current APDU transport
    return 1;
c0d0066a:	2001      	movs	r0, #1
c0d0066c:	b005      	add	sp, #20
c0d0066e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00670:	20001b88 	.word	0x20001b88
c0d00674:	b0105044 	.word	0xb0105044
c0d00678:	b0105055 	.word	0xb0105055

c0d0067c <bottos_main>:
        publicKeyNeedsRefresh = 1;
    }
}

/** main loop. */
static void bottos_main(void) {
c0d0067c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0067e:	b0bb      	sub	sp, #236	; 0xec
c0d00680:	2600      	movs	r6, #0
    volatile unsigned int rx = 0;
c0d00682:	963a      	str	r6, [sp, #232]	; 0xe8
    volatile unsigned int tx = 0;
c0d00684:	9639      	str	r6, [sp, #228]	; 0xe4
    volatile unsigned int flags = 0;
c0d00686:	9638      	str	r6, [sp, #224]	; 0xe0
c0d00688:	4c8b      	ldr	r4, [pc, #556]	; (c0d008b8 <bottos_main+0x23c>)
c0d0068a:	4d92      	ldr	r5, [pc, #584]	; (c0d008d4 <bottos_main+0x258>)
c0d0068c:	a837      	add	r0, sp, #220	; 0xdc
    // When APDU are to be fetched from multiple IOs, like NFC+USB+BLE, make
    // sure the io_event is called with a
    // switch event, before the apdu is replied to the bootloader. This avoid
    // APDU injection faults.
    for (;;) {
        volatile unsigned short sw = 0;
c0d0068e:	8006      	strh	r6, [r0, #0]
c0d00690:	af2c      	add	r7, sp, #176	; 0xb0

        BEGIN_TRY
        {
            TRY
c0d00692:	4638      	mov	r0, r7
c0d00694:	f003 fe1a 	bl	c0d042cc <setjmp>
c0d00698:	8538      	strh	r0, [r7, #40]	; 0x28
c0d0069a:	4985      	ldr	r1, [pc, #532]	; (c0d008b0 <bottos_main+0x234>)
c0d0069c:	4208      	tst	r0, r1
c0d0069e:	d00f      	beq.n	c0d006c0 <bottos_main+0x44>
c0d006a0:	a92c      	add	r1, sp, #176	; 0xb0
                        hashTainted = 1;
                        THROW(0x6D00);
                        break;
                }
            }
            CATCH_OTHER(e)
c0d006a2:	850e      	strh	r6, [r1, #40]	; 0x28
c0d006a4:	210f      	movs	r1, #15
c0d006a6:	0309      	lsls	r1, r1, #12
            {
                switch (e & 0xF000) {
c0d006a8:	4001      	ands	r1, r0
c0d006aa:	2209      	movs	r2, #9
c0d006ac:	0312      	lsls	r2, r2, #12
c0d006ae:	4291      	cmp	r1, r2
c0d006b0:	d003      	beq.n	c0d006ba <bottos_main+0x3e>
c0d006b2:	2203      	movs	r2, #3
c0d006b4:	0352      	lsls	r2, r2, #13
c0d006b6:	4291      	cmp	r1, r2
c0d006b8:	d151      	bne.n	c0d0075e <bottos_main+0xe2>
c0d006ba:	a937      	add	r1, sp, #220	; 0xdc
                    case 0x6000:
                    case 0x9000:
                        sw = e;
c0d006bc:	8008      	strh	r0, [r1, #0]
c0d006be:	e055      	b.n	c0d0076c <bottos_main+0xf0>
c0d006c0:	462f      	mov	r7, r5
c0d006c2:	a82c      	add	r0, sp, #176	; 0xb0
    for (;;) {
        volatile unsigned short sw = 0;

        BEGIN_TRY
        {
            TRY
c0d006c4:	f000 fa43 	bl	c0d00b4e <try_context_set>
            {
                rx = tx;
c0d006c8:	9839      	ldr	r0, [sp, #228]	; 0xe4
c0d006ca:	903a      	str	r0, [sp, #232]	; 0xe8
c0d006cc:	2500      	movs	r5, #0
                // ensure no race in catch_other if io_exchange throws an error
                tx = 0;
c0d006ce:	9539      	str	r5, [sp, #228]	; 0xe4
                rx = io_exchange(CHANNEL_APDU | flags, rx);
c0d006d0:	9838      	ldr	r0, [sp, #224]	; 0xe0
c0d006d2:	993a      	ldr	r1, [sp, #232]	; 0xe8
c0d006d4:	b2c0      	uxtb	r0, r0
c0d006d6:	b289      	uxth	r1, r1
c0d006d8:	f000 fef2 	bl	c0d014c0 <io_exchange>
c0d006dc:	903a      	str	r0, [sp, #232]	; 0xe8
                flags = 0;
c0d006de:	9538      	str	r5, [sp, #224]	; 0xe0

                PRINTF("APDU received:\n%.*H\n",100, G_io_apdu_buffer);
c0d006e0:	2164      	movs	r1, #100	; 0x64
c0d006e2:	a076      	add	r0, pc, #472	; (adr r0, c0d008bc <bottos_main+0x240>)
c0d006e4:	4622      	mov	r2, r4
c0d006e6:	f001 f82b 	bl	c0d01740 <screen_printf>

                // no apdu received, well, reset the session, and reset the
                // bootloader configuration
                if (rx == 0) {
c0d006ea:	983a      	ldr	r0, [sp, #232]	; 0xe8
c0d006ec:	2800      	cmp	r0, #0
c0d006ee:	d100      	bne.n	c0d006f2 <bottos_main+0x76>
c0d006f0:	e0bd      	b.n	c0d0086e <bottos_main+0x1f2>
                    // 安全条件不满足
                    THROW(0x6982);
                }

                // if the buffer doesn't start with the magic byte, return an error.
                if (G_io_apdu_buffer[0] != CLA) {
c0d006f2:	7820      	ldrb	r0, [r4, #0]
c0d006f4:	28ea      	cmp	r0, #234	; 0xea
c0d006f6:	d000      	beq.n	c0d006fa <bottos_main+0x7e>
c0d006f8:	e0be      	b.n	c0d00878 <bottos_main+0x1fc>
c0d006fa:	7861      	ldrb	r1, [r4, #1]
c0d006fc:	206d      	movs	r0, #109	; 0x6d
c0d006fe:	0203      	lsls	r3, r0, #8
c0d00700:	4875      	ldr	r0, [pc, #468]	; (c0d008d8 <bottos_main+0x25c>)
                    // CLA 不支持
                    THROW(0x6E00);
                }

                // check the second byte (0x01) for the instruction.
                switch (G_io_apdu_buffer[1]) {
c0d00702:	2905      	cmp	r1, #5
c0d00704:	dc3e      	bgt.n	c0d00784 <bottos_main+0x108>
c0d00706:	2901      	cmp	r1, #1
c0d00708:	d059      	beq.n	c0d007be <bottos_main+0x142>
c0d0070a:	2902      	cmp	r1, #2
c0d0070c:	d000      	beq.n	c0d00710 <bottos_main+0x94>
c0d0070e:	e0b9      	b.n	c0d00884 <bottos_main+0x208>
    exit_timer = MAX_EXIT_TIMER;
    Timer_UpdateDescription();
}

static void Timer_Restart() {
    if (exit_timer != MAX_EXIT_TIMER) {
c0d00710:	4972      	ldr	r1, [pc, #456]	; (c0d008dc <bottos_main+0x260>)
c0d00712:	6809      	ldr	r1, [r1, #0]
c0d00714:	4281      	cmp	r1, r0
c0d00716:	d007      	beq.n	c0d00728 <bottos_main+0xac>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d00718:	4970      	ldr	r1, [pc, #448]	; (c0d008dc <bottos_main+0x260>)
c0d0071a:	6008      	str	r0, [r1, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d0071c:	2104      	movs	r1, #4
c0d0071e:	2308      	movs	r3, #8
c0d00720:	486f      	ldr	r0, [pc, #444]	; (c0d008e0 <bottos_main+0x264>)
c0d00722:	a270      	add	r2, pc, #448	; (adr r2, c0d008e4 <bottos_main+0x268>)
c0d00724:	f001 f9b2 	bl	c0d01a8c <snprintf>

                    // we're getting a transaction to sign, in parts.
                    case INS_SIGN_HASH: {
                        Timer_Restart();
                        // 检查P1是否为0x01
                        if ((G_io_apdu_buffer[2] != P1_CONFIRM)) {
c0d00728:	78a0      	ldrb	r0, [r4, #2]
c0d0072a:	2801      	cmp	r0, #1
c0d0072c:	d000      	beq.n	c0d00730 <bottos_main+0xb4>
c0d0072e:	e0ae      	b.n	c0d0088e <bottos_main+0x212>
c0d00730:	4638      	mov	r0, r7
                            // 不正确的参数
                            THROW(0x6A86);
                        }

                        // if this is the first transaction part, reset the hash and all the other temporary variables.
                        if (hashTainted) {
c0d00732:	7800      	ldrb	r0, [r0, #0]
c0d00734:	2800      	cmp	r0, #0
c0d00736:	d008      	beq.n	c0d0074a <bottos_main+0xce>
                            cx_sha256_init(&hash);
c0d00738:	486e      	ldr	r0, [pc, #440]	; (c0d008f4 <bottos_main+0x278>)
c0d0073a:	f001 fc43 	bl	c0d01fc4 <cx_sha256_init>
                            hashTainted = 0;
c0d0073e:	4865      	ldr	r0, [pc, #404]	; (c0d008d4 <bottos_main+0x258>)
c0d00740:	7005      	strb	r5, [r0, #0]
                            raw_tx_ix = 0;
c0d00742:	486d      	ldr	r0, [pc, #436]	; (c0d008f8 <bottos_main+0x27c>)
c0d00744:	6005      	str	r5, [r0, #0]
                            raw_tx_len = 0;
c0d00746:	486d      	ldr	r0, [pc, #436]	; (c0d008fc <bottos_main+0x280>)
c0d00748:	6005      	str	r5, [r0, #0]
                        }

                        // move the contents of the buffer into raw_tx, and update raw_tx_ix to the end of the buffer, to be ready for the next part of the tx.
                        unsigned int len = get_apdu_buffer_length();
c0d0074a:	f002 fc89 	bl	c0d03060 <get_apdu_buffer_length>
                        // todo:: 长度应为52
                        if(len != 52) {
c0d0074e:	2834      	cmp	r0, #52	; 0x34
c0d00750:	d000      	beq.n	c0d00754 <bottos_main+0xd8>
c0d00752:	e0a1      	b.n	c0d00898 <bottos_main+0x21c>
                            hashTainted = 1;
                            // 长度错误
                            THROW(0x6C00);
                        }
                        update_sign_hash();
c0d00754:	f002 fb74 	bl	c0d02e40 <update_sign_hash>
                        ui_confirm_sign();
c0d00758:	f002 fc18 	bl	c0d02f8c <ui_confirm_sign>
c0d0075c:	e016      	b.n	c0d0078c <bottos_main+0x110>
                    case 0x6000:
                    case 0x9000:
                        sw = e;
                        break;
                    default:
                        sw = 0x6800 | (e & 0x7FF);
c0d0075e:	4955      	ldr	r1, [pc, #340]	; (c0d008b4 <bottos_main+0x238>)
c0d00760:	4008      	ands	r0, r1
c0d00762:	210d      	movs	r1, #13
c0d00764:	02c9      	lsls	r1, r1, #11
c0d00766:	4301      	orrs	r1, r0
c0d00768:	a837      	add	r0, sp, #220	; 0xdc
c0d0076a:	8001      	strh	r1, [r0, #0]
                        break;
                }
                // Unexpected exception => report
                G_io_apdu_buffer[tx] = sw >> 8;
c0d0076c:	9837      	ldr	r0, [sp, #220]	; 0xdc
c0d0076e:	0a00      	lsrs	r0, r0, #8
c0d00770:	9939      	ldr	r1, [sp, #228]	; 0xe4
c0d00772:	5460      	strb	r0, [r4, r1]
                G_io_apdu_buffer[tx + 1] = sw;
c0d00774:	9837      	ldr	r0, [sp, #220]	; 0xdc
c0d00776:	9939      	ldr	r1, [sp, #228]	; 0xe4
                    default:
                        sw = 0x6800 | (e & 0x7FF);
                        break;
                }
                // Unexpected exception => report
                G_io_apdu_buffer[tx] = sw >> 8;
c0d00778:	1861      	adds	r1, r4, r1
                G_io_apdu_buffer[tx + 1] = sw;
c0d0077a:	7048      	strb	r0, [r1, #1]
                tx += 2;
c0d0077c:	9839      	ldr	r0, [sp, #228]	; 0xe4
c0d0077e:	1c80      	adds	r0, r0, #2
c0d00780:	9039      	str	r0, [sp, #228]	; 0xe4
c0d00782:	e008      	b.n	c0d00796 <bottos_main+0x11a>
c0d00784:	2906      	cmp	r1, #6
c0d00786:	d116      	bne.n	c0d007b6 <bottos_main+0x13a>
                    }
                        break;

                    case INS_TEST: {
                            // 显示UI 
                            ui_test();
c0d00788:	f002 fb8c 	bl	c0d02ea4 <ui_test>
c0d0078c:	2010      	movs	r0, #16
c0d0078e:	9938      	ldr	r1, [sp, #224]	; 0xe0
c0d00790:	4301      	orrs	r1, r0
c0d00792:	9138      	str	r1, [sp, #224]	; 0xe0
c0d00794:	463d      	mov	r5, r7
                // Unexpected exception => report
                G_io_apdu_buffer[tx] = sw >> 8;
                G_io_apdu_buffer[tx + 1] = sw;
                tx += 2;
            }
            FINALLY
c0d00796:	f000 fb47 	bl	c0d00e28 <try_context_get>
c0d0079a:	a92c      	add	r1, sp, #176	; 0xb0
c0d0079c:	4288      	cmp	r0, r1
c0d0079e:	d103      	bne.n	c0d007a8 <bottos_main+0x12c>
c0d007a0:	f000 fb44 	bl	c0d00e2c <try_context_get_previous>
c0d007a4:	f000 f9d3 	bl	c0d00b4e <try_context_set>
c0d007a8:	a82c      	add	r0, sp, #176	; 0xb0
            {
            }
        }
        END_TRY;
c0d007aa:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d007ac:	2800      	cmp	r0, #0
c0d007ae:	d100      	bne.n	c0d007b2 <bottos_main+0x136>
c0d007b0:	e76c      	b.n	c0d0068c <bottos_main+0x10>
c0d007b2:	f000 fb34 	bl	c0d00e1e <os_longjmp>
c0d007b6:	29ff      	cmp	r1, #255	; 0xff
c0d007b8:	d164      	bne.n	c0d00884 <bottos_main+0x208>
    }

	return_to_dashboard: return;
}
c0d007ba:	b03b      	add	sp, #236	; 0xec
c0d007bc:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d007be:	4a47      	ldr	r2, [pc, #284]	; (c0d008dc <bottos_main+0x260>)
    exit_timer = MAX_EXIT_TIMER;
    Timer_UpdateDescription();
}

static void Timer_Restart() {
    if (exit_timer != MAX_EXIT_TIMER) {
c0d007c0:	6811      	ldr	r1, [r2, #0]
c0d007c2:	4281      	cmp	r1, r0
c0d007c4:	d008      	beq.n	c0d007d8 <bottos_main+0x15c>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d007c6:	6010      	str	r0, [r2, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d007c8:	4845      	ldr	r0, [pc, #276]	; (c0d008e0 <bottos_main+0x264>)
c0d007ca:	2104      	movs	r1, #4
c0d007cc:	a245      	add	r2, pc, #276	; (adr r2, c0d008e4 <bottos_main+0x268>)
c0d007ce:	461e      	mov	r6, r3
c0d007d0:	2308      	movs	r3, #8
c0d007d2:	f001 f95b 	bl	c0d01a8c <snprintf>
c0d007d6:	4633      	mov	r3, r6
                        Timer_Restart();

                        cx_ecfp_public_key_t publicKey;
                        cx_ecfp_private_key_t privateKey;

                        if (rx < APDU_HEADER_LENGTH + BIP44_BYTE_LENGTH) {
c0d007d8:	983a      	ldr	r0, [sp, #232]	; 0xe8
c0d007da:	2818      	cmp	r0, #24
c0d007dc:	d962      	bls.n	c0d008a4 <bottos_main+0x228>
                        unsigned char *bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

                        unsigned int bip44_path[BIP44_PATH_LEN];
                        uint32_t i;
                        for (i = 0; i < BIP44_PATH_LEN; i++) {
								bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
c0d007de:	00a8      	lsls	r0, r5, #2
c0d007e0:	1821      	adds	r1, r4, r0
c0d007e2:	794a      	ldrb	r2, [r1, #5]
c0d007e4:	0612      	lsls	r2, r2, #24
c0d007e6:	798b      	ldrb	r3, [r1, #6]
c0d007e8:	041b      	lsls	r3, r3, #16
c0d007ea:	4313      	orrs	r3, r2
c0d007ec:	79ca      	ldrb	r2, [r1, #7]
c0d007ee:	0212      	lsls	r2, r2, #8
c0d007f0:	431a      	orrs	r2, r3
c0d007f2:	7a09      	ldrb	r1, [r1, #8]
c0d007f4:	4311      	orrs	r1, r2
c0d007f6:	aa0a      	add	r2, sp, #40	; 0x28
c0d007f8:	5011      	str	r1, [r2, r0]
                        /** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
                        unsigned char *bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

                        unsigned int bip44_path[BIP44_PATH_LEN];
                        uint32_t i;
                        for (i = 0; i < BIP44_PATH_LEN; i++) {
c0d007fa:	1c6d      	adds	r5, r5, #1
c0d007fc:	2d05      	cmp	r5, #5
c0d007fe:	d1ee      	bne.n	c0d007de <bottos_main+0x162>
c0d00800:	2400      	movs	r4, #0
								bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
                            bip44_in += 4;
                        }
                        unsigned char privateKeyData[32];
                        os_perso_derive_node_bip32(CX_CURVE_256K1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);
c0d00802:	4668      	mov	r0, sp
c0d00804:	6004      	str	r4, [r0, #0]
c0d00806:	2521      	movs	r5, #33	; 0x21
c0d00808:	a90a      	add	r1, sp, #40	; 0x28
c0d0080a:	2205      	movs	r2, #5
c0d0080c:	ae02      	add	r6, sp, #8
c0d0080e:	4628      	mov	r0, r5
c0d00810:	4633      	mov	r3, r6
c0d00812:	f001 fc6d 	bl	c0d020f0 <os_perso_derive_node_bip32>
                        cx_ecdsa_init_private_key(CX_CURVE_256K1, privateKeyData, 32, &privateKey);
c0d00816:	2220      	movs	r2, #32
c0d00818:	af0f      	add	r7, sp, #60	; 0x3c
c0d0081a:	4628      	mov	r0, r5
c0d0081c:	4631      	mov	r1, r6
c0d0081e:	463b      	mov	r3, r7
c0d00820:	f001 fbfe 	bl	c0d02020 <cx_ecfp_init_private_key>
c0d00824:	ae19      	add	r6, sp, #100	; 0x64

                        // generate the public key.
                        cx_ecdsa_init_public_key(CX_CURVE_256K1, NULL, 0, &publicKey);
c0d00826:	4628      	mov	r0, r5
c0d00828:	4621      	mov	r1, r4
c0d0082a:	4622      	mov	r2, r4
c0d0082c:	4633      	mov	r3, r6
c0d0082e:	f001 fbdf 	bl	c0d01ff0 <cx_ecfp_init_public_key>
c0d00832:	2401      	movs	r4, #1
                        cx_ecfp_generate_pair(CX_CURVE_256K1, &publicKey, &privateKey, 1);
c0d00834:	4628      	mov	r0, r5
c0d00836:	4631      	mov	r1, r6
c0d00838:	463a      	mov	r2, r7
c0d0083a:	4623      	mov	r3, r4
c0d0083c:	f001 fc08 	bl	c0d02050 <cx_ecfp_generate_pair>

                        // push the public key onto the response buffer.
                        os_memmove(G_io_apdu_buffer, publicKey.W, 65);
c0d00840:	3608      	adds	r6, #8
c0d00842:	481d      	ldr	r0, [pc, #116]	; (c0d008b8 <bottos_main+0x23c>)
c0d00844:	2541      	movs	r5, #65	; 0x41
c0d00846:	4631      	mov	r1, r6
c0d00848:	462a      	mov	r2, r5
c0d0084a:	f000 fa34 	bl	c0d00cb6 <os_memmove>
                        tx = 65;
c0d0084e:	9539      	str	r5, [sp, #228]	; 0xe4

                        display_public_key(publicKey.W);
c0d00850:	4630      	mov	r0, r6
c0d00852:	f000 f921 	bl	c0d00a98 <display_public_key>
    return 0;
}

/** refreshes the display if the public key was changed ans we are on the page displaying the public key */
static void refresh_public_key_display(void) {
    if ((uiState == UI_PUBLIC_KEY_1) || (uiState == UI_PUBLIC_KEY_2)) {
c0d00856:	4824      	ldr	r0, [pc, #144]	; (c0d008e8 <bottos_main+0x26c>)
c0d00858:	7800      	ldrb	r0, [r0, #0]
c0d0085a:	21fe      	movs	r1, #254	; 0xfe
c0d0085c:	4001      	ands	r1, r0
c0d0085e:	2908      	cmp	r1, #8
c0d00860:	d101      	bne.n	c0d00866 <bottos_main+0x1ea>
        publicKeyNeedsRefresh = 1;
c0d00862:	4822      	ldr	r0, [pc, #136]	; (c0d008ec <bottos_main+0x270>)
c0d00864:	7004      	strb	r4, [r0, #0]

                        display_public_key(publicKey.W);
                        refresh_public_key_display();

                        // return 0x9000 OK.
                        THROW(0x9000);
c0d00866:	2009      	movs	r0, #9
c0d00868:	0300      	lsls	r0, r0, #12
c0d0086a:	f000 fad8 	bl	c0d00e1e <os_longjmp>
                PRINTF("APDU received:\n%.*H\n",100, G_io_apdu_buffer);

                // no apdu received, well, reset the session, and reset the
                // bootloader configuration
                if (rx == 0) {
                    hashTainted = 1;
c0d0086e:	2001      	movs	r0, #1
c0d00870:	7038      	strb	r0, [r7, #0]
                    // 安全条件不满足
                    THROW(0x6982);
c0d00872:	4823      	ldr	r0, [pc, #140]	; (c0d00900 <bottos_main+0x284>)
c0d00874:	f000 fad3 	bl	c0d00e1e <os_longjmp>
                }

                // if the buffer doesn't start with the magic byte, return an error.
                if (G_io_apdu_buffer[0] != CLA) {
                    hashTainted = 1;
c0d00878:	2001      	movs	r0, #1
c0d0087a:	7038      	strb	r0, [r7, #0]
                    // CLA 不支持
                    THROW(0x6E00);
c0d0087c:	2037      	movs	r0, #55	; 0x37
c0d0087e:	0240      	lsls	r0, r0, #9
c0d00880:	f000 facd 	bl	c0d00e1e <os_longjmp>
                        goto return_to_dashboard;

                        // we're asked to do an unknown command
                    default:
                        // return an error.
                        hashTainted = 1;
c0d00884:	2001      	movs	r0, #1
c0d00886:	7038      	strb	r0, [r7, #0]
                        THROW(0x6D00);
c0d00888:	4618      	mov	r0, r3
c0d0088a:	f000 fac8 	bl	c0d00e1e <os_longjmp>
                    // we're getting a transaction to sign, in parts.
                    case INS_SIGN_HASH: {
                        Timer_Restart();
                        // 检查P1是否为0x01
                        if ((G_io_apdu_buffer[2] != P1_CONFIRM)) {
                            hashTainted = 1;
c0d0088e:	2001      	movs	r0, #1
c0d00890:	7038      	strb	r0, [r7, #0]
                            // 不正确的参数
                            THROW(0x6A86);
c0d00892:	4817      	ldr	r0, [pc, #92]	; (c0d008f0 <bottos_main+0x274>)
c0d00894:	f000 fac3 	bl	c0d00e1e <os_longjmp>

                        // move the contents of the buffer into raw_tx, and update raw_tx_ix to the end of the buffer, to be ready for the next part of the tx.
                        unsigned int len = get_apdu_buffer_length();
                        // todo:: 长度应为52
                        if(len != 52) {
                            hashTainted = 1;
c0d00898:	2001      	movs	r0, #1
c0d0089a:	7038      	strb	r0, [r7, #0]
                            // 长度错误
                            THROW(0x6C00);
c0d0089c:	201b      	movs	r0, #27
c0d0089e:	0280      	lsls	r0, r0, #10
c0d008a0:	f000 fabd 	bl	c0d00e1e <os_longjmp>

                        cx_ecfp_public_key_t publicKey;
                        cx_ecfp_private_key_t privateKey;

                        if (rx < APDU_HEADER_LENGTH + BIP44_BYTE_LENGTH) {
                            hashTainted = 1;
c0d008a4:	2001      	movs	r0, #1
c0d008a6:	7038      	strb	r0, [r7, #0]
                            THROW(0x6D09);
c0d008a8:	3309      	adds	r3, #9
c0d008aa:	4618      	mov	r0, r3
c0d008ac:	f000 fab7 	bl	c0d00e1e <os_longjmp>
c0d008b0:	0000ffff 	.word	0x0000ffff
c0d008b4:	000007ff 	.word	0x000007ff
c0d008b8:	200018f8 	.word	0x200018f8
c0d008bc:	55445041 	.word	0x55445041
c0d008c0:	63657220 	.word	0x63657220
c0d008c4:	65766965 	.word	0x65766965
c0d008c8:	250a3a64 	.word	0x250a3a64
c0d008cc:	0a482a2e 	.word	0x0a482a2e
c0d008d0:	00000000 	.word	0x00000000
c0d008d4:	20001b7c 	.word	0x20001b7c
c0d008d8:	00001002 	.word	0x00001002
c0d008dc:	20001c38 	.word	0x20001c38
c0d008e0:	20001c3c 	.word	0x20001c3c
c0d008e4:	00006425 	.word	0x00006425
c0d008e8:	20001b84 	.word	0x20001b84
c0d008ec:	20001c40 	.word	0x20001c40
c0d008f0:	00006a86 	.word	0x00006a86
c0d008f4:	20001b10 	.word	0x20001b10
c0d008f8:	20001b80 	.word	0x20001b80
c0d008fc:	20001b0c 	.word	0x20001b0c
c0d00900:	00006982 	.word	0x00006982

c0d00904 <to_address>:
        os_memmove(dest + dec_place_ix + 1, base10_buffer + dec_place_ix, buffer_len - dec_place_ix);
    }
}

/** converts a ONT scripthas to a ONT address by adding a checksum and encoding in base58 */
static void to_address(char *dest, unsigned int dest_len, const unsigned char *script_hash) {
c0d00904:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00906:	b0d1      	sub	sp, #324	; 0x144
c0d00908:	9004      	str	r0, [sp, #16]
c0d0090a:	ad0a      	add	r5, sp, #40	; 0x28
    unsigned char address_hash_result_0[SHA256_HASH_LEN];
    unsigned char address_hash_result_1[SHA256_HASH_LEN];

    // concatenate the ADDRESS_VERSION and the address.
    unsigned char address[ADDRESS_LEN];
    address[0] = ADDRESS_VERSION;
c0d0090c:	2017      	movs	r0, #23
c0d0090e:	7028      	strb	r0, [r5, #0]
    os_memmove(address + 1, script_hash, SCRIPT_HASH_LEN);
c0d00910:	1c68      	adds	r0, r5, #1
c0d00912:	2214      	movs	r2, #20
c0d00914:	f000 f9cf 	bl	c0d00cb6 <os_memmove>

    // do a sha256 hash of the address twice.
    cx_sha256_init(&address_hash);
c0d00918:	4c4a      	ldr	r4, [pc, #296]	; (c0d00a44 <to_address+0x140>)
c0d0091a:	4620      	mov	r0, r4
c0d0091c:	f001 fb52 	bl	c0d01fc4 <cx_sha256_init>
    cx_hash(&address_hash.header, CX_LAST, address, SCRIPT_HASH_LEN + 1, address_hash_result_0, 32);
c0d00920:	2720      	movs	r7, #32
c0d00922:	4668      	mov	r0, sp
c0d00924:	6047      	str	r7, [r0, #4]
c0d00926:	a919      	add	r1, sp, #100	; 0x64
c0d00928:	9109      	str	r1, [sp, #36]	; 0x24
c0d0092a:	6001      	str	r1, [r0, #0]
c0d0092c:	2601      	movs	r6, #1
c0d0092e:	2315      	movs	r3, #21
c0d00930:	4620      	mov	r0, r4
c0d00932:	4631      	mov	r1, r6
c0d00934:	462a      	mov	r2, r5
c0d00936:	f001 fb13 	bl	c0d01f60 <cx_hash>
    cx_sha256_init(&address_hash);
c0d0093a:	4620      	mov	r0, r4
c0d0093c:	f001 fb42 	bl	c0d01fc4 <cx_sha256_init>
    cx_hash(&address_hash.header, CX_LAST, address_hash_result_0, SHA256_HASH_LEN, address_hash_result_1, 32);
c0d00940:	4668      	mov	r0, sp
c0d00942:	6047      	str	r7, [r0, #4]
c0d00944:	ac11      	add	r4, sp, #68	; 0x44
c0d00946:	6004      	str	r4, [r0, #0]
c0d00948:	483e      	ldr	r0, [pc, #248]	; (c0d00a44 <to_address+0x140>)
c0d0094a:	4631      	mov	r1, r6
c0d0094c:	9a09      	ldr	r2, [sp, #36]	; 0x24
c0d0094e:	463b      	mov	r3, r7
c0d00950:	f001 fb06 	bl	c0d01f60 <cx_hash>

    // add the first bytes of the hash as a checksum at the end of the address.
    os_memmove(address + 1 + SCRIPT_HASH_LEN, address_hash_result_1, SCRIPT_HASH_CHECKSUM_LEN);
c0d00954:	4628      	mov	r0, r5
c0d00956:	3015      	adds	r0, #21
c0d00958:	2204      	movs	r2, #4
c0d0095a:	4621      	mov	r1, r4
c0d0095c:	f000 f9ab 	bl	c0d00cb6 <os_memmove>
c0d00960:	a841      	add	r0, sp, #260	; 0x104
    unsigned char zeroCount = 0;
    if (in_length > sizeof(tmp)) {
        hashTainted = 1;
        THROW(0x6D11);
    }
    os_memmove(tmp, in, in_length);
c0d00962:	2219      	movs	r2, #25
c0d00964:	4629      	mov	r1, r5
c0d00966:	f000 f9a6 	bl	c0d00cb6 <os_memmove>
c0d0096a:	2600      	movs	r6, #0
c0d0096c:	a841      	add	r0, sp, #260	; 0x104
    while ((zeroCount < in_length) && (tmp[zeroCount] == 0)) {
c0d0096e:	5d80      	ldrb	r0, [r0, r6]
c0d00970:	2800      	cmp	r0, #0
c0d00972:	d104      	bne.n	c0d0097e <to_address+0x7a>
        ++zeroCount;
c0d00974:	1c76      	adds	r6, r6, #1
    if (in_length > sizeof(tmp)) {
        hashTainted = 1;
        THROW(0x6D11);
    }
    os_memmove(tmp, in, in_length);
    while ((zeroCount < in_length) && (tmp[zeroCount] == 0)) {
c0d00976:	2e19      	cmp	r6, #25
c0d00978:	d3f8      	bcc.n	c0d0096c <to_address+0x68>
c0d0097a:	2732      	movs	r7, #50	; 0x32
c0d0097c:	e046      	b.n	c0d00a0c <to_address+0x108>
c0d0097e:	2000      	movs	r0, #0
c0d00980:	9005      	str	r0, [sp, #20]
c0d00982:	43c5      	mvns	r5, r0
c0d00984:	2732      	movs	r7, #50	; 0x32
c0d00986:	2231      	movs	r2, #49	; 0x31
c0d00988:	9609      	str	r6, [sp, #36]	; 0x24
c0d0098a:	9603      	str	r6, [sp, #12]
c0d0098c:	4633      	mov	r3, r6
c0d0098e:	9708      	str	r7, [sp, #32]
c0d00990:	9207      	str	r2, [sp, #28]
c0d00992:	9306      	str	r3, [sp, #24]

    startAt = zeroCount;
    while (startAt < in_length) {
        unsigned short remainder = 0;
        unsigned char divLoop;
        for (divLoop = startAt; divLoop < in_length; divLoop++) {
c0d00994:	b2de      	uxtb	r6, r3
c0d00996:	436e      	muls	r6, r5
c0d00998:	9905      	ldr	r1, [sp, #20]
            unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
c0d0099a:	462f      	mov	r7, r5
c0d0099c:	4377      	muls	r7, r6
c0d0099e:	ac41      	add	r4, sp, #260	; 0x104
            unsigned short tmpDiv = remainder * 256 + digit256;
c0d009a0:	5de2      	ldrb	r2, [r4, r7]
c0d009a2:	0208      	lsls	r0, r1, #8
            tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
c0d009a4:	4310      	orrs	r0, r2
c0d009a6:	213a      	movs	r1, #58	; 0x3a
            remainder = (tmpDiv % alphabet_len);
c0d009a8:	f003 fbf4 	bl	c0d04194 <__aeabi_uidivmod>
        unsigned short remainder = 0;
        unsigned char divLoop;
        for (divLoop = startAt; divLoop < in_length; divLoop++) {
            unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
            unsigned short tmpDiv = remainder * 256 + digit256;
            tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
c0d009ac:	55e0      	strb	r0, [r4, r7]

    startAt = zeroCount;
    while (startAt < in_length) {
        unsigned short remainder = 0;
        unsigned char divLoop;
        for (divLoop = startAt; divLoop < in_length; divLoop++) {
c0d009ae:	1e76      	subs	r6, r6, #1
c0d009b0:	4630      	mov	r0, r6
c0d009b2:	3019      	adds	r0, #25
c0d009b4:	d1f1      	bne.n	c0d0099a <to_address+0x96>
c0d009b6:	a841      	add	r0, sp, #260	; 0x104
            unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
            unsigned short tmpDiv = remainder * 256 + digit256;
            tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
            remainder = (tmpDiv % alphabet_len);
        }
        if (tmp[startAt] == 0) {
c0d009b8:	9a09      	ldr	r2, [sp, #36]	; 0x24
c0d009ba:	5c82      	ldrb	r2, [r0, r2]
            ++startAt;
        }
        buffer[--buffer_ix] = *(alphabet + remainder);
c0d009bc:	4823      	ldr	r0, [pc, #140]	; (c0d00a4c <to_address+0x148>)
c0d009be:	4478      	add	r0, pc
c0d009c0:	5c43      	ldrb	r3, [r0, r1]
c0d009c2:	9f08      	ldr	r7, [sp, #32]
c0d009c4:	1e7f      	subs	r7, r7, #1
c0d009c6:	b2f8      	uxtb	r0, r7
c0d009c8:	ac21      	add	r4, sp, #132	; 0x84
c0d009ca:	5423      	strb	r3, [r4, r0]
c0d009cc:	9c06      	ldr	r4, [sp, #24]
            unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
            unsigned short tmpDiv = remainder * 256 + digit256;
            tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
            remainder = (tmpDiv % alphabet_len);
        }
        if (tmp[startAt] == 0) {
c0d009ce:	1c63      	adds	r3, r4, #1
c0d009d0:	2a00      	cmp	r2, #0
c0d009d2:	d000      	beq.n	c0d009d6 <to_address+0xd2>
c0d009d4:	4623      	mov	r3, r4
c0d009d6:	b2de      	uxtb	r6, r3
c0d009d8:	9c07      	ldr	r4, [sp, #28]
        hashTainted = 1;
        THROW(0x6D12);
    }

    startAt = zeroCount;
    while (startAt < in_length) {
c0d009da:	1e62      	subs	r2, r4, #1
c0d009dc:	9609      	str	r6, [sp, #36]	; 0x24
c0d009de:	2e19      	cmp	r6, #25
c0d009e0:	d3d5      	bcc.n	c0d0098e <to_address+0x8a>
        if (tmp[startAt] == 0) {
            ++startAt;
        }
        buffer[--buffer_ix] = *(alphabet + remainder);
    }
    while ((buffer_ix < (2 * in_length)) && (buffer[buffer_ix] == *(alphabet + 0))) {
c0d009e2:	2831      	cmp	r0, #49	; 0x31
c0d009e4:	d80e      	bhi.n	c0d00a04 <to_address+0x100>
c0d009e6:	2900      	cmp	r1, #0
c0d009e8:	9e03      	ldr	r6, [sp, #12]
c0d009ea:	d10c      	bne.n	c0d00a06 <to_address+0x102>
        ++buffer_ix;
c0d009ec:	b2e0      	uxtb	r0, r4
c0d009ee:	1c40      	adds	r0, r0, #1
c0d009f0:	1c7f      	adds	r7, r7, #1
        if (tmp[startAt] == 0) {
            ++startAt;
        }
        buffer[--buffer_ix] = *(alphabet + remainder);
    }
    while ((buffer_ix < (2 * in_length)) && (buffer[buffer_ix] == *(alphabet + 0))) {
c0d009f2:	2831      	cmp	r0, #49	; 0x31
c0d009f4:	d807      	bhi.n	c0d00a06 <to_address+0x102>
c0d009f6:	a921      	add	r1, sp, #132	; 0x84
c0d009f8:	5c09      	ldrb	r1, [r1, r0]
c0d009fa:	1c40      	adds	r0, r0, #1
c0d009fc:	2931      	cmp	r1, #49	; 0x31
c0d009fe:	d0f7      	beq.n	c0d009f0 <to_address+0xec>
c0d00a00:	1e47      	subs	r7, r0, #1
c0d00a02:	e000      	b.n	c0d00a06 <to_address+0x102>
c0d00a04:	9e03      	ldr	r6, [sp, #12]
c0d00a06:	20ff      	movs	r0, #255	; 0xff
        ++buffer_ix;
    }
    while (zeroCount-- > 0) {
c0d00a08:	4206      	tst	r6, r0
c0d00a0a:	d00b      	beq.n	c0d00a24 <to_address+0x120>
c0d00a0c:	4638      	mov	r0, r7
c0d00a0e:	4631      	mov	r1, r6
        buffer[--buffer_ix] = *(alphabet + 0);
c0d00a10:	1e40      	subs	r0, r0, #1
c0d00a12:	b2c2      	uxtb	r2, r0
c0d00a14:	ab21      	add	r3, sp, #132	; 0x84
c0d00a16:	2431      	movs	r4, #49	; 0x31
c0d00a18:	549c      	strb	r4, [r3, r2]
        buffer[--buffer_ix] = *(alphabet + remainder);
    }
    while ((buffer_ix < (2 * in_length)) && (buffer[buffer_ix] == *(alphabet + 0))) {
        ++buffer_ix;
    }
    while (zeroCount-- > 0) {
c0d00a1a:	1e49      	subs	r1, r1, #1
c0d00a1c:	22ff      	movs	r2, #255	; 0xff
c0d00a1e:	4211      	tst	r1, r2
c0d00a20:	d1f6      	bne.n	c0d00a10 <to_address+0x10c>
c0d00a22:	1bbf      	subs	r7, r7, r6
        buffer[--buffer_ix] = *(alphabet + 0);
    }
    const unsigned int true_out_length = (2 * in_length) - buffer_ix;
c0d00a24:	b2f8      	uxtb	r0, r7
c0d00a26:	2132      	movs	r1, #50	; 0x32
c0d00a28:	1a0a      	subs	r2, r1, r0
    if (true_out_length > out_length) {
c0d00a2a:	2a23      	cmp	r2, #35	; 0x23
c0d00a2c:	d206      	bcs.n	c0d00a3c <to_address+0x138>
c0d00a2e:	a921      	add	r1, sp, #132	; 0x84
        THROW(0x6D14);
    }
    os_memmove(out, (buffer + buffer_ix), true_out_length);
c0d00a30:	1809      	adds	r1, r1, r0
c0d00a32:	9804      	ldr	r0, [sp, #16]
c0d00a34:	f000 f93f 	bl	c0d00cb6 <os_memmove>
    // add the first bytes of the hash as a checksum at the end of the address.
    os_memmove(address + 1 + SCRIPT_HASH_LEN, address_hash_result_1, SCRIPT_HASH_CHECKSUM_LEN);

    // encode the version + address + checksum in base58
    encode_base_58(address, ADDRESS_LEN, dest, dest_len);
}
c0d00a38:	b051      	add	sp, #324	; 0x144
c0d00a3a:	bdf0      	pop	{r4, r5, r6, r7, pc}
    while (zeroCount-- > 0) {
        buffer[--buffer_ix] = *(alphabet + 0);
    }
    const unsigned int true_out_length = (2 * in_length) - buffer_ix;
    if (true_out_length > out_length) {
        THROW(0x6D14);
c0d00a3c:	4802      	ldr	r0, [pc, #8]	; (c0d00a48 <to_address+0x144>)
c0d00a3e:	f000 f9ee 	bl	c0d00e1e <os_longjmp>
c0d00a42:	46c0      	nop			; (mov r8, r8)
c0d00a44:	20001880 	.word	0x20001880
c0d00a48:	00006d14 	.word	0x00006d14
c0d00a4c:	000039b8 	.word	0x000039b8

c0d00a50 <public_key_hash160>:
    os_memmove(current_public_key[0], NO_PUBLIC_KEY_0, sizeof(NO_PUBLIC_KEY_0));
    os_memmove(current_public_key[1], NO_PUBLIC_KEY_1, sizeof(NO_PUBLIC_KEY_1));
    publicKeyNeedsRefresh = 0;
}

void public_key_hash160(unsigned char *in, unsigned short inlen, unsigned char *out) {
c0d00a50:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00a52:	b0a9      	sub	sp, #164	; 0xa4
c0d00a54:	ab03      	add	r3, sp, #12
c0d00a56:	c307      	stmia	r3!, {r0, r1, r2}
c0d00a58:	ad0e      	add	r5, sp, #56	; 0x38
        cx_sha256_t shasha;
        cx_ripemd160_t riprip;
    } u;
    unsigned char buffer[32];

    cx_sha256_init(&u.shasha);
c0d00a5a:	4628      	mov	r0, r5
c0d00a5c:	f001 fab2 	bl	c0d01fc4 <cx_sha256_init>
    cx_hash(&u.shasha.header, CX_LAST, in, inlen, buffer, 32);
c0d00a60:	2620      	movs	r6, #32
c0d00a62:	4668      	mov	r0, sp
c0d00a64:	6046      	str	r6, [r0, #4]
c0d00a66:	af06      	add	r7, sp, #24
c0d00a68:	6007      	str	r7, [r0, #0]
c0d00a6a:	2401      	movs	r4, #1
c0d00a6c:	4628      	mov	r0, r5
c0d00a6e:	4621      	mov	r1, r4
c0d00a70:	9a03      	ldr	r2, [sp, #12]
c0d00a72:	9b04      	ldr	r3, [sp, #16]
c0d00a74:	f001 fa74 	bl	c0d01f60 <cx_hash>
    cx_ripemd160_init(&u.riprip);
c0d00a78:	4628      	mov	r0, r5
c0d00a7a:	f001 fa8d 	bl	c0d01f98 <cx_ripemd160_init>
    cx_hash(&u.riprip.header, CX_LAST, buffer, 32, out, 20);
c0d00a7e:	2014      	movs	r0, #20
c0d00a80:	4669      	mov	r1, sp
c0d00a82:	9a05      	ldr	r2, [sp, #20]
c0d00a84:	600a      	str	r2, [r1, #0]
c0d00a86:	6048      	str	r0, [r1, #4]
c0d00a88:	4628      	mov	r0, r5
c0d00a8a:	4621      	mov	r1, r4
c0d00a8c:	463a      	mov	r2, r7
c0d00a8e:	4633      	mov	r3, r6
c0d00a90:	f001 fa66 	bl	c0d01f60 <cx_hash>
}
c0d00a94:	b029      	add	sp, #164	; 0xa4
c0d00a96:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d00a98 <display_public_key>:

void display_public_key(const unsigned char *public_key) {
c0d00a98:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00a9a:	b0a1      	sub	sp, #132	; 0x84
c0d00a9c:	9000      	str	r0, [sp, #0]
    os_memmove(current_public_key[0], TXT_BLANK, sizeof(TXT_BLANK));
c0d00a9e:	4e28      	ldr	r6, [pc, #160]	; (c0d00b40 <display_public_key+0xa8>)
c0d00aa0:	4c28      	ldr	r4, [pc, #160]	; (c0d00b44 <display_public_key+0xac>)
c0d00aa2:	447c      	add	r4, pc
c0d00aa4:	2712      	movs	r7, #18
c0d00aa6:	4630      	mov	r0, r6
c0d00aa8:	4621      	mov	r1, r4
c0d00aaa:	463a      	mov	r2, r7
c0d00aac:	f000 f903 	bl	c0d00cb6 <os_memmove>
    os_memmove(current_public_key[1], TXT_BLANK, sizeof(TXT_BLANK));
c0d00ab0:	3612      	adds	r6, #18
c0d00ab2:	4630      	mov	r0, r6
c0d00ab4:	4621      	mov	r1, r4
c0d00ab6:	463a      	mov	r2, r7
c0d00ab8:	f000 f8fd 	bl	c0d00cb6 <os_memmove>
    os_memmove(current_public_key[2], TXT_BLANK, sizeof(TXT_BLANK));
c0d00abc:	4d20      	ldr	r5, [pc, #128]	; (c0d00b40 <display_public_key+0xa8>)
c0d00abe:	3524      	adds	r5, #36	; 0x24
c0d00ac0:	4628      	mov	r0, r5
c0d00ac2:	4621      	mov	r1, r4
c0d00ac4:	463a      	mov	r2, r7
c0d00ac6:	f000 f8f6 	bl	c0d00cb6 <os_memmove>

    unsigned char public_key_encoded[33];
    public_key_encoded[0] = ((public_key[64] & 1) ? 0x03 : 0x02);
c0d00aca:	2040      	movs	r0, #64	; 0x40
c0d00acc:	9a00      	ldr	r2, [sp, #0]
c0d00ace:	5c10      	ldrb	r0, [r2, r0]
c0d00ad0:	2101      	movs	r1, #1
c0d00ad2:	4001      	ands	r1, r0
c0d00ad4:	2002      	movs	r0, #2
c0d00ad6:	4308      	orrs	r0, r1
c0d00ad8:	ac18      	add	r4, sp, #96	; 0x60
c0d00ada:	7020      	strb	r0, [r4, #0]
    os_memmove(public_key_encoded + 1, public_key + 1, 32);
c0d00adc:	1c60      	adds	r0, r4, #1
c0d00ade:	1c51      	adds	r1, r2, #1
c0d00ae0:	2220      	movs	r2, #32
c0d00ae2:	f000 f8e8 	bl	c0d00cb6 <os_memmove>
c0d00ae6:	af0f      	add	r7, sp, #60	; 0x3c
c0d00ae8:	2221      	movs	r2, #33	; 0x21

    unsigned char verification_script[35];
    verification_script[0] = 0x21;
c0d00aea:	703a      	strb	r2, [r7, #0]
    os_memmove(verification_script + 1, public_key_encoded, sizeof(public_key_encoded));
c0d00aec:	1c78      	adds	r0, r7, #1
c0d00aee:	4621      	mov	r1, r4
c0d00af0:	f000 f8e1 	bl	c0d00cb6 <os_memmove>
    verification_script[sizeof(verification_script) - 1] = 0xAC;
c0d00af4:	2022      	movs	r0, #34	; 0x22
c0d00af6:	21ac      	movs	r1, #172	; 0xac
c0d00af8:	5439      	strb	r1, [r7, r0]
c0d00afa:	ac0a      	add	r4, sp, #40	; 0x28

    unsigned char script_hash[SCRIPT_HASH_LEN];
    for (int i = 0; i < SCRIPT_HASH_LEN; i++) {
        script_hash[i] = 0x00;
c0d00afc:	2114      	movs	r1, #20
c0d00afe:	4620      	mov	r0, r4
c0d00b00:	f003 fb4e 	bl	c0d041a0 <__aeabi_memclr>
    }

    public_key_hash160(verification_script, sizeof(verification_script), script_hash);
c0d00b04:	2123      	movs	r1, #35	; 0x23
c0d00b06:	4638      	mov	r0, r7
c0d00b08:	4622      	mov	r2, r4
c0d00b0a:	f7ff ffa1 	bl	c0d00a50 <public_key_hash160>
c0d00b0e:	af01      	add	r7, sp, #4
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);
c0d00b10:	4638      	mov	r0, r7
c0d00b12:	4621      	mov	r1, r4
c0d00b14:	f7ff fef6 	bl	c0d00904 <to_address>
c0d00b18:	240b      	movs	r4, #11

    os_memmove(current_public_key[0], address_base58_0, address_base58_len_0);
c0d00b1a:	4809      	ldr	r0, [pc, #36]	; (c0d00b40 <display_public_key+0xa8>)
c0d00b1c:	4639      	mov	r1, r7
c0d00b1e:	4622      	mov	r2, r4
c0d00b20:	f000 f8c9 	bl	c0d00cb6 <os_memmove>
    char address_base58[ADDRESS_BASE58_LEN];
    unsigned int address_base58_len_0 = 11;
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
c0d00b24:	4639      	mov	r1, r7
c0d00b26:	310b      	adds	r1, #11
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);

    os_memmove(current_public_key[0], address_base58_0, address_base58_len_0);
    os_memmove(current_public_key[1], address_base58_1, address_base58_len_1);
c0d00b28:	4630      	mov	r0, r6
c0d00b2a:	4622      	mov	r2, r4
c0d00b2c:	f000 f8c3 	bl	c0d00cb6 <os_memmove>
    unsigned int address_base58_len_0 = 11;
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
c0d00b30:	3716      	adds	r7, #22
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);

    os_memmove(current_public_key[0], address_base58_0, address_base58_len_0);
    os_memmove(current_public_key[1], address_base58_1, address_base58_len_1);
    os_memmove(current_public_key[2], address_base58_2, address_base58_len_2);
c0d00b32:	220c      	movs	r2, #12
c0d00b34:	4628      	mov	r0, r5
c0d00b36:	4639      	mov	r1, r7
c0d00b38:	f000 f8bd 	bl	c0d00cb6 <os_memmove>
}
c0d00b3c:	b021      	add	sp, #132	; 0x84
c0d00b3e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00b40:	20001c4c 	.word	0x20001c4c
c0d00b44:	000038c2 	.word	0x000038c2

c0d00b48 <os_boot>:
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d00b48:	2000      	movs	r0, #0
c0d00b4a:	4681      	mov	r9, r0

void os_boot(void) {
  // TODO patch entry point when romming (f)
  // set the default try context to nothing
  try_context_set(NULL);
}
c0d00b4c:	4770      	bx	lr

c0d00b4e <try_context_set>:
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d00b4e:	4681      	mov	r9, r0
}
c0d00b50:	4770      	bx	lr
	...

c0d00b54 <io_usb_hid_receive>:
volatile unsigned int   G_io_usb_hid_channel;
volatile unsigned int   G_io_usb_hid_remaining_length;
volatile unsigned int   G_io_usb_hid_sequence_number;
volatile unsigned char* G_io_usb_hid_current_buffer;

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
c0d00b54:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00b56:	b081      	sub	sp, #4
c0d00b58:	9200      	str	r2, [sp, #0]
c0d00b5a:	460f      	mov	r7, r1
c0d00b5c:	4605      	mov	r5, r0
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
c0d00b5e:	4b48      	ldr	r3, [pc, #288]	; (c0d00c80 <io_usb_hid_receive+0x12c>)
c0d00b60:	429f      	cmp	r7, r3
c0d00b62:	d00f      	beq.n	c0d00b84 <io_usb_hid_receive+0x30>
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d00b64:	4c46      	ldr	r4, [pc, #280]	; (c0d00c80 <io_usb_hid_receive+0x12c>)
c0d00b66:	2640      	movs	r6, #64	; 0x40
c0d00b68:	4620      	mov	r0, r4
c0d00b6a:	4631      	mov	r1, r6
c0d00b6c:	f003 fb18 	bl	c0d041a0 <__aeabi_memclr>
c0d00b70:	9800      	ldr	r0, [sp, #0]

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
    os_memset(G_io_usb_ep_buffer, 0, sizeof(G_io_usb_ep_buffer));
    os_memmove(G_io_usb_ep_buffer, buffer, MIN(l, sizeof(G_io_usb_ep_buffer)));
c0d00b72:	2840      	cmp	r0, #64	; 0x40
c0d00b74:	4602      	mov	r2, r0
c0d00b76:	d300      	bcc.n	c0d00b7a <io_usb_hid_receive+0x26>
c0d00b78:	4632      	mov	r2, r6
c0d00b7a:	4620      	mov	r0, r4
c0d00b7c:	4639      	mov	r1, r7
c0d00b7e:	f000 f89a 	bl	c0d00cb6 <os_memmove>
c0d00b82:	4b3f      	ldr	r3, [pc, #252]	; (c0d00c80 <io_usb_hid_receive+0x12c>)
c0d00b84:	7898      	ldrb	r0, [r3, #2]
  }

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
c0d00b86:	2801      	cmp	r0, #1
c0d00b88:	dc0b      	bgt.n	c0d00ba2 <io_usb_hid_receive+0x4e>
c0d00b8a:	2800      	cmp	r0, #0
c0d00b8c:	d02b      	beq.n	c0d00be6 <io_usb_hid_receive+0x92>
c0d00b8e:	2801      	cmp	r0, #1
c0d00b90:	d169      	bne.n	c0d00c66 <io_usb_hid_receive+0x112>
    // await for the next chunk
    goto apdu_reset;

  case 0x01: // ALLOCATE CHANNEL
    // do not reset the current apdu reception if any
    cx_rng(G_io_usb_ep_buffer+3, 4);
c0d00b92:	1cd8      	adds	r0, r3, #3
c0d00b94:	2104      	movs	r1, #4
c0d00b96:	461c      	mov	r4, r3
c0d00b98:	f001 f9ca 	bl	c0d01f30 <cx_rng>
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d00b9c:	2140      	movs	r1, #64	; 0x40
c0d00b9e:	4620      	mov	r0, r4
c0d00ba0:	e02c      	b.n	c0d00bfc <io_usb_hid_receive+0xa8>
c0d00ba2:	2802      	cmp	r0, #2
c0d00ba4:	d028      	beq.n	c0d00bf8 <io_usb_hid_receive+0xa4>
c0d00ba6:	2805      	cmp	r0, #5
c0d00ba8:	d15d      	bne.n	c0d00c66 <io_usb_hid_receive+0x112>

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
  case 0x05:
    // ensure sequence idx is 0 for the first chunk ! 
    if ((unsigned int)U2BE(G_io_usb_ep_buffer, 3) != (unsigned int)G_io_usb_hid_sequence_number) {
c0d00baa:	7918      	ldrb	r0, [r3, #4]
c0d00bac:	78d9      	ldrb	r1, [r3, #3]
c0d00bae:	0209      	lsls	r1, r1, #8
c0d00bb0:	4301      	orrs	r1, r0
c0d00bb2:	4a34      	ldr	r2, [pc, #208]	; (c0d00c84 <io_usb_hid_receive+0x130>)
c0d00bb4:	6810      	ldr	r0, [r2, #0]
c0d00bb6:	2400      	movs	r4, #0
c0d00bb8:	4281      	cmp	r1, r0
c0d00bba:	d15a      	bne.n	c0d00c72 <io_usb_hid_receive+0x11e>
c0d00bbc:	4e32      	ldr	r6, [pc, #200]	; (c0d00c88 <io_usb_hid_receive+0x134>)
      // ignore packet
      goto apdu_reset;
    }
    // cid, tag, seq
    l -= 2+1+2;
c0d00bbe:	9800      	ldr	r0, [sp, #0]
c0d00bc0:	1980      	adds	r0, r0, r6
c0d00bc2:	1f07      	subs	r7, r0, #4
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
c0d00bc4:	6810      	ldr	r0, [r2, #0]
c0d00bc6:	2800      	cmp	r0, #0
c0d00bc8:	d01b      	beq.n	c0d00c02 <io_usb_hid_receive+0xae>
c0d00bca:	4614      	mov	r4, r2
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
    }
    else {
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (l > G_io_usb_hid_remaining_length) {
c0d00bcc:	4639      	mov	r1, r7
c0d00bce:	4031      	ands	r1, r6
c0d00bd0:	482e      	ldr	r0, [pc, #184]	; (c0d00c8c <io_usb_hid_receive+0x138>)
c0d00bd2:	6802      	ldr	r2, [r0, #0]
c0d00bd4:	4291      	cmp	r1, r2
c0d00bd6:	d900      	bls.n	c0d00bda <io_usb_hid_receive+0x86>
        l = G_io_usb_hid_remaining_length;
c0d00bd8:	6807      	ldr	r7, [r0, #0]
      }

      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
c0d00bda:	463a      	mov	r2, r7
c0d00bdc:	4032      	ands	r2, r6
c0d00bde:	482c      	ldr	r0, [pc, #176]	; (c0d00c90 <io_usb_hid_receive+0x13c>)
c0d00be0:	6800      	ldr	r0, [r0, #0]
c0d00be2:	1d59      	adds	r1, r3, #5
c0d00be4:	e031      	b.n	c0d00c4a <io_usb_hid_receive+0xf6>
c0d00be6:	2400      	movs	r4, #0
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d00be8:	719c      	strb	r4, [r3, #6]
c0d00bea:	715c      	strb	r4, [r3, #5]
c0d00bec:	711c      	strb	r4, [r3, #4]
c0d00bee:	70dc      	strb	r4, [r3, #3]

  case 0x00: // get version ID
    // do not reset the current apdu reception if any
    os_memset(G_io_usb_ep_buffer+3, 0, 4); // PROTOCOL VERSION is 0
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d00bf0:	2140      	movs	r1, #64	; 0x40
c0d00bf2:	4618      	mov	r0, r3
c0d00bf4:	47a8      	blx	r5
c0d00bf6:	e03c      	b.n	c0d00c72 <io_usb_hid_receive+0x11e>
    goto apdu_reset;

  case 0x02: // ECHO|PING
    // do not reset the current apdu reception if any
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d00bf8:	4821      	ldr	r0, [pc, #132]	; (c0d00c80 <io_usb_hid_receive+0x12c>)
c0d00bfa:	2140      	movs	r1, #64	; 0x40
c0d00bfc:	47a8      	blx	r5
c0d00bfe:	2400      	movs	r4, #0
c0d00c00:	e037      	b.n	c0d00c72 <io_usb_hid_receive+0x11e>
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
      /// This is the apdu first chunk
      // total apdu size to receive
      G_io_usb_hid_total_length = U2BE(G_io_usb_ep_buffer, 5); //(G_io_usb_ep_buffer[5]<<8)+(G_io_usb_ep_buffer[6]&0xFF);
c0d00c02:	7998      	ldrb	r0, [r3, #6]
c0d00c04:	7959      	ldrb	r1, [r3, #5]
c0d00c06:	0209      	lsls	r1, r1, #8
c0d00c08:	4301      	orrs	r1, r0
c0d00c0a:	4822      	ldr	r0, [pc, #136]	; (c0d00c94 <io_usb_hid_receive+0x140>)
c0d00c0c:	6001      	str	r1, [r0, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
c0d00c0e:	6801      	ldr	r1, [r0, #0]
c0d00c10:	0849      	lsrs	r1, r1, #1
c0d00c12:	29a8      	cmp	r1, #168	; 0xa8
c0d00c14:	d82d      	bhi.n	c0d00c72 <io_usb_hid_receive+0x11e>
c0d00c16:	4614      	mov	r4, r2
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
      // compute remaining size to receive
      G_io_usb_hid_remaining_length = G_io_usb_hid_total_length;
c0d00c18:	6801      	ldr	r1, [r0, #0]
c0d00c1a:	481c      	ldr	r0, [pc, #112]	; (c0d00c8c <io_usb_hid_receive+0x138>)
c0d00c1c:	6001      	str	r1, [r0, #0]
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d00c1e:	491c      	ldr	r1, [pc, #112]	; (c0d00c90 <io_usb_hid_receive+0x13c>)
c0d00c20:	4a1d      	ldr	r2, [pc, #116]	; (c0d00c98 <io_usb_hid_receive+0x144>)
c0d00c22:	600a      	str	r2, [r1, #0]

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);
c0d00c24:	7859      	ldrb	r1, [r3, #1]
c0d00c26:	781a      	ldrb	r2, [r3, #0]
c0d00c28:	0212      	lsls	r2, r2, #8
c0d00c2a:	430a      	orrs	r2, r1
c0d00c2c:	491b      	ldr	r1, [pc, #108]	; (c0d00c9c <io_usb_hid_receive+0x148>)
c0d00c2e:	600a      	str	r2, [r1, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
c0d00c30:	491b      	ldr	r1, [pc, #108]	; (c0d00ca0 <io_usb_hid_receive+0x14c>)
c0d00c32:	9a00      	ldr	r2, [sp, #0]
c0d00c34:	1857      	adds	r7, r2, r1
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);

      if (l > G_io_usb_hid_remaining_length) {
c0d00c36:	4639      	mov	r1, r7
c0d00c38:	4031      	ands	r1, r6
c0d00c3a:	6802      	ldr	r2, [r0, #0]
c0d00c3c:	4291      	cmp	r1, r2
c0d00c3e:	d900      	bls.n	c0d00c42 <io_usb_hid_receive+0xee>
        l = G_io_usb_hid_remaining_length;
c0d00c40:	6807      	ldr	r7, [r0, #0]
      }
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
c0d00c42:	463a      	mov	r2, r7
c0d00c44:	4032      	ands	r2, r6
c0d00c46:	1dd9      	adds	r1, r3, #7
c0d00c48:	4813      	ldr	r0, [pc, #76]	; (c0d00c98 <io_usb_hid_receive+0x144>)
c0d00c4a:	f000 f834 	bl	c0d00cb6 <os_memmove>
      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
    }
    // factorize (f)
    G_io_usb_hid_current_buffer += l;
c0d00c4e:	4037      	ands	r7, r6
c0d00c50:	480f      	ldr	r0, [pc, #60]	; (c0d00c90 <io_usb_hid_receive+0x13c>)
c0d00c52:	6801      	ldr	r1, [r0, #0]
c0d00c54:	19c9      	adds	r1, r1, r7
c0d00c56:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_remaining_length -= l;
c0d00c58:	480c      	ldr	r0, [pc, #48]	; (c0d00c8c <io_usb_hid_receive+0x138>)
c0d00c5a:	6801      	ldr	r1, [r0, #0]
c0d00c5c:	1bc9      	subs	r1, r1, r7
c0d00c5e:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_sequence_number++;
c0d00c60:	6820      	ldr	r0, [r4, #0]
c0d00c62:	1c40      	adds	r0, r0, #1
c0d00c64:	6020      	str	r0, [r4, #0]
    // await for the next chunk
    goto apdu_reset;
  }

  // if more data to be received, notify it
  if (G_io_usb_hid_remaining_length) {
c0d00c66:	4809      	ldr	r0, [pc, #36]	; (c0d00c8c <io_usb_hid_receive+0x138>)
c0d00c68:	6801      	ldr	r1, [r0, #0]
c0d00c6a:	2001      	movs	r0, #1
c0d00c6c:	2402      	movs	r4, #2
c0d00c6e:	2900      	cmp	r1, #0
c0d00c70:	d103      	bne.n	c0d00c7a <io_usb_hid_receive+0x126>
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d00c72:	4804      	ldr	r0, [pc, #16]	; (c0d00c84 <io_usb_hid_receive+0x130>)
c0d00c74:	2100      	movs	r1, #0
c0d00c76:	6001      	str	r1, [r0, #0]
c0d00c78:	4620      	mov	r0, r4
  return IO_USB_APDU_RECEIVED;

apdu_reset:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}
c0d00c7a:	b2c0      	uxtb	r0, r0
c0d00c7c:	b001      	add	sp, #4
c0d00c7e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00c80:	20001ac0 	.word	0x20001ac0
c0d00c84:	200018ec 	.word	0x200018ec
c0d00c88:	0000ffff 	.word	0x0000ffff
c0d00c8c:	200018f4 	.word	0x200018f4
c0d00c90:	20001a4c 	.word	0x20001a4c
c0d00c94:	200018f0 	.word	0x200018f0
c0d00c98:	200018f8 	.word	0x200018f8
c0d00c9c:	20001a50 	.word	0x20001a50
c0d00ca0:	0001fff9 	.word	0x0001fff9

c0d00ca4 <os_memset>:
    }
  }
#undef DSTCHAR
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
c0d00ca4:	b580      	push	{r7, lr}
c0d00ca6:	460b      	mov	r3, r1
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
c0d00ca8:	2a00      	cmp	r2, #0
c0d00caa:	d003      	beq.n	c0d00cb4 <os_memset+0x10>
    DSTCHAR[length] = c;
c0d00cac:	4611      	mov	r1, r2
c0d00cae:	461a      	mov	r2, r3
c0d00cb0:	f003 fa80 	bl	c0d041b4 <__aeabi_memset>
  }
#undef DSTCHAR
}
c0d00cb4:	bd80      	pop	{r7, pc}

c0d00cb6 <os_memmove>:
  }
}

#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
c0d00cb6:	b5b0      	push	{r4, r5, r7, lr}
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d00cb8:	4288      	cmp	r0, r1
c0d00cba:	d90d      	bls.n	c0d00cd8 <os_memmove+0x22>
    while(length--) {
c0d00cbc:	2a00      	cmp	r2, #0
c0d00cbe:	d014      	beq.n	c0d00cea <os_memmove+0x34>
c0d00cc0:	1e49      	subs	r1, r1, #1
c0d00cc2:	4252      	negs	r2, r2
c0d00cc4:	1e40      	subs	r0, r0, #1
c0d00cc6:	2300      	movs	r3, #0
c0d00cc8:	43db      	mvns	r3, r3
      DSTCHAR[length] = SRCCHAR[length];
c0d00cca:	461c      	mov	r4, r3
c0d00ccc:	4354      	muls	r4, r2
c0d00cce:	5d0d      	ldrb	r5, [r1, r4]
c0d00cd0:	5505      	strb	r5, [r0, r4]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d00cd2:	1c52      	adds	r2, r2, #1
c0d00cd4:	d1f9      	bne.n	c0d00cca <os_memmove+0x14>
c0d00cd6:	e008      	b.n	c0d00cea <os_memmove+0x34>
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d00cd8:	2a00      	cmp	r2, #0
c0d00cda:	d006      	beq.n	c0d00cea <os_memmove+0x34>
c0d00cdc:	2300      	movs	r3, #0
      DSTCHAR[l] = SRCCHAR[l];
c0d00cde:	b29c      	uxth	r4, r3
c0d00ce0:	5d0d      	ldrb	r5, [r1, r4]
c0d00ce2:	5505      	strb	r5, [r0, r4]
      l++;
c0d00ce4:	1c5b      	adds	r3, r3, #1
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d00ce6:	1e52      	subs	r2, r2, #1
c0d00ce8:	d1f9      	bne.n	c0d00cde <os_memmove+0x28>
      DSTCHAR[l] = SRCCHAR[l];
      l++;
    }
  }
#undef DSTCHAR
}
c0d00cea:	bdb0      	pop	{r4, r5, r7, pc}

c0d00cec <io_usb_hid_init>:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d00cec:	4801      	ldr	r0, [pc, #4]	; (c0d00cf4 <io_usb_hid_init+0x8>)
c0d00cee:	2100      	movs	r1, #0
c0d00cf0:	6001      	str	r1, [r0, #0]
  //G_io_usb_hid_remaining_length = 0; // not really needed
  //G_io_usb_hid_total_length = 0; // not really needed
  //G_io_usb_hid_current_buffer = G_io_apdu_buffer; // not really needed
}
c0d00cf2:	4770      	bx	lr
c0d00cf4:	200018ec 	.word	0x200018ec

c0d00cf8 <io_usb_hid_sent>:

/**
 * sent the next io_usb_hid transport chunk (rx on the host, tx on the device)
 */
void io_usb_hid_sent(io_send_t sndfct) {
c0d00cf8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00cfa:	b081      	sub	sp, #4
  unsigned int l;

  // only prepare next chunk if some data to be sent remain
  if (G_io_usb_hid_remaining_length) {
c0d00cfc:	4f29      	ldr	r7, [pc, #164]	; (c0d00da4 <io_usb_hid_sent+0xac>)
c0d00cfe:	6839      	ldr	r1, [r7, #0]
c0d00d00:	2900      	cmp	r1, #0
c0d00d02:	d026      	beq.n	c0d00d52 <io_usb_hid_sent+0x5a>
c0d00d04:	9000      	str	r0, [sp, #0]
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d00d06:	4c28      	ldr	r4, [pc, #160]	; (c0d00da8 <io_usb_hid_sent+0xb0>)
c0d00d08:	1d66      	adds	r6, r4, #5
c0d00d0a:	2539      	movs	r5, #57	; 0x39
c0d00d0c:	4630      	mov	r0, r6
c0d00d0e:	4629      	mov	r1, r5
c0d00d10:	f003 fa46 	bl	c0d041a0 <__aeabi_memclr>
  if (G_io_usb_hid_remaining_length) {
    // fill the chunk
    os_memset(G_io_usb_ep_buffer, 0, IO_HID_EP_LENGTH-2);

    // keep the channel identifier
    G_io_usb_ep_buffer[0] = (G_io_usb_hid_channel>>8)&0xFF;
c0d00d14:	4825      	ldr	r0, [pc, #148]	; (c0d00dac <io_usb_hid_sent+0xb4>)
c0d00d16:	6801      	ldr	r1, [r0, #0]
c0d00d18:	0a09      	lsrs	r1, r1, #8
c0d00d1a:	7021      	strb	r1, [r4, #0]
    G_io_usb_ep_buffer[1] = G_io_usb_hid_channel&0xFF;
c0d00d1c:	6800      	ldr	r0, [r0, #0]
c0d00d1e:	7060      	strb	r0, [r4, #1]
c0d00d20:	2005      	movs	r0, #5
    G_io_usb_ep_buffer[2] = 0x05;
c0d00d22:	70a0      	strb	r0, [r4, #2]
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
c0d00d24:	4a22      	ldr	r2, [pc, #136]	; (c0d00db0 <io_usb_hid_sent+0xb8>)
c0d00d26:	6810      	ldr	r0, [r2, #0]
c0d00d28:	0a00      	lsrs	r0, r0, #8
c0d00d2a:	70e0      	strb	r0, [r4, #3]
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;
c0d00d2c:	6810      	ldr	r0, [r2, #0]
c0d00d2e:	7120      	strb	r0, [r4, #4]

    if (G_io_usb_hid_sequence_number == 0) {
c0d00d30:	6811      	ldr	r1, [r2, #0]
c0d00d32:	6838      	ldr	r0, [r7, #0]
c0d00d34:	2900      	cmp	r1, #0
c0d00d36:	d014      	beq.n	c0d00d62 <io_usb_hid_sent+0x6a>
c0d00d38:	4614      	mov	r4, r2
c0d00d3a:	253b      	movs	r5, #59	; 0x3b
      G_io_usb_hid_current_buffer += l;
      G_io_usb_hid_remaining_length -= l;
      l += 7;
    }
    else {
      l = ((G_io_usb_hid_remaining_length>IO_HID_EP_LENGTH-5) ? IO_HID_EP_LENGTH-5 : G_io_usb_hid_remaining_length);
c0d00d3c:	283b      	cmp	r0, #59	; 0x3b
c0d00d3e:	d800      	bhi.n	c0d00d42 <io_usb_hid_sent+0x4a>
c0d00d40:	683d      	ldr	r5, [r7, #0]
      os_memmove(G_io_usb_ep_buffer+5, (const void*)G_io_usb_hid_current_buffer, l);
c0d00d42:	481c      	ldr	r0, [pc, #112]	; (c0d00db4 <io_usb_hid_sent+0xbc>)
c0d00d44:	6801      	ldr	r1, [r0, #0]
c0d00d46:	4630      	mov	r0, r6
c0d00d48:	462a      	mov	r2, r5
c0d00d4a:	f7ff ffb4 	bl	c0d00cb6 <os_memmove>
c0d00d4e:	9a00      	ldr	r2, [sp, #0]
c0d00d50:	e018      	b.n	c0d00d84 <io_usb_hid_sent+0x8c>
    // always pad :)
    sndfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
  }
  // cleanup when everything has been sent (ack for the last sent usb in packet)
  else {
    G_io_usb_hid_sequence_number = 0; 
c0d00d52:	4817      	ldr	r0, [pc, #92]	; (c0d00db0 <io_usb_hid_sent+0xb8>)
c0d00d54:	2100      	movs	r1, #0
c0d00d56:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_current_buffer = NULL;
c0d00d58:	4816      	ldr	r0, [pc, #88]	; (c0d00db4 <io_usb_hid_sent+0xbc>)
c0d00d5a:	6001      	str	r1, [r0, #0]

    // we sent the whole response
    G_io_apdu_state = APDU_IDLE;
c0d00d5c:	4816      	ldr	r0, [pc, #88]	; (c0d00db8 <io_usb_hid_sent+0xc0>)
c0d00d5e:	7001      	strb	r1, [r0, #0]
c0d00d60:	e01d      	b.n	c0d00d9e <io_usb_hid_sent+0xa6>
c0d00d62:	4616      	mov	r6, r2
    G_io_usb_ep_buffer[2] = 0x05;
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;

    if (G_io_usb_hid_sequence_number == 0) {
      l = ((G_io_usb_hid_remaining_length>IO_HID_EP_LENGTH-7) ? IO_HID_EP_LENGTH-7 : G_io_usb_hid_remaining_length);
c0d00d64:	2839      	cmp	r0, #57	; 0x39
c0d00d66:	d800      	bhi.n	c0d00d6a <io_usb_hid_sent+0x72>
c0d00d68:	683d      	ldr	r5, [r7, #0]
      G_io_usb_ep_buffer[5] = G_io_usb_hid_remaining_length>>8;
c0d00d6a:	6838      	ldr	r0, [r7, #0]
c0d00d6c:	0a00      	lsrs	r0, r0, #8
c0d00d6e:	7160      	strb	r0, [r4, #5]
      G_io_usb_ep_buffer[6] = G_io_usb_hid_remaining_length;
c0d00d70:	6838      	ldr	r0, [r7, #0]
c0d00d72:	71a0      	strb	r0, [r4, #6]
      os_memmove(G_io_usb_ep_buffer+7, (const void*)G_io_usb_hid_current_buffer, l);
c0d00d74:	480f      	ldr	r0, [pc, #60]	; (c0d00db4 <io_usb_hid_sent+0xbc>)
c0d00d76:	6801      	ldr	r1, [r0, #0]
c0d00d78:	1de0      	adds	r0, r4, #7
c0d00d7a:	462a      	mov	r2, r5
c0d00d7c:	f7ff ff9b 	bl	c0d00cb6 <os_memmove>
c0d00d80:	9a00      	ldr	r2, [sp, #0]
c0d00d82:	4634      	mov	r4, r6
c0d00d84:	480b      	ldr	r0, [pc, #44]	; (c0d00db4 <io_usb_hid_sent+0xbc>)
c0d00d86:	6801      	ldr	r1, [r0, #0]
c0d00d88:	1949      	adds	r1, r1, r5
c0d00d8a:	6001      	str	r1, [r0, #0]
c0d00d8c:	6838      	ldr	r0, [r7, #0]
c0d00d8e:	1b40      	subs	r0, r0, r5
c0d00d90:	6038      	str	r0, [r7, #0]
      G_io_usb_hid_current_buffer += l;
      G_io_usb_hid_remaining_length -= l;
      l += 5;
    }
    // prepare next chunk numbering
    G_io_usb_hid_sequence_number++;
c0d00d92:	6820      	ldr	r0, [r4, #0]
c0d00d94:	1c40      	adds	r0, r0, #1
c0d00d96:	6020      	str	r0, [r4, #0]
    // send the chunk
    // always pad :)
    sndfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
c0d00d98:	4803      	ldr	r0, [pc, #12]	; (c0d00da8 <io_usb_hid_sent+0xb0>)
c0d00d9a:	2140      	movs	r1, #64	; 0x40
c0d00d9c:	4790      	blx	r2
    G_io_usb_hid_current_buffer = NULL;

    // we sent the whole response
    G_io_apdu_state = APDU_IDLE;
  }
}
c0d00d9e:	b001      	add	sp, #4
c0d00da0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00da2:	46c0      	nop			; (mov r8, r8)
c0d00da4:	200018f4 	.word	0x200018f4
c0d00da8:	20001ac0 	.word	0x20001ac0
c0d00dac:	20001a50 	.word	0x20001a50
c0d00db0:	200018ec 	.word	0x200018ec
c0d00db4:	20001a4c 	.word	0x20001a4c
c0d00db8:	20001a6a 	.word	0x20001a6a

c0d00dbc <io_usb_hid_send>:

void io_usb_hid_send(io_send_t sndfct, unsigned short sndlength) {
c0d00dbc:	b580      	push	{r7, lr}
  // perform send
  if (sndlength) {
c0d00dbe:	2900      	cmp	r1, #0
c0d00dc0:	d00b      	beq.n	c0d00dda <io_usb_hid_send+0x1e>
    G_io_usb_hid_sequence_number = 0; 
c0d00dc2:	4a06      	ldr	r2, [pc, #24]	; (c0d00ddc <io_usb_hid_send+0x20>)
c0d00dc4:	2300      	movs	r3, #0
c0d00dc6:	6013      	str	r3, [r2, #0]
    G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d00dc8:	4a05      	ldr	r2, [pc, #20]	; (c0d00de0 <io_usb_hid_send+0x24>)
c0d00dca:	4b06      	ldr	r3, [pc, #24]	; (c0d00de4 <io_usb_hid_send+0x28>)
c0d00dcc:	6013      	str	r3, [r2, #0]
    G_io_usb_hid_remaining_length = sndlength;
c0d00dce:	4a06      	ldr	r2, [pc, #24]	; (c0d00de8 <io_usb_hid_send+0x2c>)
c0d00dd0:	6011      	str	r1, [r2, #0]
    G_io_usb_hid_total_length = sndlength;
c0d00dd2:	4a06      	ldr	r2, [pc, #24]	; (c0d00dec <io_usb_hid_send+0x30>)
c0d00dd4:	6011      	str	r1, [r2, #0]
    io_usb_hid_sent(sndfct);
c0d00dd6:	f7ff ff8f 	bl	c0d00cf8 <io_usb_hid_sent>
  }
}
c0d00dda:	bd80      	pop	{r7, pc}
c0d00ddc:	200018ec 	.word	0x200018ec
c0d00de0:	20001a4c 	.word	0x20001a4c
c0d00de4:	200018f8 	.word	0x200018f8
c0d00de8:	200018f4 	.word	0x200018f4
c0d00dec:	200018f0 	.word	0x200018f0

c0d00df0 <os_memcmp>:
    DSTCHAR[length] = c;
  }
#undef DSTCHAR
}

char os_memcmp(const void WIDE * buf1, const void WIDE * buf2, unsigned int length) {
c0d00df0:	b570      	push	{r4, r5, r6, lr}
#define BUF1 ((unsigned char const WIDE *)buf1)
#define BUF2 ((unsigned char const WIDE *)buf2)
  while(length--) {
c0d00df2:	1e43      	subs	r3, r0, #1
c0d00df4:	1e49      	subs	r1, r1, #1
c0d00df6:	4252      	negs	r2, r2
c0d00df8:	2000      	movs	r0, #0
c0d00dfa:	43c4      	mvns	r4, r0
c0d00dfc:	2a00      	cmp	r2, #0
c0d00dfe:	d00c      	beq.n	c0d00e1a <os_memcmp+0x2a>
    if (BUF1[length] != BUF2[length]) {
c0d00e00:	4626      	mov	r6, r4
c0d00e02:	4356      	muls	r6, r2
c0d00e04:	5d8d      	ldrb	r5, [r1, r6]
c0d00e06:	5d9e      	ldrb	r6, [r3, r6]
c0d00e08:	1c52      	adds	r2, r2, #1
c0d00e0a:	42ae      	cmp	r6, r5
c0d00e0c:	d0f6      	beq.n	c0d00dfc <os_memcmp+0xc>
      return (BUF1[length] > BUF2[length])? 1:-1;
c0d00e0e:	2000      	movs	r0, #0
c0d00e10:	43c1      	mvns	r1, r0
c0d00e12:	2001      	movs	r0, #1
c0d00e14:	42ae      	cmp	r6, r5
c0d00e16:	d800      	bhi.n	c0d00e1a <os_memcmp+0x2a>
c0d00e18:	4608      	mov	r0, r1
  }
  return 0;
#undef BUF1
#undef BUF2

}
c0d00e1a:	b2c0      	uxtb	r0, r0
c0d00e1c:	bd70      	pop	{r4, r5, r6, pc}

c0d00e1e <os_longjmp>:
void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0d00e1e:	b580      	push	{r7, lr}
c0d00e20:	4601      	mov	r1, r0
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d00e22:	4648      	mov	r0, r9
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
  longjmp(try_context_get()->jmp_buf, exception);
c0d00e24:	f003 fa5e 	bl	c0d042e4 <longjmp>

c0d00e28 <try_context_get>:
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d00e28:	4648      	mov	r0, r9
  return current_ctx;
c0d00e2a:	4770      	bx	lr

c0d00e2c <try_context_get_previous>:
}

try_context_t* try_context_get_previous(void) {
c0d00e2c:	2000      	movs	r0, #0
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d00e2e:	4649      	mov	r1, r9

  // first context reached ?
  if (current_ctx == NULL) {
c0d00e30:	2900      	cmp	r1, #0
c0d00e32:	d000      	beq.n	c0d00e36 <try_context_get_previous+0xa>
  }

  // return r9 content saved on the current context. It links to the previous context.
  // r4 r5 r6 r7 r8 r9 r10 r11 sp lr
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
c0d00e34:	6948      	ldr	r0, [r1, #20]
}
c0d00e36:	4770      	bx	lr

c0d00e38 <io_seproxyhal_general_status>:

#ifndef IO_RAPDU_TRANSMIT_TIMEOUT_MS 
#define IO_RAPDU_TRANSMIT_TIMEOUT_MS 2000UL
#endif // IO_RAPDU_TRANSMIT_TIMEOUT_MS

void io_seproxyhal_general_status(void) {
c0d00e38:	b580      	push	{r7, lr}
  // avoid troubles
  if (io_seproxyhal_spi_is_status_sent()) {
c0d00e3a:	f001 f9e1 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d00e3e:	2800      	cmp	r0, #0
c0d00e40:	d10b      	bne.n	c0d00e5a <io_seproxyhal_general_status+0x22>
    return;
  }
  // send the general status
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_GENERAL_STATUS;
c0d00e42:	4806      	ldr	r0, [pc, #24]	; (c0d00e5c <io_seproxyhal_general_status+0x24>)
c0d00e44:	2160      	movs	r1, #96	; 0x60
c0d00e46:	7001      	strb	r1, [r0, #0]
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d00e48:	2100      	movs	r1, #0
c0d00e4a:	7041      	strb	r1, [r0, #1]
  G_io_seproxyhal_spi_buffer[2] = 2;
c0d00e4c:	2202      	movs	r2, #2
c0d00e4e:	7082      	strb	r2, [r0, #2]
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND>>8;
c0d00e50:	70c1      	strb	r1, [r0, #3]
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND;
c0d00e52:	7101      	strb	r1, [r0, #4]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
c0d00e54:	2105      	movs	r1, #5
c0d00e56:	f001 f9bd 	bl	c0d021d4 <io_seproxyhal_spi_send>
}
c0d00e5a:	bd80      	pop	{r7, pc}
c0d00e5c:	20001800 	.word	0x20001800

c0d00e60 <io_seproxyhal_handle_usb_event>:
} G_io_usb_ep_timeouts[IO_USB_MAX_ENDPOINTS];
#include "usbd_def.h"
#include "usbd_core.h"
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
c0d00e60:	b510      	push	{r4, lr}
  switch(G_io_seproxyhal_spi_buffer[3]) {
c0d00e62:	4819      	ldr	r0, [pc, #100]	; (c0d00ec8 <io_seproxyhal_handle_usb_event+0x68>)
c0d00e64:	78c0      	ldrb	r0, [r0, #3]
c0d00e66:	2803      	cmp	r0, #3
c0d00e68:	dc07      	bgt.n	c0d00e7a <io_seproxyhal_handle_usb_event+0x1a>
c0d00e6a:	2801      	cmp	r0, #1
c0d00e6c:	d00d      	beq.n	c0d00e8a <io_seproxyhal_handle_usb_event+0x2a>
c0d00e6e:	2802      	cmp	r0, #2
c0d00e70:	d126      	bne.n	c0d00ec0 <io_seproxyhal_handle_usb_event+0x60>
      }
      os_memset(G_io_usb_ep_xfer_len, 0, sizeof(G_io_usb_ep_xfer_len));
      os_memset(G_io_usb_ep_timeouts, 0, sizeof(G_io_usb_ep_timeouts));
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
c0d00e72:	4816      	ldr	r0, [pc, #88]	; (c0d00ecc <io_seproxyhal_handle_usb_event+0x6c>)
c0d00e74:	f002 fbd1 	bl	c0d0361a <USBD_LL_SOF>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d00e78:	bd10      	pop	{r4, pc}
c0d00e7a:	2804      	cmp	r0, #4
c0d00e7c:	d01d      	beq.n	c0d00eba <io_seproxyhal_handle_usb_event+0x5a>
c0d00e7e:	2808      	cmp	r0, #8
c0d00e80:	d11e      	bne.n	c0d00ec0 <io_seproxyhal_handle_usb_event+0x60>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
c0d00e82:	4812      	ldr	r0, [pc, #72]	; (c0d00ecc <io_seproxyhal_handle_usb_event+0x6c>)
c0d00e84:	f002 fbc7 	bl	c0d03616 <USBD_LL_Resume>
      break;
  }
}
c0d00e88:	bd10      	pop	{r4, pc}
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
  switch(G_io_seproxyhal_spi_buffer[3]) {
    case SEPROXYHAL_TAG_USB_EVENT_RESET:
      USBD_LL_SetSpeed(&USBD_Device, USBD_SPEED_FULL);  
c0d00e8a:	4c10      	ldr	r4, [pc, #64]	; (c0d00ecc <io_seproxyhal_handle_usb_event+0x6c>)
c0d00e8c:	2101      	movs	r1, #1
c0d00e8e:	4620      	mov	r0, r4
c0d00e90:	f002 fbbc 	bl	c0d0360c <USBD_LL_SetSpeed>
      USBD_LL_Reset(&USBD_Device);
c0d00e94:	4620      	mov	r0, r4
c0d00e96:	f002 fb98 	bl	c0d035ca <USBD_LL_Reset>
      // ongoing APDU detected, throw a reset, even if not the media. to avoid potential troubles.
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
c0d00e9a:	480d      	ldr	r0, [pc, #52]	; (c0d00ed0 <io_seproxyhal_handle_usb_event+0x70>)
c0d00e9c:	7800      	ldrb	r0, [r0, #0]
c0d00e9e:	2800      	cmp	r0, #0
c0d00ea0:	d10f      	bne.n	c0d00ec2 <io_seproxyhal_handle_usb_event+0x62>
        THROW(EXCEPTION_IO_RESET);
      }
      os_memset(G_io_usb_ep_xfer_len, 0, sizeof(G_io_usb_ep_xfer_len));
c0d00ea2:	480c      	ldr	r0, [pc, #48]	; (c0d00ed4 <io_seproxyhal_handle_usb_event+0x74>)
c0d00ea4:	2400      	movs	r4, #0
c0d00ea6:	2207      	movs	r2, #7
c0d00ea8:	4621      	mov	r1, r4
c0d00eaa:	f7ff fefb 	bl	c0d00ca4 <os_memset>
      os_memset(G_io_usb_ep_timeouts, 0, sizeof(G_io_usb_ep_timeouts));
c0d00eae:	480a      	ldr	r0, [pc, #40]	; (c0d00ed8 <io_seproxyhal_handle_usb_event+0x78>)
c0d00eb0:	220e      	movs	r2, #14
c0d00eb2:	4621      	mov	r1, r4
c0d00eb4:	f7ff fef6 	bl	c0d00ca4 <os_memset>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d00eb8:	bd10      	pop	{r4, pc}
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
c0d00eba:	4804      	ldr	r0, [pc, #16]	; (c0d00ecc <io_seproxyhal_handle_usb_event+0x6c>)
c0d00ebc:	f002 fba9 	bl	c0d03612 <USBD_LL_Suspend>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d00ec0:	bd10      	pop	{r4, pc}
    case SEPROXYHAL_TAG_USB_EVENT_RESET:
      USBD_LL_SetSpeed(&USBD_Device, USBD_SPEED_FULL);  
      USBD_LL_Reset(&USBD_Device);
      // ongoing APDU detected, throw a reset, even if not the media. to avoid potential troubles.
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
        THROW(EXCEPTION_IO_RESET);
c0d00ec2:	2010      	movs	r0, #16
c0d00ec4:	f7ff ffab 	bl	c0d00e1e <os_longjmp>
c0d00ec8:	20001800 	.word	0x20001800
c0d00ecc:	20001c8c 	.word	0x20001c8c
c0d00ed0:	20001a54 	.word	0x20001a54
c0d00ed4:	20001a55 	.word	0x20001a55
c0d00ed8:	20001a5c 	.word	0x20001a5c

c0d00edc <io_seproxyhal_get_ep_rx_size>:
      break;
  }
}

uint16_t io_seproxyhal_get_ep_rx_size(uint8_t epnum) {
  return G_io_usb_ep_xfer_len[epnum&0x7F];
c0d00edc:	217f      	movs	r1, #127	; 0x7f
c0d00ede:	4001      	ands	r1, r0
c0d00ee0:	4801      	ldr	r0, [pc, #4]	; (c0d00ee8 <io_seproxyhal_get_ep_rx_size+0xc>)
c0d00ee2:	5c40      	ldrb	r0, [r0, r1]
c0d00ee4:	4770      	bx	lr
c0d00ee6:	46c0      	nop			; (mov r8, r8)
c0d00ee8:	20001a55 	.word	0x20001a55

c0d00eec <io_seproxyhal_handle_usb_ep_xfer_event>:
}

void io_seproxyhal_handle_usb_ep_xfer_event(void) {
c0d00eec:	b510      	push	{r4, lr}
  switch(G_io_seproxyhal_spi_buffer[4]) {
c0d00eee:	4815      	ldr	r0, [pc, #84]	; (c0d00f44 <io_seproxyhal_handle_usb_ep_xfer_event+0x58>)
c0d00ef0:	7901      	ldrb	r1, [r0, #4]
c0d00ef2:	2904      	cmp	r1, #4
c0d00ef4:	d017      	beq.n	c0d00f26 <io_seproxyhal_handle_usb_ep_xfer_event+0x3a>
c0d00ef6:	2902      	cmp	r1, #2
c0d00ef8:	d006      	beq.n	c0d00f08 <io_seproxyhal_handle_usb_ep_xfer_event+0x1c>
c0d00efa:	2901      	cmp	r1, #1
c0d00efc:	d120      	bne.n	c0d00f40 <io_seproxyhal_handle_usb_ep_xfer_event+0x54>
    /* This event is received when a new SETUP token had been received on a control endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_SETUP:
      // assume length of setup packet, and that it is on endpoint 0
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
c0d00efe:	1d81      	adds	r1, r0, #6
c0d00f00:	4812      	ldr	r0, [pc, #72]	; (c0d00f4c <io_seproxyhal_handle_usb_ep_xfer_event+0x60>)
c0d00f02:	f002 fa5b 	bl	c0d033bc <USBD_LL_SetupStage>
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      }
      break;
  }
}
c0d00f06:	bd10      	pop	{r4, pc}
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
      break;

    /* This event is received after the prepare data packet has been flushed to the usb host */
    case SEPROXYHAL_TAG_USB_EP_XFER_IN:
      if ((G_io_seproxyhal_spi_buffer[3]&0x7F) < IO_USB_MAX_ENDPOINTS) {
c0d00f08:	78c2      	ldrb	r2, [r0, #3]
c0d00f0a:	217f      	movs	r1, #127	; 0x7f
c0d00f0c:	4011      	ands	r1, r2
c0d00f0e:	2906      	cmp	r1, #6
c0d00f10:	d816      	bhi.n	c0d00f40 <io_seproxyhal_handle_usb_ep_xfer_event+0x54>
c0d00f12:	b2c9      	uxtb	r1, r1
        // discard ep timeout as we received the sent packet confirmation
        G_io_usb_ep_timeouts[G_io_seproxyhal_spi_buffer[3]&0x7F].timeout = 0;
c0d00f14:	004a      	lsls	r2, r1, #1
c0d00f16:	4b0e      	ldr	r3, [pc, #56]	; (c0d00f50 <io_seproxyhal_handle_usb_ep_xfer_event+0x64>)
c0d00f18:	2400      	movs	r4, #0
c0d00f1a:	529c      	strh	r4, [r3, r2]
        // propagate sending ack of the data
        USBD_LL_DataInStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d00f1c:	1d82      	adds	r2, r0, #6
c0d00f1e:	480b      	ldr	r0, [pc, #44]	; (c0d00f4c <io_seproxyhal_handle_usb_ep_xfer_event+0x60>)
c0d00f20:	f002 fada 	bl	c0d034d8 <USBD_LL_DataInStage>
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      }
      break;
  }
}
c0d00f24:	bd10      	pop	{r4, pc}
      }
      break;

    /* This event is received when a new DATA token is received on an endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_OUT:
      if ((G_io_seproxyhal_spi_buffer[3]&0x7F) < IO_USB_MAX_ENDPOINTS) {
c0d00f26:	78c2      	ldrb	r2, [r0, #3]
c0d00f28:	217f      	movs	r1, #127	; 0x7f
c0d00f2a:	4011      	ands	r1, r2
c0d00f2c:	2906      	cmp	r1, #6
c0d00f2e:	d807      	bhi.n	c0d00f40 <io_seproxyhal_handle_usb_ep_xfer_event+0x54>
        // saved just in case it is needed ...
        G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
c0d00f30:	7942      	ldrb	r2, [r0, #5]
      }
      break;

    /* This event is received when a new DATA token is received on an endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_OUT:
      if ((G_io_seproxyhal_spi_buffer[3]&0x7F) < IO_USB_MAX_ENDPOINTS) {
c0d00f32:	b2c9      	uxtb	r1, r1
        // saved just in case it is needed ...
        G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
c0d00f34:	4b04      	ldr	r3, [pc, #16]	; (c0d00f48 <io_seproxyhal_handle_usb_ep_xfer_event+0x5c>)
c0d00f36:	545a      	strb	r2, [r3, r1]
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d00f38:	1d82      	adds	r2, r0, #6
c0d00f3a:	4804      	ldr	r0, [pc, #16]	; (c0d00f4c <io_seproxyhal_handle_usb_ep_xfer_event+0x60>)
c0d00f3c:	f002 fa6d 	bl	c0d0341a <USBD_LL_DataOutStage>
      }
      break;
  }
}
c0d00f40:	bd10      	pop	{r4, pc}
c0d00f42:	46c0      	nop			; (mov r8, r8)
c0d00f44:	20001800 	.word	0x20001800
c0d00f48:	20001a55 	.word	0x20001a55
c0d00f4c:	20001c8c 	.word	0x20001c8c
c0d00f50:	20001a5c 	.word	0x20001a5c

c0d00f54 <io_usb_send_ep>:
#endif // HAVE_L4_USBLIB

// TODO, refactor this using the USB DataIn event like for the U2F tunnel
// TODO add a blocking parameter, for HID KBD sending, or use a USB busy flag per channel to know if 
// the transfer has been processed or not. and move on to the next transfer on the same endpoint
void io_usb_send_ep(unsigned int ep, unsigned char* buffer, unsigned short length, unsigned int timeout) {
c0d00f54:	b570      	push	{r4, r5, r6, lr}
c0d00f56:	4615      	mov	r5, r2
c0d00f58:	460e      	mov	r6, r1
c0d00f5a:	4604      	mov	r4, r0
  if (timeout) {
    timeout++;
  }

  // won't send if overflowing seproxyhal buffer format
  if (length > 255) {
c0d00f5c:	2dff      	cmp	r5, #255	; 0xff
c0d00f5e:	d81a      	bhi.n	c0d00f96 <io_usb_send_ep+0x42>
    return;
  }
  
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d00f60:	480d      	ldr	r0, [pc, #52]	; (c0d00f98 <io_usb_send_ep+0x44>)
c0d00f62:	2150      	movs	r1, #80	; 0x50
c0d00f64:	7001      	strb	r1, [r0, #0]
  G_io_seproxyhal_spi_buffer[1] = (3+length)>>8;
c0d00f66:	1ce9      	adds	r1, r5, #3
c0d00f68:	0a0a      	lsrs	r2, r1, #8
c0d00f6a:	7042      	strb	r2, [r0, #1]
  G_io_seproxyhal_spi_buffer[2] = (3+length);
c0d00f6c:	7081      	strb	r1, [r0, #2]
  G_io_seproxyhal_spi_buffer[3] = ep|0x80;
c0d00f6e:	2180      	movs	r1, #128	; 0x80
c0d00f70:	4321      	orrs	r1, r4
c0d00f72:	70c1      	strb	r1, [r0, #3]
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d00f74:	2120      	movs	r1, #32
c0d00f76:	7101      	strb	r1, [r0, #4]
  G_io_seproxyhal_spi_buffer[5] = length;
c0d00f78:	7145      	strb	r5, [r0, #5]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 6);
c0d00f7a:	2106      	movs	r1, #6
c0d00f7c:	f001 f92a 	bl	c0d021d4 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(buffer, length);
c0d00f80:	4630      	mov	r0, r6
c0d00f82:	4629      	mov	r1, r5
c0d00f84:	f001 f926 	bl	c0d021d4 <io_seproxyhal_spi_send>
  // setup timeout of the endpoint
  G_io_usb_ep_timeouts[ep&0x7F].timeout = IO_RAPDU_TRANSMIT_TIMEOUT_MS;
c0d00f88:	207f      	movs	r0, #127	; 0x7f
c0d00f8a:	4020      	ands	r0, r4
c0d00f8c:	0040      	lsls	r0, r0, #1
c0d00f8e:	217d      	movs	r1, #125	; 0x7d
c0d00f90:	0109      	lsls	r1, r1, #4
c0d00f92:	4a02      	ldr	r2, [pc, #8]	; (c0d00f9c <io_usb_send_ep+0x48>)
c0d00f94:	5211      	strh	r1, [r2, r0]

}
c0d00f96:	bd70      	pop	{r4, r5, r6, pc}
c0d00f98:	20001800 	.word	0x20001800
c0d00f9c:	20001a5c 	.word	0x20001a5c

c0d00fa0 <io_usb_send_apdu_data>:

void io_usb_send_apdu_data(unsigned char* buffer, unsigned short length) {
c0d00fa0:	b580      	push	{r7, lr}
c0d00fa2:	460a      	mov	r2, r1
c0d00fa4:	4601      	mov	r1, r0
  // wait for 20 events before hanging up and timeout (~2 seconds of timeout)
  io_usb_send_ep(0x82, buffer, length, 20);
c0d00fa6:	2082      	movs	r0, #130	; 0x82
c0d00fa8:	2314      	movs	r3, #20
c0d00faa:	f7ff ffd3 	bl	c0d00f54 <io_usb_send_ep>
}
c0d00fae:	bd80      	pop	{r7, pc}

c0d00fb0 <io_usb_send_apdu_data_ep0x83>:

#ifdef HAVE_WEBUSB
void io_usb_send_apdu_data_ep0x83(unsigned char* buffer, unsigned short length) {
c0d00fb0:	b580      	push	{r7, lr}
c0d00fb2:	460a      	mov	r2, r1
c0d00fb4:	4601      	mov	r1, r0
  // wait for 20 events before hanging up and timeout (~2 seconds of timeout)
  io_usb_send_ep(0x83, buffer, length, 20);
c0d00fb6:	2083      	movs	r0, #131	; 0x83
c0d00fb8:	2314      	movs	r3, #20
c0d00fba:	f7ff ffcb 	bl	c0d00f54 <io_usb_send_ep>
}
c0d00fbe:	bd80      	pop	{r7, pc}

c0d00fc0 <io_seproxyhal_handle_capdu_event>:

}
#endif


void io_seproxyhal_handle_capdu_event(void) {
c0d00fc0:	b580      	push	{r7, lr}
  if(G_io_apdu_state == APDU_IDLE) 
c0d00fc2:	480d      	ldr	r0, [pc, #52]	; (c0d00ff8 <io_seproxyhal_handle_capdu_event+0x38>)
c0d00fc4:	7801      	ldrb	r1, [r0, #0]
c0d00fc6:	2900      	cmp	r1, #0
c0d00fc8:	d115      	bne.n	c0d00ff6 <io_seproxyhal_handle_capdu_event+0x36>
  {
    G_io_apdu_media = IO_APDU_MEDIA_RAW; // for application code
c0d00fca:	490c      	ldr	r1, [pc, #48]	; (c0d00ffc <io_seproxyhal_handle_capdu_event+0x3c>)
c0d00fcc:	2206      	movs	r2, #6
c0d00fce:	700a      	strb	r2, [r1, #0]
    G_io_apdu_state = APDU_RAW; // for next call to io_exchange
c0d00fd0:	210a      	movs	r1, #10
c0d00fd2:	7001      	strb	r1, [r0, #0]
    G_io_apdu_length = MIN(U2BE(G_io_seproxyhal_spi_buffer, 1), sizeof(G_io_apdu_buffer)); 
c0d00fd4:	480a      	ldr	r0, [pc, #40]	; (c0d01000 <io_seproxyhal_handle_capdu_event+0x40>)
c0d00fd6:	7882      	ldrb	r2, [r0, #2]
c0d00fd8:	7841      	ldrb	r1, [r0, #1]
c0d00fda:	0209      	lsls	r1, r1, #8
c0d00fdc:	4311      	orrs	r1, r2
c0d00fde:	22ff      	movs	r2, #255	; 0xff
c0d00fe0:	3252      	adds	r2, #82	; 0x52
c0d00fe2:	4291      	cmp	r1, r2
c0d00fe4:	d300      	bcc.n	c0d00fe8 <io_seproxyhal_handle_capdu_event+0x28>
c0d00fe6:	4611      	mov	r1, r2
c0d00fe8:	4a06      	ldr	r2, [pc, #24]	; (c0d01004 <io_seproxyhal_handle_capdu_event+0x44>)
c0d00fea:	8011      	strh	r1, [r2, #0]
    // copy apdu to apdu buffer
    os_memmove(G_io_apdu_buffer, G_io_seproxyhal_spi_buffer+3, G_io_apdu_length);
c0d00fec:	8812      	ldrh	r2, [r2, #0]
c0d00fee:	1cc1      	adds	r1, r0, #3
c0d00ff0:	4805      	ldr	r0, [pc, #20]	; (c0d01008 <io_seproxyhal_handle_capdu_event+0x48>)
c0d00ff2:	f7ff fe60 	bl	c0d00cb6 <os_memmove>
  }
}
c0d00ff6:	bd80      	pop	{r7, pc}
c0d00ff8:	20001a6a 	.word	0x20001a6a
c0d00ffc:	20001a54 	.word	0x20001a54
c0d01000:	20001800 	.word	0x20001800
c0d01004:	20001a6c 	.word	0x20001a6c
c0d01008:	200018f8 	.word	0x200018f8

c0d0100c <io_seproxyhal_handle_event>:

unsigned int io_seproxyhal_handle_event(void) {
c0d0100c:	b5b0      	push	{r4, r5, r7, lr}
  unsigned int rx_len = U2BE(G_io_seproxyhal_spi_buffer, 1);
c0d0100e:	481e      	ldr	r0, [pc, #120]	; (c0d01088 <io_seproxyhal_handle_event+0x7c>)
c0d01010:	7882      	ldrb	r2, [r0, #2]
c0d01012:	7841      	ldrb	r1, [r0, #1]
c0d01014:	0209      	lsls	r1, r1, #8
c0d01016:	4311      	orrs	r1, r2
c0d01018:	7800      	ldrb	r0, [r0, #0]

  switch(G_io_seproxyhal_spi_buffer[0]) {
c0d0101a:	280f      	cmp	r0, #15
c0d0101c:	dc09      	bgt.n	c0d01032 <io_seproxyhal_handle_event+0x26>
c0d0101e:	280e      	cmp	r0, #14
c0d01020:	d00e      	beq.n	c0d01040 <io_seproxyhal_handle_event+0x34>
c0d01022:	280f      	cmp	r0, #15
c0d01024:	d11f      	bne.n	c0d01066 <io_seproxyhal_handle_event+0x5a>
c0d01026:	2000      	movs	r0, #0
  #ifdef HAVE_IO_USB
    case SEPROXYHAL_TAG_USB_EVENT:
      if (rx_len != 1) {
c0d01028:	2901      	cmp	r1, #1
c0d0102a:	d126      	bne.n	c0d0107a <io_seproxyhal_handle_event+0x6e>
        return 0;
      }
      io_seproxyhal_handle_usb_event();
c0d0102c:	f7ff ff18 	bl	c0d00e60 <io_seproxyhal_handle_usb_event>
c0d01030:	e022      	b.n	c0d01078 <io_seproxyhal_handle_event+0x6c>
c0d01032:	2810      	cmp	r0, #16
c0d01034:	d01b      	beq.n	c0d0106e <io_seproxyhal_handle_event+0x62>
c0d01036:	2816      	cmp	r0, #22
c0d01038:	d115      	bne.n	c0d01066 <io_seproxyhal_handle_event+0x5a>
      }
      return 1;
  #endif // HAVE_BLE

    case SEPROXYHAL_TAG_CAPDU_EVENT:
      io_seproxyhal_handle_capdu_event();
c0d0103a:	f7ff ffc1 	bl	c0d00fc0 <io_seproxyhal_handle_capdu_event>
c0d0103e:	e01b      	b.n	c0d01078 <io_seproxyhal_handle_event+0x6c>
c0d01040:	2000      	movs	r0, #0
c0d01042:	4912      	ldr	r1, [pc, #72]	; (c0d0108c <io_seproxyhal_handle_event+0x80>)
      // process ticker events to timeout the IO transfers, and forward to the user io_event function too
#ifdef HAVE_IO_USB
      {
        unsigned int i = IO_USB_MAX_ENDPOINTS;
        while(i--) {
          if (G_io_usb_ep_timeouts[i].timeout) {
c0d01044:	1a0a      	subs	r2, r1, r0
c0d01046:	8993      	ldrh	r3, [r2, #12]
c0d01048:	2b00      	cmp	r3, #0
c0d0104a:	d009      	beq.n	c0d01060 <io_seproxyhal_handle_event+0x54>
            G_io_usb_ep_timeouts[i].timeout-=MIN(G_io_usb_ep_timeouts[i].timeout, 100);
c0d0104c:	2464      	movs	r4, #100	; 0x64
c0d0104e:	2b64      	cmp	r3, #100	; 0x64
c0d01050:	461d      	mov	r5, r3
c0d01052:	d300      	bcc.n	c0d01056 <io_seproxyhal_handle_event+0x4a>
c0d01054:	4625      	mov	r5, r4
c0d01056:	1b5b      	subs	r3, r3, r5
c0d01058:	8193      	strh	r3, [r2, #12]
c0d0105a:	4a0d      	ldr	r2, [pc, #52]	; (c0d01090 <io_seproxyhal_handle_event+0x84>)
            if (!G_io_usb_ep_timeouts[i].timeout) {
c0d0105c:	4213      	tst	r3, r2
c0d0105e:	d00d      	beq.n	c0d0107c <io_seproxyhal_handle_event+0x70>
    case SEPROXYHAL_TAG_TICKER_EVENT:
      // process ticker events to timeout the IO transfers, and forward to the user io_event function too
#ifdef HAVE_IO_USB
      {
        unsigned int i = IO_USB_MAX_ENDPOINTS;
        while(i--) {
c0d01060:	1c80      	adds	r0, r0, #2
c0d01062:	280e      	cmp	r0, #14
c0d01064:	d1ee      	bne.n	c0d01044 <io_seproxyhal_handle_event+0x38>
        }
      }
#endif // HAVE_IO_USB
      // no break is intentional
    default:
      return io_event(CHANNEL_SPI);
c0d01066:	2002      	movs	r0, #2
c0d01068:	f7ff f85a 	bl	c0d00120 <io_event>
  }
  // defaultly return as not processed
  return 0;
}
c0d0106c:	bdb0      	pop	{r4, r5, r7, pc}
c0d0106e:	2000      	movs	r0, #0
      }
      io_seproxyhal_handle_usb_event();
      return 1;

    case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
      if (rx_len < 3) {
c0d01070:	2903      	cmp	r1, #3
c0d01072:	d302      	bcc.n	c0d0107a <io_seproxyhal_handle_event+0x6e>
        // error !
        return 0;
      }
      io_seproxyhal_handle_usb_ep_xfer_event();
c0d01074:	f7ff ff3a 	bl	c0d00eec <io_seproxyhal_handle_usb_ep_xfer_event>
c0d01078:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaultly return as not processed
  return 0;
}
c0d0107a:	bdb0      	pop	{r4, r5, r7, pc}
        while(i--) {
          if (G_io_usb_ep_timeouts[i].timeout) {
            G_io_usb_ep_timeouts[i].timeout-=MIN(G_io_usb_ep_timeouts[i].timeout, 100);
            if (!G_io_usb_ep_timeouts[i].timeout) {
              // timeout !
              G_io_apdu_state = APDU_IDLE;
c0d0107c:	4805      	ldr	r0, [pc, #20]	; (c0d01094 <io_seproxyhal_handle_event+0x88>)
c0d0107e:	2100      	movs	r1, #0
c0d01080:	7001      	strb	r1, [r0, #0]
              THROW(EXCEPTION_IO_RESET);
c0d01082:	2010      	movs	r0, #16
c0d01084:	f7ff fecb 	bl	c0d00e1e <os_longjmp>
c0d01088:	20001800 	.word	0x20001800
c0d0108c:	20001a5c 	.word	0x20001a5c
c0d01090:	0000ffff 	.word	0x0000ffff
c0d01094:	20001a6a 	.word	0x20001a6a

c0d01098 <io_seproxyhal_init>:
#ifdef HAVE_BOLOS_APP_STACK_CANARY
#define APP_STACK_CANARY_MAGIC 0xDEAD0031
extern unsigned int app_stack_canary;
#endif // HAVE_BOLOS_APP_STACK_CANARY

void io_seproxyhal_init(void) {
c0d01098:	b510      	push	{r4, lr}
  // Enforce OS compatibility
  check_api_level(CX_COMPAT_APILEVEL);
c0d0109a:	2009      	movs	r0, #9
c0d0109c:	f000 ff1e 	bl	c0d01edc <check_api_level>

#ifdef HAVE_BOLOS_APP_STACK_CANARY
  app_stack_canary = APP_STACK_CANARY_MAGIC;
#endif // HAVE_BOLOS_APP_STACK_CANARY  

  G_io_apdu_state = APDU_IDLE;
c0d010a0:	4807      	ldr	r0, [pc, #28]	; (c0d010c0 <io_seproxyhal_init+0x28>)
c0d010a2:	2400      	movs	r4, #0
c0d010a4:	7004      	strb	r4, [r0, #0]
  G_io_apdu_length = 0;
c0d010a6:	4807      	ldr	r0, [pc, #28]	; (c0d010c4 <io_seproxyhal_init+0x2c>)
c0d010a8:	8004      	strh	r4, [r0, #0]
  G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d010aa:	4807      	ldr	r0, [pc, #28]	; (c0d010c8 <io_seproxyhal_init+0x30>)
c0d010ac:	7004      	strb	r4, [r0, #0]
  debug_apdus_offset = 0;
  #endif // DEBUG_APDU


  #ifdef HAVE_USB_APDU
  io_usb_hid_init();
c0d010ae:	f7ff fe1d 	bl	c0d00cec <io_usb_hid_init>
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d010b2:	4806      	ldr	r0, [pc, #24]	; (c0d010cc <io_seproxyhal_init+0x34>)
c0d010b4:	6004      	str	r4, [r0, #0]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d010b6:	4806      	ldr	r0, [pc, #24]	; (c0d010d0 <io_seproxyhal_init+0x38>)
c0d010b8:	6004      	str	r4, [r0, #0]
  G_button_same_mask_counter = 0;
c0d010ba:	4806      	ldr	r0, [pc, #24]	; (c0d010d4 <io_seproxyhal_init+0x3c>)
c0d010bc:	6004      	str	r4, [r0, #0]
  io_usb_hid_init();
  #endif // HAVE_USB_APDU

  io_seproxyhal_init_ux();
  io_seproxyhal_init_button();
}
c0d010be:	bd10      	pop	{r4, pc}
c0d010c0:	20001a6a 	.word	0x20001a6a
c0d010c4:	20001a6c 	.word	0x20001a6c
c0d010c8:	20001a54 	.word	0x20001a54
c0d010cc:	20001a70 	.word	0x20001a70
c0d010d0:	20001a74 	.word	0x20001a74
c0d010d4:	20001a78 	.word	0x20001a78

c0d010d8 <io_seproxyhal_init_ux>:

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d010d8:	4801      	ldr	r0, [pc, #4]	; (c0d010e0 <io_seproxyhal_init_ux+0x8>)
c0d010da:	2100      	movs	r1, #0
c0d010dc:	6001      	str	r1, [r0, #0]
}
c0d010de:	4770      	bx	lr
c0d010e0:	20001a70 	.word	0x20001a70

c0d010e4 <io_seproxyhal_init_button>:

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d010e4:	4802      	ldr	r0, [pc, #8]	; (c0d010f0 <io_seproxyhal_init_button+0xc>)
c0d010e6:	2100      	movs	r1, #0
c0d010e8:	6001      	str	r1, [r0, #0]
  G_button_same_mask_counter = 0;
c0d010ea:	4802      	ldr	r0, [pc, #8]	; (c0d010f4 <io_seproxyhal_init_button+0x10>)
c0d010ec:	6001      	str	r1, [r0, #0]
}
c0d010ee:	4770      	bx	lr
c0d010f0:	20001a74 	.word	0x20001a74
c0d010f4:	20001a78 	.word	0x20001a78

c0d010f8 <io_seproxyhal_touch_out>:

#ifdef HAVE_BAGL

unsigned int io_seproxyhal_touch_out(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d010f8:	b5b0      	push	{r4, r5, r7, lr}
c0d010fa:	460d      	mov	r5, r1
c0d010fc:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->out != NULL) {
c0d010fe:	6b20      	ldr	r0, [r4, #48]	; 0x30
c0d01100:	2800      	cmp	r0, #0
c0d01102:	d00c      	beq.n	c0d0111e <io_seproxyhal_touch_out+0x26>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->out))(element));
c0d01104:	f000 fed2 	bl	c0d01eac <pic>
c0d01108:	4601      	mov	r1, r0
c0d0110a:	4620      	mov	r0, r4
c0d0110c:	4788      	blx	r1
c0d0110e:	f000 fecd 	bl	c0d01eac <pic>
c0d01112:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (! el) {
c0d01114:	2800      	cmp	r0, #0
c0d01116:	d010      	beq.n	c0d0113a <io_seproxyhal_touch_out+0x42>
c0d01118:	2801      	cmp	r0, #1
c0d0111a:	d000      	beq.n	c0d0111e <io_seproxyhal_touch_out+0x26>
c0d0111c:	4604      	mov	r4, r0
      element = el;
    }
  }

  // out function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d0111e:	2d00      	cmp	r5, #0
c0d01120:	d007      	beq.n	c0d01132 <io_seproxyhal_touch_out+0x3a>
    el = before_display(element);
c0d01122:	4620      	mov	r0, r4
c0d01124:	47a8      	blx	r5
c0d01126:	2100      	movs	r1, #0
    if (!el) {
c0d01128:	2800      	cmp	r0, #0
c0d0112a:	d006      	beq.n	c0d0113a <io_seproxyhal_touch_out+0x42>
c0d0112c:	2801      	cmp	r0, #1
c0d0112e:	d000      	beq.n	c0d01132 <io_seproxyhal_touch_out+0x3a>
c0d01130:	4604      	mov	r4, r0
    if ((unsigned int)el != 1) {
      element = el;
    }
  }

  io_seproxyhal_display(element);
c0d01132:	4620      	mov	r0, r4
c0d01134:	f7fe fff0 	bl	c0d00118 <io_seproxyhal_display>
c0d01138:	2101      	movs	r1, #1
  return 1;
}
c0d0113a:	4608      	mov	r0, r1
c0d0113c:	bdb0      	pop	{r4, r5, r7, pc}

c0d0113e <io_seproxyhal_touch_over>:

unsigned int io_seproxyhal_touch_over(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d0113e:	b5b0      	push	{r4, r5, r7, lr}
c0d01140:	b08e      	sub	sp, #56	; 0x38
c0d01142:	460d      	mov	r5, r1
c0d01144:	4604      	mov	r4, r0
  bagl_element_t e;
  const bagl_element_t* el;
  if (element->over != NULL) {
c0d01146:	6b60      	ldr	r0, [r4, #52]	; 0x34
c0d01148:	2800      	cmp	r0, #0
c0d0114a:	d00c      	beq.n	c0d01166 <io_seproxyhal_touch_over+0x28>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->over))(element));
c0d0114c:	f000 feae 	bl	c0d01eac <pic>
c0d01150:	4601      	mov	r1, r0
c0d01152:	4620      	mov	r0, r4
c0d01154:	4788      	blx	r1
c0d01156:	f000 fea9 	bl	c0d01eac <pic>
c0d0115a:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (!el) {
c0d0115c:	2800      	cmp	r0, #0
c0d0115e:	d01b      	beq.n	c0d01198 <io_seproxyhal_touch_over+0x5a>
c0d01160:	2801      	cmp	r0, #1
c0d01162:	d000      	beq.n	c0d01166 <io_seproxyhal_touch_over+0x28>
c0d01164:	4604      	mov	r4, r0
      element = el;
    }
  }

  // over function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d01166:	2d00      	cmp	r5, #0
c0d01168:	d008      	beq.n	c0d0117c <io_seproxyhal_touch_over+0x3e>
    el = before_display(element);
c0d0116a:	4620      	mov	r0, r4
c0d0116c:	47a8      	blx	r5
c0d0116e:	466c      	mov	r4, sp
c0d01170:	2100      	movs	r1, #0
    element = &e;
    if (!el) {
c0d01172:	2800      	cmp	r0, #0
c0d01174:	d010      	beq.n	c0d01198 <io_seproxyhal_touch_over+0x5a>
c0d01176:	2801      	cmp	r0, #1
c0d01178:	d000      	beq.n	c0d0117c <io_seproxyhal_touch_over+0x3e>
c0d0117a:	4604      	mov	r4, r0
c0d0117c:	466d      	mov	r5, sp
      element = el;
    }
  }

  // swap colors
  os_memmove(&e, (void*)element, sizeof(bagl_element_t));
c0d0117e:	2238      	movs	r2, #56	; 0x38
c0d01180:	4628      	mov	r0, r5
c0d01182:	4621      	mov	r1, r4
c0d01184:	f7ff fd97 	bl	c0d00cb6 <os_memmove>
  e.component.fgcolor = element->overfgcolor;
c0d01188:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0d0118a:	9004      	str	r0, [sp, #16]
  e.component.bgcolor = element->overbgcolor;
c0d0118c:	6aa0      	ldr	r0, [r4, #40]	; 0x28
c0d0118e:	9005      	str	r0, [sp, #20]

  io_seproxyhal_display(&e);
c0d01190:	4628      	mov	r0, r5
c0d01192:	f7fe ffc1 	bl	c0d00118 <io_seproxyhal_display>
c0d01196:	2101      	movs	r1, #1
  return 1;
}
c0d01198:	4608      	mov	r0, r1
c0d0119a:	b00e      	add	sp, #56	; 0x38
c0d0119c:	bdb0      	pop	{r4, r5, r7, pc}

c0d0119e <io_seproxyhal_touch_tap>:

unsigned int io_seproxyhal_touch_tap(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d0119e:	b5b0      	push	{r4, r5, r7, lr}
c0d011a0:	460d      	mov	r5, r1
c0d011a2:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->tap != NULL) {
c0d011a4:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0d011a6:	2800      	cmp	r0, #0
c0d011a8:	d00c      	beq.n	c0d011c4 <io_seproxyhal_touch_tap+0x26>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->tap))(element));
c0d011aa:	f000 fe7f 	bl	c0d01eac <pic>
c0d011ae:	4601      	mov	r1, r0
c0d011b0:	4620      	mov	r0, r4
c0d011b2:	4788      	blx	r1
c0d011b4:	f000 fe7a 	bl	c0d01eac <pic>
c0d011b8:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (!el) {
c0d011ba:	2800      	cmp	r0, #0
c0d011bc:	d010      	beq.n	c0d011e0 <io_seproxyhal_touch_tap+0x42>
c0d011be:	2801      	cmp	r0, #1
c0d011c0:	d000      	beq.n	c0d011c4 <io_seproxyhal_touch_tap+0x26>
c0d011c2:	4604      	mov	r4, r0
      element = el;
    }
  }

  // tap function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d011c4:	2d00      	cmp	r5, #0
c0d011c6:	d007      	beq.n	c0d011d8 <io_seproxyhal_touch_tap+0x3a>
    el = before_display(element);
c0d011c8:	4620      	mov	r0, r4
c0d011ca:	47a8      	blx	r5
c0d011cc:	2100      	movs	r1, #0
    if (!el) {
c0d011ce:	2800      	cmp	r0, #0
c0d011d0:	d006      	beq.n	c0d011e0 <io_seproxyhal_touch_tap+0x42>
c0d011d2:	2801      	cmp	r0, #1
c0d011d4:	d000      	beq.n	c0d011d8 <io_seproxyhal_touch_tap+0x3a>
c0d011d6:	4604      	mov	r4, r0
    }
    if ((unsigned int)el != 1) {
      element = el;
    }
  }
  io_seproxyhal_display(element);
c0d011d8:	4620      	mov	r0, r4
c0d011da:	f7fe ff9d 	bl	c0d00118 <io_seproxyhal_display>
c0d011de:	2101      	movs	r1, #1
  return 1;
}
c0d011e0:	4608      	mov	r0, r1
c0d011e2:	bdb0      	pop	{r4, r5, r7, pc}

c0d011e4 <io_seproxyhal_touch_element_callback>:
  io_seproxyhal_touch_element_callback(elements, element_count, x, y, event_kind, NULL);  
}

// browse all elements and until an element has changed state, continue browsing
// return if processed or not
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
c0d011e4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d011e6:	b087      	sub	sp, #28
c0d011e8:	9302      	str	r3, [sp, #8]
c0d011ea:	9203      	str	r2, [sp, #12]
c0d011ec:	9105      	str	r1, [sp, #20]
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d011ee:	2900      	cmp	r1, #0
c0d011f0:	d077      	beq.n	c0d012e2 <io_seproxyhal_touch_element_callback+0xfe>
c0d011f2:	9004      	str	r0, [sp, #16]
c0d011f4:	980d      	ldr	r0, [sp, #52]	; 0x34
c0d011f6:	9001      	str	r0, [sp, #4]
c0d011f8:	980c      	ldr	r0, [sp, #48]	; 0x30
c0d011fa:	9000      	str	r0, [sp, #0]
c0d011fc:	2500      	movs	r5, #0
c0d011fe:	4b3c      	ldr	r3, [pc, #240]	; (c0d012f0 <io_seproxyhal_touch_element_callback+0x10c>)
c0d01200:	9506      	str	r5, [sp, #24]
c0d01202:	462f      	mov	r7, r5
c0d01204:	461e      	mov	r6, r3
    // process all components matching the x/y/w/h (no break) => fishy for the released out of zone
    // continue processing only if a status has not been sent
    if (io_seproxyhal_spi_is_status_sent()) {
c0d01206:	f000 fffb 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d0120a:	2800      	cmp	r0, #0
c0d0120c:	d155      	bne.n	c0d012ba <io_seproxyhal_touch_element_callback+0xd6>
      // continue instead of return to process all elemnts and therefore discard last touched element
      break;
    }

    // only perform out callback when element was in the current array, else, leave it be
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
c0d0120e:	2038      	movs	r0, #56	; 0x38
c0d01210:	4368      	muls	r0, r5
c0d01212:	9c04      	ldr	r4, [sp, #16]
c0d01214:	1825      	adds	r5, r4, r0
c0d01216:	4633      	mov	r3, r6
c0d01218:	681a      	ldr	r2, [r3, #0]
c0d0121a:	2101      	movs	r1, #1
c0d0121c:	4295      	cmp	r5, r2
c0d0121e:	d000      	beq.n	c0d01222 <io_seproxyhal_touch_element_callback+0x3e>
c0d01220:	9906      	ldr	r1, [sp, #24]
c0d01222:	9106      	str	r1, [sp, #24]
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d01224:	5620      	ldrsb	r0, [r4, r0]
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
c0d01226:	2800      	cmp	r0, #0
c0d01228:	da41      	bge.n	c0d012ae <io_seproxyhal_touch_element_callback+0xca>
c0d0122a:	2020      	movs	r0, #32
c0d0122c:	5c28      	ldrb	r0, [r5, r0]
c0d0122e:	2102      	movs	r1, #2
c0d01230:	5e69      	ldrsh	r1, [r5, r1]
c0d01232:	1a0a      	subs	r2, r1, r0
c0d01234:	9c03      	ldr	r4, [sp, #12]
c0d01236:	42a2      	cmp	r2, r4
c0d01238:	dc39      	bgt.n	c0d012ae <io_seproxyhal_touch_element_callback+0xca>
c0d0123a:	1841      	adds	r1, r0, r1
c0d0123c:	88ea      	ldrh	r2, [r5, #6]
c0d0123e:	1889      	adds	r1, r1, r2
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {
c0d01240:	9a03      	ldr	r2, [sp, #12]
c0d01242:	428a      	cmp	r2, r1
c0d01244:	da33      	bge.n	c0d012ae <io_seproxyhal_touch_element_callback+0xca>
c0d01246:	2104      	movs	r1, #4
c0d01248:	5e6c      	ldrsh	r4, [r5, r1]
c0d0124a:	1a22      	subs	r2, r4, r0
c0d0124c:	9902      	ldr	r1, [sp, #8]
c0d0124e:	428a      	cmp	r2, r1
c0d01250:	dc2d      	bgt.n	c0d012ae <io_seproxyhal_touch_element_callback+0xca>
c0d01252:	1820      	adds	r0, r4, r0
c0d01254:	8929      	ldrh	r1, [r5, #8]
c0d01256:	1840      	adds	r0, r0, r1
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d01258:	9902      	ldr	r1, [sp, #8]
c0d0125a:	4281      	cmp	r1, r0
c0d0125c:	da27      	bge.n	c0d012ae <io_seproxyhal_touch_element_callback+0xca>
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d0125e:	6818      	ldr	r0, [r3, #0]
              && G_bagl_last_touched_not_released_component != NULL) {
c0d01260:	4285      	cmp	r5, r0
c0d01262:	d010      	beq.n	c0d01286 <io_seproxyhal_touch_element_callback+0xa2>
c0d01264:	6818      	ldr	r0, [r3, #0]
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d01266:	2800      	cmp	r0, #0
c0d01268:	d00d      	beq.n	c0d01286 <io_seproxyhal_touch_element_callback+0xa2>
              && G_bagl_last_touched_not_released_component != NULL) {
        // only out the previous element if the newly matching will be displayed 
        if (!before_display || before_display(&elements[comp_idx])) {
c0d0126a:	9801      	ldr	r0, [sp, #4]
c0d0126c:	2800      	cmp	r0, #0
c0d0126e:	d005      	beq.n	c0d0127c <io_seproxyhal_touch_element_callback+0x98>
c0d01270:	4628      	mov	r0, r5
c0d01272:	9901      	ldr	r1, [sp, #4]
c0d01274:	4788      	blx	r1
c0d01276:	4633      	mov	r3, r6
c0d01278:	2800      	cmp	r0, #0
c0d0127a:	d018      	beq.n	c0d012ae <io_seproxyhal_touch_element_callback+0xca>
          if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d0127c:	6818      	ldr	r0, [r3, #0]
c0d0127e:	9901      	ldr	r1, [sp, #4]
c0d01280:	f7ff ff3a 	bl	c0d010f8 <io_seproxyhal_touch_out>
c0d01284:	e008      	b.n	c0d01298 <io_seproxyhal_touch_element_callback+0xb4>
c0d01286:	9800      	ldr	r0, [sp, #0]
        continue;
      }
      */
      
      // callback the hal to notify the component impacted by the user input
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_RELEASE) {
c0d01288:	2801      	cmp	r0, #1
c0d0128a:	d009      	beq.n	c0d012a0 <io_seproxyhal_touch_element_callback+0xbc>
c0d0128c:	2802      	cmp	r0, #2
c0d0128e:	d10e      	bne.n	c0d012ae <io_seproxyhal_touch_element_callback+0xca>
        if (io_seproxyhal_touch_tap(&elements[comp_idx], before_display)) {
c0d01290:	4628      	mov	r0, r5
c0d01292:	9901      	ldr	r1, [sp, #4]
c0d01294:	f7ff ff83 	bl	c0d0119e <io_seproxyhal_touch_tap>
c0d01298:	4633      	mov	r3, r6
c0d0129a:	2800      	cmp	r0, #0
c0d0129c:	d007      	beq.n	c0d012ae <io_seproxyhal_touch_element_callback+0xca>
c0d0129e:	e022      	b.n	c0d012e6 <io_seproxyhal_touch_element_callback+0x102>
          return;
        }
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
c0d012a0:	4628      	mov	r0, r5
c0d012a2:	9901      	ldr	r1, [sp, #4]
c0d012a4:	f7ff ff4b 	bl	c0d0113e <io_seproxyhal_touch_over>
c0d012a8:	4633      	mov	r3, r6
c0d012aa:	2800      	cmp	r0, #0
c0d012ac:	d11e      	bne.n	c0d012ec <io_seproxyhal_touch_element_callback+0x108>
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d012ae:	1c7f      	adds	r7, r7, #1
c0d012b0:	b2fd      	uxtb	r5, r7
c0d012b2:	9805      	ldr	r0, [sp, #20]
c0d012b4:	4285      	cmp	r5, r0
c0d012b6:	d3a5      	bcc.n	c0d01204 <io_seproxyhal_touch_element_callback+0x20>
c0d012b8:	e000      	b.n	c0d012bc <io_seproxyhal_touch_element_callback+0xd8>
c0d012ba:	4633      	mov	r3, r6
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
    && G_bagl_last_touched_not_released_component != NULL) {
c0d012bc:	9806      	ldr	r0, [sp, #24]
c0d012be:	0600      	lsls	r0, r0, #24
c0d012c0:	d00f      	beq.n	c0d012e2 <io_seproxyhal_touch_element_callback+0xfe>
c0d012c2:	6818      	ldr	r0, [r3, #0]
      }
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
c0d012c4:	2800      	cmp	r0, #0
c0d012c6:	d00c      	beq.n	c0d012e2 <io_seproxyhal_touch_element_callback+0xfe>
    && G_bagl_last_touched_not_released_component != NULL) {

    // we won't be able to notify the out, don't do it, in case a diplay refused the dra of the relased element and the position matched another element of the array (in autocomplete for example)
    if (io_seproxyhal_spi_is_status_sent()) {
c0d012c8:	f000 ff9a 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d012cc:	4631      	mov	r1, r6
c0d012ce:	2800      	cmp	r0, #0
c0d012d0:	d107      	bne.n	c0d012e2 <io_seproxyhal_touch_element_callback+0xfe>
      return;
    }
    
    if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d012d2:	6808      	ldr	r0, [r1, #0]
c0d012d4:	9901      	ldr	r1, [sp, #4]
c0d012d6:	f7ff ff0f 	bl	c0d010f8 <io_seproxyhal_touch_out>
c0d012da:	2800      	cmp	r0, #0
c0d012dc:	d001      	beq.n	c0d012e2 <io_seproxyhal_touch_element_callback+0xfe>
      // ok component out has been emitted
      G_bagl_last_touched_not_released_component = NULL;
c0d012de:	2000      	movs	r0, #0
c0d012e0:	6030      	str	r0, [r6, #0]
    }
  }

  // not processed
}
c0d012e2:	b007      	add	sp, #28
c0d012e4:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d012e6:	2000      	movs	r0, #0
c0d012e8:	6018      	str	r0, [r3, #0]
c0d012ea:	e7fa      	b.n	c0d012e2 <io_seproxyhal_touch_element_callback+0xfe>
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
          // remember the last touched component
          G_bagl_last_touched_not_released_component = (bagl_element_t*)&elements[comp_idx];
c0d012ec:	601d      	str	r5, [r3, #0]
c0d012ee:	e7f8      	b.n	c0d012e2 <io_seproxyhal_touch_element_callback+0xfe>
c0d012f0:	20001a70 	.word	0x20001a70

c0d012f4 <io_seproxyhal_display_icon>:
  // remaining length of bitmap bits to be displayed
  return len;
}
#endif // SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS

void io_seproxyhal_display_icon(bagl_component_t* icon_component, bagl_icon_details_t* icon_details) {
c0d012f4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d012f6:	b089      	sub	sp, #36	; 0x24
c0d012f8:	460c      	mov	r4, r1
c0d012fa:	4601      	mov	r1, r0
c0d012fc:	ad02      	add	r5, sp, #8
c0d012fe:	221c      	movs	r2, #28
  bagl_component_t icon_component_mod;
  // ensure not being out of bounds in the icon component agianst the declared icon real size
  os_memmove(&icon_component_mod, icon_component, sizeof(bagl_component_t));
c0d01300:	4628      	mov	r0, r5
c0d01302:	9201      	str	r2, [sp, #4]
c0d01304:	f7ff fcd7 	bl	c0d00cb6 <os_memmove>
  icon_component_mod.width = icon_details->width;
c0d01308:	6821      	ldr	r1, [r4, #0]
c0d0130a:	80e9      	strh	r1, [r5, #6]
  icon_component_mod.height = icon_details->height;
c0d0130c:	6862      	ldr	r2, [r4, #4]
c0d0130e:	812a      	strh	r2, [r5, #8]
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d01310:	68a0      	ldr	r0, [r4, #8]
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
                          +w; /* image bitmap size */
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d01312:	4f1a      	ldr	r7, [pc, #104]	; (c0d0137c <io_seproxyhal_display_icon+0x88>)
c0d01314:	2365      	movs	r3, #101	; 0x65
c0d01316:	703b      	strb	r3, [r7, #0]


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
c0d01318:	b292      	uxth	r2, r2
c0d0131a:	4342      	muls	r2, r0
c0d0131c:	b28b      	uxth	r3, r1
c0d0131e:	4353      	muls	r3, r2
c0d01320:	08d9      	lsrs	r1, r3, #3
c0d01322:	1c4e      	adds	r6, r1, #1
c0d01324:	2207      	movs	r2, #7
c0d01326:	4213      	tst	r3, r2
c0d01328:	d100      	bne.n	c0d0132c <io_seproxyhal_display_icon+0x38>
c0d0132a:	460e      	mov	r6, r1
c0d0132c:	4631      	mov	r1, r6
c0d0132e:	9100      	str	r1, [sp, #0]
c0d01330:	2604      	movs	r6, #4
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d01332:	4086      	lsls	r6, r0
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
c0d01334:	1870      	adds	r0, r6, r1
                          +w; /* image bitmap size */
c0d01336:	301d      	adds	r0, #29
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
  G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d01338:	0a01      	lsrs	r1, r0, #8
c0d0133a:	7079      	strb	r1, [r7, #1]
  G_io_seproxyhal_spi_buffer[2] = length;
c0d0133c:	70b8      	strb	r0, [r7, #2]
c0d0133e:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d01340:	4638      	mov	r0, r7
c0d01342:	f000 ff47 	bl	c0d021d4 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)icon_component, sizeof(bagl_component_t));
c0d01346:	4628      	mov	r0, r5
c0d01348:	9901      	ldr	r1, [sp, #4]
c0d0134a:	f000 ff43 	bl	c0d021d4 <io_seproxyhal_spi_send>
  G_io_seproxyhal_spi_buffer[0] = icon_details->bpp;
c0d0134e:	68a0      	ldr	r0, [r4, #8]
c0d01350:	7038      	strb	r0, [r7, #0]
c0d01352:	2101      	movs	r1, #1
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 1);
c0d01354:	4638      	mov	r0, r7
c0d01356:	f000 ff3d 	bl	c0d021d4 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->colors), h);
c0d0135a:	68e0      	ldr	r0, [r4, #12]
c0d0135c:	f000 fda6 	bl	c0d01eac <pic>
c0d01360:	b2b1      	uxth	r1, r6
c0d01362:	f000 ff37 	bl	c0d021d4 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->bitmap), w);
c0d01366:	9800      	ldr	r0, [sp, #0]
c0d01368:	b285      	uxth	r5, r0
c0d0136a:	6920      	ldr	r0, [r4, #16]
c0d0136c:	f000 fd9e 	bl	c0d01eac <pic>
c0d01370:	4629      	mov	r1, r5
c0d01372:	f000 ff2f 	bl	c0d021d4 <io_seproxyhal_spi_send>
#endif // !SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS
}
c0d01376:	b009      	add	sp, #36	; 0x24
c0d01378:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0137a:	46c0      	nop			; (mov r8, r8)
c0d0137c:	20001800 	.word	0x20001800

c0d01380 <io_seproxyhal_display_default>:

void io_seproxyhal_display_default(const bagl_element_t * element) {
c0d01380:	b570      	push	{r4, r5, r6, lr}
c0d01382:	4604      	mov	r4, r0
  // process automagically address from rom and from ram
  unsigned int type = (element->component.type & ~(BAGL_FLAG_TOUCHABLE));
c0d01384:	7820      	ldrb	r0, [r4, #0]
c0d01386:	267f      	movs	r6, #127	; 0x7f
c0d01388:	4006      	ands	r6, r0

  // avoid sending another status :), fixes a lot of bugs in the end
  if (io_seproxyhal_spi_is_status_sent()) {
c0d0138a:	f000 ff39 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d0138e:	2800      	cmp	r0, #0
c0d01390:	d130      	bne.n	c0d013f4 <io_seproxyhal_display_default+0x74>
c0d01392:	2e00      	cmp	r6, #0
c0d01394:	d02e      	beq.n	c0d013f4 <io_seproxyhal_display_default+0x74>
    return;
  }

  if (type != BAGL_NONE) {
    if (element->text != NULL) {
c0d01396:	69e0      	ldr	r0, [r4, #28]
c0d01398:	2800      	cmp	r0, #0
c0d0139a:	d01d      	beq.n	c0d013d8 <io_seproxyhal_display_default+0x58>
      unsigned int text_adr = PIC((unsigned int)element->text);
c0d0139c:	f000 fd86 	bl	c0d01eac <pic>
c0d013a0:	4605      	mov	r5, r0
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
c0d013a2:	2e05      	cmp	r6, #5
c0d013a4:	d102      	bne.n	c0d013ac <io_seproxyhal_display_default+0x2c>
c0d013a6:	7ea0      	ldrb	r0, [r4, #26]
c0d013a8:	2800      	cmp	r0, #0
c0d013aa:	d024      	beq.n	c0d013f6 <io_seproxyhal_display_default+0x76>
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d013ac:	4628      	mov	r0, r5
c0d013ae:	f002 ffa7 	bl	c0d04300 <strlen>
c0d013b2:	4606      	mov	r6, r0
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d013b4:	4812      	ldr	r0, [pc, #72]	; (c0d01400 <io_seproxyhal_display_default+0x80>)
c0d013b6:	2165      	movs	r1, #101	; 0x65
c0d013b8:	7001      	strb	r1, [r0, #0]
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d013ba:	4631      	mov	r1, r6
c0d013bc:	311c      	adds	r1, #28
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
        G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d013be:	0a0a      	lsrs	r2, r1, #8
c0d013c0:	7042      	strb	r2, [r0, #1]
        G_io_seproxyhal_spi_buffer[2] = length;
c0d013c2:	7081      	strb	r1, [r0, #2]
        io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d013c4:	2103      	movs	r1, #3
c0d013c6:	f000 ff05 	bl	c0d021d4 <io_seproxyhal_spi_send>
c0d013ca:	211c      	movs	r1, #28
        io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d013cc:	4620      	mov	r0, r4
c0d013ce:	f000 ff01 	bl	c0d021d4 <io_seproxyhal_spi_send>
        io_seproxyhal_spi_send((unsigned char*)text_adr, length-sizeof(bagl_component_t));
c0d013d2:	b2b1      	uxth	r1, r6
c0d013d4:	4628      	mov	r0, r5
c0d013d6:	e00b      	b.n	c0d013f0 <io_seproxyhal_display_default+0x70>
      }
    }
    else {
      unsigned short length = sizeof(bagl_component_t);
      G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d013d8:	4809      	ldr	r0, [pc, #36]	; (c0d01400 <io_seproxyhal_display_default+0x80>)
c0d013da:	2165      	movs	r1, #101	; 0x65
c0d013dc:	7001      	strb	r1, [r0, #0]
      G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d013de:	2100      	movs	r1, #0
c0d013e0:	7041      	strb	r1, [r0, #1]
c0d013e2:	251c      	movs	r5, #28
      G_io_seproxyhal_spi_buffer[2] = length;
c0d013e4:	7085      	strb	r5, [r0, #2]
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d013e6:	2103      	movs	r1, #3
c0d013e8:	f000 fef4 	bl	c0d021d4 <io_seproxyhal_spi_send>
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d013ec:	4620      	mov	r0, r4
c0d013ee:	4629      	mov	r1, r5
c0d013f0:	f000 fef0 	bl	c0d021d4 <io_seproxyhal_spi_send>
    }
  }
}
c0d013f4:	bd70      	pop	{r4, r5, r6, pc}
  if (type != BAGL_NONE) {
    if (element->text != NULL) {
      unsigned int text_adr = PIC((unsigned int)element->text);
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
c0d013f6:	4620      	mov	r0, r4
c0d013f8:	4629      	mov	r1, r5
c0d013fa:	f7ff ff7b 	bl	c0d012f4 <io_seproxyhal_display_icon>
      G_io_seproxyhal_spi_buffer[2] = length;
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
    }
  }
}
c0d013fe:	bd70      	pop	{r4, r5, r6, pc}
c0d01400:	20001800 	.word	0x20001800

c0d01404 <io_seproxyhal_button_push>:
  G_io_seproxyhal_spi_buffer[3] = (backlight_percentage?0x80:0)|(flags & 0x7F); // power on
  G_io_seproxyhal_spi_buffer[4] = backlight_percentage;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
}

void io_seproxyhal_button_push(button_push_callback_t button_callback, unsigned int new_button_mask) {
c0d01404:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01406:	b081      	sub	sp, #4
c0d01408:	4604      	mov	r4, r0
  if (button_callback) {
c0d0140a:	2c00      	cmp	r4, #0
c0d0140c:	d02b      	beq.n	c0d01466 <io_seproxyhal_button_push+0x62>
    unsigned int button_mask;
    unsigned int button_same_mask_counter;
    // enable speeded up long push
    if (new_button_mask == G_button_mask) {
c0d0140e:	4817      	ldr	r0, [pc, #92]	; (c0d0146c <io_seproxyhal_button_push+0x68>)
c0d01410:	6802      	ldr	r2, [r0, #0]
c0d01412:	428a      	cmp	r2, r1
c0d01414:	d103      	bne.n	c0d0141e <io_seproxyhal_button_push+0x1a>
      // each 100ms ~
      G_button_same_mask_counter++;
c0d01416:	4a16      	ldr	r2, [pc, #88]	; (c0d01470 <io_seproxyhal_button_push+0x6c>)
c0d01418:	6813      	ldr	r3, [r2, #0]
c0d0141a:	1c5b      	adds	r3, r3, #1
c0d0141c:	6013      	str	r3, [r2, #0]
    }

    // append the button mask
    button_mask = G_button_mask | new_button_mask;
c0d0141e:	6806      	ldr	r6, [r0, #0]
c0d01420:	430e      	orrs	r6, r1

    // pre reset variable due to os_sched_exit
    button_same_mask_counter = G_button_same_mask_counter;
c0d01422:	4a13      	ldr	r2, [pc, #76]	; (c0d01470 <io_seproxyhal_button_push+0x6c>)
c0d01424:	6815      	ldr	r5, [r2, #0]
c0d01426:	4f13      	ldr	r7, [pc, #76]	; (c0d01474 <io_seproxyhal_button_push+0x70>)

    // reset button mask
    if (new_button_mask == 0) {
c0d01428:	2900      	cmp	r1, #0
c0d0142a:	d001      	beq.n	c0d01430 <io_seproxyhal_button_push+0x2c>

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
    }
    else {
      G_button_mask = button_mask;
c0d0142c:	6006      	str	r6, [r0, #0]
c0d0142e:	e004      	b.n	c0d0143a <io_seproxyhal_button_push+0x36>
c0d01430:	2300      	movs	r3, #0
    button_same_mask_counter = G_button_same_mask_counter;

    // reset button mask
    if (new_button_mask == 0) {
      // reset next state when button are released
      G_button_mask = 0;
c0d01432:	6003      	str	r3, [r0, #0]
      G_button_same_mask_counter=0;
c0d01434:	6013      	str	r3, [r2, #0]

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
c0d01436:	1c7b      	adds	r3, r7, #1
c0d01438:	431e      	orrs	r6, r3
    else {
      G_button_mask = button_mask;
    }

    // reset counter when button mask changes
    if (new_button_mask != G_button_mask) {
c0d0143a:	6800      	ldr	r0, [r0, #0]
c0d0143c:	4288      	cmp	r0, r1
c0d0143e:	d001      	beq.n	c0d01444 <io_seproxyhal_button_push+0x40>
      G_button_same_mask_counter=0;
c0d01440:	2000      	movs	r0, #0
c0d01442:	6010      	str	r0, [r2, #0]
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
c0d01444:	2d08      	cmp	r5, #8
c0d01446:	d30b      	bcc.n	c0d01460 <io_seproxyhal_button_push+0x5c>
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d01448:	2103      	movs	r1, #3
c0d0144a:	4628      	mov	r0, r5
c0d0144c:	f002 fea2 	bl	c0d04194 <__aeabi_uidivmod>
        button_mask |= BUTTON_EVT_FAST;
c0d01450:	2001      	movs	r0, #1
c0d01452:	0780      	lsls	r0, r0, #30
c0d01454:	4330      	orrs	r0, r6
      G_button_same_mask_counter=0;
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d01456:	2900      	cmp	r1, #0
c0d01458:	d000      	beq.n	c0d0145c <io_seproxyhal_button_push+0x58>
c0d0145a:	4630      	mov	r0, r6
      }
      */

      // discard the release event after a fastskip has been detected, to avoid strange at release behavior
      // and also to enable user to cancel an operation by starting triggering the fast skip
      button_mask &= ~BUTTON_EVT_RELEASED;
c0d0145c:	4038      	ands	r0, r7
c0d0145e:	e000      	b.n	c0d01462 <io_seproxyhal_button_push+0x5e>
c0d01460:	4630      	mov	r0, r6
    }

    // indicate if button have been released
    button_callback(button_mask, button_same_mask_counter);
c0d01462:	4629      	mov	r1, r5
c0d01464:	47a0      	blx	r4
  }
}
c0d01466:	b001      	add	sp, #4
c0d01468:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0146a:	46c0      	nop			; (mov r8, r8)
c0d0146c:	20001a74 	.word	0x20001a74
c0d01470:	20001a78 	.word	0x20001a78
c0d01474:	7fffffff 	.word	0x7fffffff

c0d01478 <os_io_seproxyhal_get_app_name_and_version>:
#ifdef HAVE_IO_U2F
u2f_service_t G_io_u2f;
#endif // HAVE_IO_U2F

unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
c0d01478:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0147a:	b081      	sub	sp, #4
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d0147c:	4e0f      	ldr	r6, [pc, #60]	; (c0d014bc <os_io_seproxyhal_get_app_name_and_version+0x44>)
c0d0147e:	2401      	movs	r4, #1
c0d01480:	7034      	strb	r4, [r6, #0]

  // append app name
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPNAME, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d01482:	1cb1      	adds	r1, r6, #2
c0d01484:	27ff      	movs	r7, #255	; 0xff
c0d01486:	3750      	adds	r7, #80	; 0x50
c0d01488:	1c7a      	adds	r2, r7, #1
c0d0148a:	4620      	mov	r0, r4
c0d0148c:	f000 fe8a 	bl	c0d021a4 <os_registry_get_current_app_tag>
c0d01490:	4605      	mov	r5, r0
  G_io_apdu_buffer[tx_len++] = len;
c0d01492:	7075      	strb	r5, [r6, #1]
  tx_len += len;
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d01494:	1b7a      	subs	r2, r7, r5
unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d01496:	1977      	adds	r7, r6, r5
  // append app name
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPNAME, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
  G_io_apdu_buffer[tx_len++] = len;
  tx_len += len;
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d01498:	1cf9      	adds	r1, r7, #3
c0d0149a:	2002      	movs	r0, #2
c0d0149c:	f000 fe82 	bl	c0d021a4 <os_registry_get_current_app_tag>
  G_io_apdu_buffer[tx_len++] = len;
c0d014a0:	70b8      	strb	r0, [r7, #2]
c0d014a2:	182d      	adds	r5, r5, r0
unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d014a4:	1976      	adds	r6, r6, r5
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
  G_io_apdu_buffer[tx_len++] = len;
  tx_len += len;
  // return OS flags to notify of platform's global state (pin lock etc)
  G_io_apdu_buffer[tx_len++] = 1; // flags length
c0d014a6:	70f4      	strb	r4, [r6, #3]
  G_io_apdu_buffer[tx_len++] = os_flags();
c0d014a8:	f000 fe66 	bl	c0d02178 <os_flags>
c0d014ac:	7130      	strb	r0, [r6, #4]

  // status words
  G_io_apdu_buffer[tx_len++] = 0x90;
c0d014ae:	2090      	movs	r0, #144	; 0x90
c0d014b0:	7170      	strb	r0, [r6, #5]
  G_io_apdu_buffer[tx_len++] = 0x00;
c0d014b2:	2000      	movs	r0, #0
c0d014b4:	71b0      	strb	r0, [r6, #6]
c0d014b6:	1de8      	adds	r0, r5, #7
  return tx_len;
c0d014b8:	b001      	add	sp, #4
c0d014ba:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d014bc:	200018f8 	.word	0x200018f8

c0d014c0 <io_exchange>:
}


unsigned short io_exchange(unsigned char channel, unsigned short tx_len) {
c0d014c0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d014c2:	b087      	sub	sp, #28
c0d014c4:	4602      	mov	r2, r0
  }
  after_debug:
#endif // DEBUG_APDU

reply_apdu:
  switch(channel&~(IO_FLAGS)) {
c0d014c6:	2007      	movs	r0, #7
c0d014c8:	4202      	tst	r2, r0
c0d014ca:	d006      	beq.n	c0d014da <io_exchange+0x1a>
c0d014cc:	4616      	mov	r6, r2
      }
    }
    break;

  default:
    return io_exchange_al(channel, tx_len);
c0d014ce:	b2f0      	uxtb	r0, r6
c0d014d0:	f7fe fdfa 	bl	c0d000c8 <io_exchange_al>
  }
}
c0d014d4:	b280      	uxth	r0, r0
c0d014d6:	b007      	add	sp, #28
c0d014d8:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d014da:	9003      	str	r0, [sp, #12]
c0d014dc:	487f      	ldr	r0, [pc, #508]	; (c0d016dc <io_exchange+0x21c>)
          goto reply_apdu; 
        }
        // exit app after replied
        else if (os_memcmp(G_io_apdu_buffer, "\xB0\xA7\x00\x00", 4) == 0) {
          tx_len = 0;
          G_io_apdu_buffer[tx_len++] = 0x90;
c0d014de:	9001      	str	r0, [sp, #4]
c0d014e0:	2083      	movs	r0, #131	; 0x83
c0d014e2:	9004      	str	r0, [sp, #16]
c0d014e4:	4c7e      	ldr	r4, [pc, #504]	; (c0d016e0 <io_exchange+0x220>)
c0d014e6:	4d80      	ldr	r5, [pc, #512]	; (c0d016e8 <io_exchange+0x228>)
c0d014e8:	4616      	mov	r6, r2
c0d014ea:	e011      	b.n	c0d01510 <io_exchange+0x50>
c0d014ec:	9804      	ldr	r0, [sp, #16]
c0d014ee:	300d      	adds	r0, #13
c0d014f0:	497e      	ldr	r1, [pc, #504]	; (c0d016ec <io_exchange+0x22c>)
c0d014f2:	7008      	strb	r0, [r1, #0]
          G_io_apdu_buffer[tx_len++] = 0x00;
c0d014f4:	704f      	strb	r7, [r1, #1]
c0d014f6:	9a06      	ldr	r2, [sp, #24]
          // exit app after replied
          channel |= IO_RESET_AFTER_REPLIED;
c0d014f8:	4316      	orrs	r6, r2
c0d014fa:	2102      	movs	r1, #2
  }
  after_debug:
#endif // DEBUG_APDU

reply_apdu:
  switch(channel&~(IO_FLAGS)) {
c0d014fc:	9803      	ldr	r0, [sp, #12]
c0d014fe:	4202      	tst	r2, r0
c0d01500:	4632      	mov	r2, r6
c0d01502:	d005      	beq.n	c0d01510 <io_exchange+0x50>
c0d01504:	e7e3      	b.n	c0d014ce <io_exchange+0xe>
      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
        // handle reserved apdus
        // get name and version
        if (os_memcmp(G_io_apdu_buffer, "\xB0\x01\x00\x00", 4) == 0) {
          tx_len = os_io_seproxyhal_get_app_name_and_version();
c0d01506:	f7ff ffb7 	bl	c0d01478 <os_io_seproxyhal_get_app_name_and_version>
c0d0150a:	4601      	mov	r1, r0
c0d0150c:	463a      	mov	r2, r7
c0d0150e:	463e      	mov	r6, r7
reply_apdu:
  switch(channel&~(IO_FLAGS)) {
  case CHANNEL_APDU:
    // TODO work up the spi state machine over the HAL proxy until an APDU is available

    if (tx_len && !(channel&IO_ASYNCH_REPLY)) {
c0d01510:	2310      	movs	r3, #16
c0d01512:	4013      	ands	r3, r2
c0d01514:	b28f      	uxth	r7, r1
c0d01516:	2f00      	cmp	r7, #0
c0d01518:	9206      	str	r2, [sp, #24]
c0d0151a:	d100      	bne.n	c0d0151e <io_exchange+0x5e>
c0d0151c:	e091      	b.n	c0d01642 <io_exchange+0x182>
c0d0151e:	2b00      	cmp	r3, #0
c0d01520:	d000      	beq.n	c0d01524 <io_exchange+0x64>
c0d01522:	e08e      	b.n	c0d01642 <io_exchange+0x182>
c0d01524:	7820      	ldrb	r0, [r4, #0]
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
c0d01526:	2809      	cmp	r0, #9
c0d01528:	9305      	str	r3, [sp, #20]
c0d0152a:	dc3c      	bgt.n	c0d015a6 <io_exchange+0xe6>
c0d0152c:	2807      	cmp	r0, #7
c0d0152e:	d041      	beq.n	c0d015b4 <io_exchange+0xf4>
c0d01530:	2809      	cmp	r0, #9
c0d01532:	d15b      	bne.n	c0d015ec <io_exchange+0x12c>
c0d01534:	2100      	movs	r1, #0
c0d01536:	4e6b      	ldr	r6, [pc, #428]	; (c0d016e4 <io_exchange+0x224>)
          // case to handle U2F channels. u2f apdu to be dispatched in the upper layers
          case APDU_U2F:
            // prepare reply, the remaining segments will be pumped during USB/BLE events handling while waiting for the next APDU

            // the reply has been prepared by the application, stop sending anti timeouts
            u2f_message_set_autoreply_wait_user_presence(&G_io_u2f, false);
c0d01538:	4630      	mov	r0, r6
c0d0153a:	9102      	str	r1, [sp, #8]
c0d0153c:	f001 fb4a 	bl	c0d02bd4 <u2f_message_set_autoreply_wait_user_presence>

            // continue processing currently received command until completely received.
            while(!u2f_message_repliable(&G_io_u2f)) {
c0d01540:	4630      	mov	r0, r6
c0d01542:	f001 fb5a 	bl	c0d02bfa <u2f_message_repliable>
c0d01546:	2800      	cmp	r0, #0
c0d01548:	d10d      	bne.n	c0d01566 <io_exchange+0xa6>
              io_seproxyhal_general_status();
c0d0154a:	f7ff fc75 	bl	c0d00e38 <io_seproxyhal_general_status>
              io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d0154e:	2180      	movs	r1, #128	; 0x80
c0d01550:	2200      	movs	r2, #0
c0d01552:	4628      	mov	r0, r5
c0d01554:	f000 fe6a 	bl	c0d0222c <io_seproxyhal_spi_recv>
              // if packet is not well formed, then too bad ...
              io_seproxyhal_handle_event();
c0d01558:	f7ff fd58 	bl	c0d0100c <io_seproxyhal_handle_event>

            // the reply has been prepared by the application, stop sending anti timeouts
            u2f_message_set_autoreply_wait_user_presence(&G_io_u2f, false);

            // continue processing currently received command until completely received.
            while(!u2f_message_repliable(&G_io_u2f)) {
c0d0155c:	4630      	mov	r0, r6
c0d0155e:	f001 fb4c 	bl	c0d02bfa <u2f_message_repliable>
c0d01562:	2801      	cmp	r0, #1
c0d01564:	d1f1      	bne.n	c0d0154a <io_exchange+0x8a>
            }          

#ifdef U2F_PROXY_MAGIC

            // user presence + counter + rapdu + sw must fit the apdu buffer
            if (1U+ 4U+ tx_len +2U > sizeof(G_io_apdu_buffer)) {
c0d01566:	1dfe      	adds	r6, r7, #7
c0d01568:	0870      	lsrs	r0, r6, #1
c0d0156a:	28a9      	cmp	r0, #169	; 0xa9
c0d0156c:	d300      	bcc.n	c0d01570 <io_exchange+0xb0>
c0d0156e:	e0b1      	b.n	c0d016d4 <io_exchange+0x214>
              THROW(INVALID_PARAMETER);
            }

            // u2F tunnel needs the status words to be included in the signature response BLOB, do it now.
            // always return 9000 in the signature to avoid error @ transport level in u2f layers. 
            G_io_apdu_buffer[tx_len] = 0x90; //G_io_apdu_buffer[tx_len-2];
c0d01570:	9804      	ldr	r0, [sp, #16]
c0d01572:	300d      	adds	r0, #13
c0d01574:	495d      	ldr	r1, [pc, #372]	; (c0d016ec <io_exchange+0x22c>)
c0d01576:	55c8      	strb	r0, [r1, r7]
c0d01578:	19c8      	adds	r0, r1, r7
            G_io_apdu_buffer[tx_len+1] = 0x00; //G_io_apdu_buffer[tx_len-1];
c0d0157a:	9a02      	ldr	r2, [sp, #8]
c0d0157c:	7042      	strb	r2, [r0, #1]
            tx_len += 2;
            os_memmove(G_io_apdu_buffer+5, G_io_apdu_buffer, tx_len);
c0d0157e:	9801      	ldr	r0, [sp, #4]
c0d01580:	1d00      	adds	r0, r0, #4

            // u2F tunnel needs the status words to be included in the signature response BLOB, do it now.
            // always return 9000 in the signature to avoid error @ transport level in u2f layers. 
            G_io_apdu_buffer[tx_len] = 0x90; //G_io_apdu_buffer[tx_len-2];
            G_io_apdu_buffer[tx_len+1] = 0x00; //G_io_apdu_buffer[tx_len-1];
            tx_len += 2;
c0d01582:	1cba      	adds	r2, r7, #2
            os_memmove(G_io_apdu_buffer+5, G_io_apdu_buffer, tx_len);
c0d01584:	4002      	ands	r2, r0
c0d01586:	1d48      	adds	r0, r1, #5
c0d01588:	460f      	mov	r7, r1
c0d0158a:	f7ff fb94 	bl	c0d00cb6 <os_memmove>
c0d0158e:	2205      	movs	r2, #5
            // zeroize user presence and counter
            os_memset(G_io_apdu_buffer, 0, 5);
c0d01590:	4638      	mov	r0, r7
c0d01592:	9902      	ldr	r1, [sp, #8]
c0d01594:	f7ff fb86 	bl	c0d00ca4 <os_memset>
            u2f_message_reply(&G_io_u2f, U2F_CMD_MSG, G_io_apdu_buffer, tx_len+5);
c0d01598:	b2b3      	uxth	r3, r6
c0d0159a:	4852      	ldr	r0, [pc, #328]	; (c0d016e4 <io_exchange+0x224>)
c0d0159c:	9904      	ldr	r1, [sp, #16]
c0d0159e:	463a      	mov	r2, r7
c0d015a0:	f001 fb43 	bl	c0d02c2a <u2f_message_reply>
c0d015a4:	e034      	b.n	c0d01610 <io_exchange+0x150>
c0d015a6:	280a      	cmp	r0, #10
c0d015a8:	d00a      	beq.n	c0d015c0 <io_exchange+0x100>
c0d015aa:	280b      	cmp	r0, #11
c0d015ac:	d120      	bne.n	c0d015f0 <io_exchange+0x130>
            io_usb_ccid_reply(G_io_apdu_buffer, tx_len);
            goto break_send;
#endif // HAVE_USB_CLASS_CCID
#ifdef HAVE_WEBUSB
          case APDU_USB_WEBUSB:
            io_usb_hid_send(io_usb_send_apdu_data_ep0x83, tx_len);
c0d015ae:	4858      	ldr	r0, [pc, #352]	; (c0d01710 <io_exchange+0x250>)
c0d015b0:	4478      	add	r0, pc
c0d015b2:	e001      	b.n	c0d015b8 <io_exchange+0xf8>
            goto break_send;

#ifdef HAVE_USB_APDU
          case APDU_USB_HID:
            // only send, don't perform synchronous reception of the next command (will be done later by the seproxyhal packet processing)
            io_usb_hid_send(io_usb_send_apdu_data, tx_len);
c0d015b4:	4855      	ldr	r0, [pc, #340]	; (c0d0170c <io_exchange+0x24c>)
c0d015b6:	4478      	add	r0, pc
c0d015b8:	4639      	mov	r1, r7
c0d015ba:	f7ff fbff 	bl	c0d00dbc <io_usb_hid_send>
c0d015be:	e027      	b.n	c0d01610 <io_exchange+0x150>
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
            break;

          case APDU_RAW:
            if (tx_len > sizeof(G_io_apdu_buffer)) {
c0d015c0:	484b      	ldr	r0, [pc, #300]	; (c0d016f0 <io_exchange+0x230>)
c0d015c2:	4008      	ands	r0, r1
c0d015c4:	0840      	lsrs	r0, r0, #1
c0d015c6:	28a9      	cmp	r0, #169	; 0xa9
c0d015c8:	d300      	bcc.n	c0d015cc <io_exchange+0x10c>
c0d015ca:	e083      	b.n	c0d016d4 <io_exchange+0x214>
              THROW(INVALID_PARAMETER);
            }
            // reply the RAW APDU over SEPROXYHAL protocol
            G_io_seproxyhal_spi_buffer[0]  = SEPROXYHAL_TAG_RAPDU;
c0d015cc:	2053      	movs	r0, #83	; 0x53
c0d015ce:	7028      	strb	r0, [r5, #0]
            G_io_seproxyhal_spi_buffer[1]  = (tx_len)>>8;
c0d015d0:	0a38      	lsrs	r0, r7, #8
c0d015d2:	7068      	strb	r0, [r5, #1]
            G_io_seproxyhal_spi_buffer[2]  = (tx_len);
c0d015d4:	70a9      	strb	r1, [r5, #2]
            io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d015d6:	2103      	movs	r1, #3
c0d015d8:	4628      	mov	r0, r5
c0d015da:	f000 fdfb 	bl	c0d021d4 <io_seproxyhal_spi_send>
            io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d015de:	4843      	ldr	r0, [pc, #268]	; (c0d016ec <io_exchange+0x22c>)
c0d015e0:	4639      	mov	r1, r7
c0d015e2:	f000 fdf7 	bl	c0d021d4 <io_seproxyhal_spi_send>

            // isngle packet reply, mark immediate idle
            G_io_apdu_state = APDU_IDLE;
c0d015e6:	2000      	movs	r0, #0
c0d015e8:	7020      	strb	r0, [r4, #0]
c0d015ea:	e011      	b.n	c0d01610 <io_exchange+0x150>
c0d015ec:	2800      	cmp	r0, #0
c0d015ee:	d06e      	beq.n	c0d016ce <io_exchange+0x20e>
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
          default: 
            // delegate to the hal in case of not generic transport mode (or asynch)
            if (io_exchange_al(channel, tx_len) == 0) {
c0d015f0:	b2f0      	uxtb	r0, r6
c0d015f2:	4639      	mov	r1, r7
c0d015f4:	f7fe fd68 	bl	c0d000c8 <io_exchange_al>
c0d015f8:	2800      	cmp	r0, #0
c0d015fa:	d009      	beq.n	c0d01610 <io_exchange+0x150>
c0d015fc:	e067      	b.n	c0d016ce <io_exchange+0x20e>
        // wait end of reply transmission
        while (G_io_apdu_state != APDU_IDLE) {
#ifdef HAVE_TINY_COROUTINE
          tcr_yield();
#else // HAVE_TINY_COROUTINE
          io_seproxyhal_general_status();
c0d015fe:	f7ff fc1b 	bl	c0d00e38 <io_seproxyhal_general_status>
          io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d01602:	2180      	movs	r1, #128	; 0x80
c0d01604:	2200      	movs	r2, #0
c0d01606:	4628      	mov	r0, r5
c0d01608:	f000 fe10 	bl	c0d0222c <io_seproxyhal_spi_recv>
          // if packet is not well formed, then too bad ...
          io_seproxyhal_handle_event();
c0d0160c:	f7ff fcfe 	bl	c0d0100c <io_seproxyhal_handle_event>
c0d01610:	7820      	ldrb	r0, [r4, #0]
c0d01612:	2800      	cmp	r0, #0
c0d01614:	d1f3      	bne.n	c0d015fe <io_exchange+0x13e>
c0d01616:	2000      	movs	r0, #0
#endif // HAVE_TINY_COROUTINE
        }

        // reset apdu state
        G_io_apdu_state = APDU_IDLE;
c0d01618:	7020      	strb	r0, [r4, #0]
        G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d0161a:	4936      	ldr	r1, [pc, #216]	; (c0d016f4 <io_exchange+0x234>)
c0d0161c:	7008      	strb	r0, [r1, #0]

        G_io_apdu_length = 0;
c0d0161e:	4936      	ldr	r1, [pc, #216]	; (c0d016f8 <io_exchange+0x238>)
c0d01620:	8008      	strh	r0, [r1, #0]

        // continue sending commands, don't issue status yet
        if (channel & IO_RETURN_AFTER_TX) {
c0d01622:	9906      	ldr	r1, [sp, #24]
c0d01624:	0689      	lsls	r1, r1, #26
c0d01626:	d500      	bpl.n	c0d0162a <io_exchange+0x16a>
c0d01628:	e754      	b.n	c0d014d4 <io_exchange+0x14>
          return 0;
        }
        // acknowledge the write request (general status OK) and no more command to follow (wait until another APDU container is received to continue unwrapping)
        io_seproxyhal_general_status();
c0d0162a:	f7ff fc05 	bl	c0d00e38 <io_seproxyhal_general_status>
c0d0162e:	9a06      	ldr	r2, [sp, #24]
        break;
      }

      // perform reset after io exchange
      if (channel & IO_RESET_AFTER_REPLIED) {
c0d01630:	0610      	lsls	r0, r2, #24
c0d01632:	9b05      	ldr	r3, [sp, #20]
c0d01634:	d505      	bpl.n	c0d01642 <io_exchange+0x182>
        os_sched_exit(1);
c0d01636:	2001      	movs	r0, #1
c0d01638:	461e      	mov	r6, r3
c0d0163a:	f000 fd71 	bl	c0d02120 <os_sched_exit>
c0d0163e:	4633      	mov	r3, r6
c0d01640:	9a06      	ldr	r2, [sp, #24]
        //reset();
      }
    }

#ifndef HAVE_TINY_COROUTINE
    if (!(channel&IO_ASYNCH_REPLY)) {
c0d01642:	2b00      	cmp	r3, #0
c0d01644:	d105      	bne.n	c0d01652 <io_exchange+0x192>
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
c0d01646:	0650      	lsls	r0, r2, #25
c0d01648:	d43c      	bmi.n	c0d016c4 <io_exchange+0x204>
        // return apdu data - header
        return G_io_apdu_length-5;
      }

      // reply has ended, proceed to next apdu reception (reset status only after asynch reply)
      G_io_apdu_state = APDU_IDLE;
c0d0164a:	2000      	movs	r0, #0
c0d0164c:	7020      	strb	r0, [r4, #0]
      G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d0164e:	4929      	ldr	r1, [pc, #164]	; (c0d016f4 <io_exchange+0x234>)
c0d01650:	7008      	strb	r0, [r1, #0]
    }
#endif // HAVE_TINY_COROUTINE

    // reset the received apdu length
    G_io_apdu_length = 0;
c0d01652:	2000      	movs	r0, #0
c0d01654:	4928      	ldr	r1, [pc, #160]	; (c0d016f8 <io_exchange+0x238>)
c0d01656:	8008      	strh	r0, [r1, #0]
#ifdef HAVE_TINY_COROUTINE
      // give back hand to the seph task which interprets all incoming events first
      tcr_yield();
#else // HAVE_TINY_COROUTINE

      if (!io_seproxyhal_spi_is_status_sent()) {
c0d01658:	f000 fdd2 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d0165c:	2800      	cmp	r0, #0
c0d0165e:	d101      	bne.n	c0d01664 <io_exchange+0x1a4>
        io_seproxyhal_general_status();
c0d01660:	f7ff fbea 	bl	c0d00e38 <io_seproxyhal_general_status>
      }
      // wait until a SPI packet is available
      // NOTE: on ST31, dual wait ISO & RF (ISO instead of SPI)
      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d01664:	2680      	movs	r6, #128	; 0x80
c0d01666:	2700      	movs	r7, #0
c0d01668:	4628      	mov	r0, r5
c0d0166a:	4631      	mov	r1, r6
c0d0166c:	463a      	mov	r2, r7
c0d0166e:	f000 fddd 	bl	c0d0222c <io_seproxyhal_spi_recv>

      // can't process split TLV, continue
      if (rx_len < 3 && rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
c0d01672:	2802      	cmp	r0, #2
c0d01674:	d806      	bhi.n	c0d01684 <io_exchange+0x1c4>
c0d01676:	78a9      	ldrb	r1, [r5, #2]
c0d01678:	786a      	ldrb	r2, [r5, #1]
c0d0167a:	0212      	lsls	r2, r2, #8
c0d0167c:	430a      	orrs	r2, r1
c0d0167e:	1ec0      	subs	r0, r0, #3
c0d01680:	4290      	cmp	r0, r2
c0d01682:	d109      	bne.n	c0d01698 <io_exchange+0x1d8>
        G_io_apdu_state = APDU_IDLE;
        G_io_apdu_length = 0;
        continue;
      }

        io_seproxyhal_handle_event();
c0d01684:	f7ff fcc2 	bl	c0d0100c <io_seproxyhal_handle_event>
#endif // HAVE_TINY_COROUTINE

      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
c0d01688:	7820      	ldrb	r0, [r4, #0]
c0d0168a:	2800      	cmp	r0, #0
c0d0168c:	d0e4      	beq.n	c0d01658 <io_exchange+0x198>
c0d0168e:	481a      	ldr	r0, [pc, #104]	; (c0d016f8 <io_exchange+0x238>)
c0d01690:	8800      	ldrh	r0, [r0, #0]
c0d01692:	2800      	cmp	r0, #0
c0d01694:	d0e0      	beq.n	c0d01658 <io_exchange+0x198>
c0d01696:	e002      	b.n	c0d0169e <io_exchange+0x1de>
c0d01698:	2000      	movs	r0, #0
      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);

      // can't process split TLV, continue
      if (rx_len < 3 && rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
        LOG("invalid TLV format\n");
        G_io_apdu_state = APDU_IDLE;
c0d0169a:	7020      	strb	r0, [r4, #0]
c0d0169c:	e7da      	b.n	c0d01654 <io_exchange+0x194>

      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
        // handle reserved apdus
        // get name and version
        if (os_memcmp(G_io_apdu_buffer, "\xB0\x01\x00\x00", 4) == 0) {
c0d0169e:	2204      	movs	r2, #4
c0d016a0:	4812      	ldr	r0, [pc, #72]	; (c0d016ec <io_exchange+0x22c>)
c0d016a2:	a116      	add	r1, pc, #88	; (adr r1, c0d016fc <io_exchange+0x23c>)
c0d016a4:	f7ff fba4 	bl	c0d00df0 <os_memcmp>
c0d016a8:	2800      	cmp	r0, #0
c0d016aa:	d100      	bne.n	c0d016ae <io_exchange+0x1ee>
c0d016ac:	e72b      	b.n	c0d01506 <io_exchange+0x46>
          // disable 'return after tx' and 'asynch reply' flags
          channel &= ~IO_FLAGS;
          goto reply_apdu; 
        }
        // exit app after replied
        else if (os_memcmp(G_io_apdu_buffer, "\xB0\xA7\x00\x00", 4) == 0) {
c0d016ae:	2204      	movs	r2, #4
c0d016b0:	480e      	ldr	r0, [pc, #56]	; (c0d016ec <io_exchange+0x22c>)
c0d016b2:	a114      	add	r1, pc, #80	; (adr r1, c0d01704 <io_exchange+0x244>)
c0d016b4:	f7ff fb9c 	bl	c0d00df0 <os_memcmp>
c0d016b8:	2800      	cmp	r0, #0
c0d016ba:	d100      	bne.n	c0d016be <io_exchange+0x1fe>
c0d016bc:	e716      	b.n	c0d014ec <io_exchange+0x2c>
          // disable 'return after tx' and 'asynch reply' flags
          channel &= ~IO_FLAGS;
          goto reply_apdu; 
        }
#endif // HAVE_BOLOS_WITH_VIRGIN_ATTESTATION
        return G_io_apdu_length;
c0d016be:	480e      	ldr	r0, [pc, #56]	; (c0d016f8 <io_exchange+0x238>)
c0d016c0:	8800      	ldrh	r0, [r0, #0]
c0d016c2:	e707      	b.n	c0d014d4 <io_exchange+0x14>
    if (!(channel&IO_ASYNCH_REPLY)) {
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
        // return apdu data - header
        return G_io_apdu_length-5;
c0d016c4:	480c      	ldr	r0, [pc, #48]	; (c0d016f8 <io_exchange+0x238>)
c0d016c6:	8800      	ldrh	r0, [r0, #0]
c0d016c8:	9901      	ldr	r1, [sp, #4]
c0d016ca:	1840      	adds	r0, r0, r1
c0d016cc:	e702      	b.n	c0d014d4 <io_exchange+0x14>
            if (io_exchange_al(channel, tx_len) == 0) {
              goto break_send;
            }
          case APDU_IDLE:
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
c0d016ce:	2009      	movs	r0, #9
c0d016d0:	f7ff fba5 	bl	c0d00e1e <os_longjmp>
c0d016d4:	2002      	movs	r0, #2
c0d016d6:	f7ff fba2 	bl	c0d00e1e <os_longjmp>
c0d016da:	46c0      	nop			; (mov r8, r8)
c0d016dc:	0000fffb 	.word	0x0000fffb
c0d016e0:	20001a6a 	.word	0x20001a6a
c0d016e4:	20001a7c 	.word	0x20001a7c
c0d016e8:	20001800 	.word	0x20001800
c0d016ec:	200018f8 	.word	0x200018f8
c0d016f0:	0000fffe 	.word	0x0000fffe
c0d016f4:	20001a54 	.word	0x20001a54
c0d016f8:	20001a6c 	.word	0x20001a6c
c0d016fc:	000001b0 	.word	0x000001b0
c0d01700:	00000000 	.word	0x00000000
c0d01704:	0000a7b0 	.word	0x0000a7b0
c0d01708:	00000000 	.word	0x00000000
c0d0170c:	fffff9e7 	.word	0xfffff9e7
c0d01710:	fffff9fd 	.word	0xfffff9fd

c0d01714 <screen_printc>:

  return ret;
} 

// so unoptimized
void screen_printc(unsigned char c) {
c0d01714:	b5b0      	push	{r4, r5, r7, lr}
c0d01716:	b082      	sub	sp, #8
c0d01718:	ac01      	add	r4, sp, #4
  unsigned char buf[4];
  buf[0] = SEPROXYHAL_TAG_PRINTF_STATUS;
c0d0171a:	2166      	movs	r1, #102	; 0x66
c0d0171c:	7021      	strb	r1, [r4, #0]
c0d0171e:	2500      	movs	r5, #0
  buf[1] = 0;
c0d01720:	7065      	strb	r5, [r4, #1]
c0d01722:	2101      	movs	r1, #1
  buf[2] = 1;
c0d01724:	70a1      	strb	r1, [r4, #2]
  buf[3] = c;
c0d01726:	70e0      	strb	r0, [r4, #3]
  io_seproxyhal_spi_send(buf, 4);
c0d01728:	2104      	movs	r1, #4
c0d0172a:	4620      	mov	r0, r4
c0d0172c:	f000 fd52 	bl	c0d021d4 <io_seproxyhal_spi_send>
c0d01730:	2103      	movs	r1, #3
#ifndef IO_SEPROXYHAL_DEBUG
  // wait printf ack (no race kthx)
  io_seproxyhal_spi_recv(buf, 3, 0);
c0d01732:	4620      	mov	r0, r4
c0d01734:	462a      	mov	r2, r5
c0d01736:	f000 fd79 	bl	c0d0222c <io_seproxyhal_spi_recv>
  buf[0] = 0; // consume tag to avoid misinterpretation (due to IO_CACHE)
#endif // IO_SEPROXYHAL_DEBUG
}
c0d0173a:	b002      	add	sp, #8
c0d0173c:	bdb0      	pop	{r4, r5, r7, pc}

c0d0173e <ux_check_status_default>:
}

void ux_check_status_default(unsigned int status) {
  // nothing to be done here by default.
  UNUSED(status);
}
c0d0173e:	4770      	bx	lr

c0d01740 <screen_printf>:
 * - screen_prints
 * - screen_printc
 */


void screen_printf(const char* format, ...) {
c0d01740:	b083      	sub	sp, #12
c0d01742:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01744:	b08c      	sub	sp, #48	; 0x30
c0d01746:	4604      	mov	r4, r0
c0d01748:	a811      	add	r0, sp, #68	; 0x44
c0d0174a:	c00e      	stmia	r0!, {r1, r2, r3}
    char cStrlenSet;

    //
    // Check the arguments.
    //
    if(format == 0) {
c0d0174c:	2c00      	cmp	r4, #0
c0d0174e:	d100      	bne.n	c0d01752 <screen_printf+0x12>
c0d01750:	e18d      	b.n	c0d01a6e <screen_printf+0x32e>
c0d01752:	a811      	add	r0, sp, #68	; 0x44
    }

    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0d01754:	9007      	str	r0, [sp, #28]
c0d01756:	e186      	b.n	c0d01a66 <screen_printf+0x326>
c0d01758:	4625      	mov	r5, r4
c0d0175a:	2600      	movs	r6, #0
    while(*format)
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0d0175c:	4601      	mov	r1, r0
c0d0175e:	e002      	b.n	c0d01766 <screen_printf+0x26>
c0d01760:	19a9      	adds	r1, r5, r6
c0d01762:	7849      	ldrb	r1, [r1, #1]
            ulIdx++)
c0d01764:	1c76      	adds	r6, r6, #1
c0d01766:	b2ca      	uxtb	r2, r1
    while(*format)
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0d01768:	2a00      	cmp	r2, #0
c0d0176a:	d001      	beq.n	c0d01770 <screen_printf+0x30>
c0d0176c:	2a25      	cmp	r2, #37	; 0x25
c0d0176e:	d1f7      	bne.n	c0d01760 <screen_printf+0x20>

#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
c0d01770:	19ac      	adds	r4, r5, r6
c0d01772:	2e00      	cmp	r6, #0
c0d01774:	d00c      	beq.n	c0d01790 <screen_printf+0x50>
    screen_printc(*str++);
c0d01776:	b2c0      	uxtb	r0, r0
c0d01778:	f7ff ffcc 	bl	c0d01714 <screen_printc>

#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
c0d0177c:	2e01      	cmp	r6, #1
c0d0177e:	d006      	beq.n	c0d0178e <screen_printf+0x4e>
c0d01780:	2701      	movs	r7, #1
    screen_printc(*str++);
c0d01782:	5de8      	ldrb	r0, [r5, r7]
c0d01784:	f7ff ffc6 	bl	c0d01714 <screen_printc>

#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
c0d01788:	1c7f      	adds	r7, r7, #1
c0d0178a:	42b7      	cmp	r7, r6
c0d0178c:	d1f9      	bne.n	c0d01782 <screen_printf+0x42>
c0d0178e:	7821      	ldrb	r1, [r4, #0]
        format += ulIdx;

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0d01790:	b2c8      	uxtb	r0, r1
c0d01792:	2825      	cmp	r0, #37	; 0x25
c0d01794:	d000      	beq.n	c0d01798 <screen_printf+0x58>
c0d01796:	e166      	b.n	c0d01a66 <screen_printf+0x326>
            ulCount = 0;
            cFill = ' ';
            ulStrlen = 0;
            cStrlenSet = 0;
            ulCap = 0;
            ulBase = 10;
c0d01798:	19a8      	adds	r0, r5, r6
c0d0179a:	1c43      	adds	r3, r0, #1
c0d0179c:	2100      	movs	r1, #0
c0d0179e:	2020      	movs	r0, #32
c0d017a0:	9004      	str	r0, [sp, #16]
c0d017a2:	200a      	movs	r0, #10
c0d017a4:	9106      	str	r1, [sp, #24]
c0d017a6:	9103      	str	r1, [sp, #12]
c0d017a8:	9105      	str	r1, [sp, #20]
c0d017aa:	2204      	movs	r2, #4
c0d017ac:	43d5      	mvns	r5, r2
c0d017ae:	2202      	movs	r2, #2
c0d017b0:	461c      	mov	r4, r3
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0d017b2:	7823      	ldrb	r3, [r4, #0]
c0d017b4:	1c64      	adds	r4, r4, #1
c0d017b6:	2700      	movs	r7, #0
c0d017b8:	2b2d      	cmp	r3, #45	; 0x2d
c0d017ba:	dc0d      	bgt.n	c0d017d8 <screen_printf+0x98>
c0d017bc:	4639      	mov	r1, r7
c0d017be:	d0f8      	beq.n	c0d017b2 <screen_printf+0x72>
c0d017c0:	2b25      	cmp	r3, #37	; 0x25
c0d017c2:	d07f      	beq.n	c0d018c4 <screen_printf+0x184>
c0d017c4:	2b2a      	cmp	r3, #42	; 0x2a
c0d017c6:	d000      	beq.n	c0d017ca <screen_printf+0x8a>
c0d017c8:	e0fa      	b.n	c0d019c0 <screen_printf+0x280>
                  goto error;
                }
                
                case '*':
                {
                  if (*format == 's' ) {                    
c0d017ca:	7821      	ldrb	r1, [r4, #0]
c0d017cc:	2973      	cmp	r1, #115	; 0x73
c0d017ce:	d000      	beq.n	c0d017d2 <screen_printf+0x92>
c0d017d0:	e0f6      	b.n	c0d019c0 <screen_printf+0x280>
c0d017d2:	4611      	mov	r1, r2
c0d017d4:	4623      	mov	r3, r4
c0d017d6:	e04b      	b.n	c0d01870 <screen_printf+0x130>
c0d017d8:	2b47      	cmp	r3, #71	; 0x47
c0d017da:	dc14      	bgt.n	c0d01806 <screen_printf+0xc6>
c0d017dc:	461a      	mov	r2, r3
c0d017de:	3a30      	subs	r2, #48	; 0x30
c0d017e0:	2a0a      	cmp	r2, #10
c0d017e2:	d234      	bcs.n	c0d0184e <screen_printf+0x10e>
                {
                    //
                    // If this is a zero, and it is the first digit, then the
                    // fill character is a zero instead of a space.
                    //
                    if((format[-1] == '0') && (ulCount == 0))
c0d017e4:	2b30      	cmp	r3, #48	; 0x30
c0d017e6:	9d04      	ldr	r5, [sp, #16]
c0d017e8:	462a      	mov	r2, r5
c0d017ea:	d100      	bne.n	c0d017ee <screen_printf+0xae>
c0d017ec:	461a      	mov	r2, r3
c0d017ee:	9f05      	ldr	r7, [sp, #20]
c0d017f0:	2f00      	cmp	r7, #0
c0d017f2:	d000      	beq.n	c0d017f6 <screen_printf+0xb6>
c0d017f4:	462a      	mov	r2, r5
                    }

                    //
                    // Update the digit count.
                    //
                    ulCount *= 10;
c0d017f6:	250a      	movs	r5, #10
c0d017f8:	437d      	muls	r5, r7
                    ulCount += format[-1] - '0';
c0d017fa:	18eb      	adds	r3, r5, r3
c0d017fc:	3b30      	subs	r3, #48	; 0x30
c0d017fe:	9305      	str	r3, [sp, #20]
c0d01800:	9204      	str	r2, [sp, #16]
c0d01802:	4623      	mov	r3, r4
c0d01804:	e7d1      	b.n	c0d017aa <screen_printf+0x6a>
c0d01806:	2b67      	cmp	r3, #103	; 0x67
c0d01808:	dd04      	ble.n	c0d01814 <screen_printf+0xd4>
c0d0180a:	2b72      	cmp	r3, #114	; 0x72
c0d0180c:	dd08      	ble.n	c0d01820 <screen_printf+0xe0>
c0d0180e:	2b73      	cmp	r3, #115	; 0x73
c0d01810:	d134      	bne.n	c0d0187c <screen_printf+0x13c>
c0d01812:	e00a      	b.n	c0d0182a <screen_printf+0xea>
c0d01814:	2b62      	cmp	r3, #98	; 0x62
c0d01816:	dc36      	bgt.n	c0d01886 <screen_printf+0x146>
c0d01818:	2b48      	cmp	r3, #72	; 0x48
c0d0181a:	d143      	bne.n	c0d018a4 <screen_printf+0x164>
c0d0181c:	2001      	movs	r0, #1
c0d0181e:	e002      	b.n	c0d01826 <screen_printf+0xe6>
c0d01820:	2b68      	cmp	r3, #104	; 0x68
c0d01822:	d145      	bne.n	c0d018b0 <screen_printf+0x170>
c0d01824:	2000      	movs	r0, #0
c0d01826:	9003      	str	r0, [sp, #12]
c0d01828:	2010      	movs	r0, #16
                case_s:
                {
                    //
                    // Get the string pointer from the varargs.
                    //
                    pcStr = va_arg(vaArgP, char *);
c0d0182a:	9b07      	ldr	r3, [sp, #28]
c0d0182c:	1d1f      	adds	r7, r3, #4
c0d0182e:	9707      	str	r7, [sp, #28]
c0d01830:	2703      	movs	r7, #3
c0d01832:	4039      	ands	r1, r7
c0d01834:	1c52      	adds	r2, r2, #1
c0d01836:	681f      	ldr	r7, [r3, #0]

                    //
                    // Determine the length of the string. (if not specified using .*)
                    //
                    switch(cStrlenSet) {
c0d01838:	2901      	cmp	r1, #1
c0d0183a:	d100      	bne.n	c0d0183e <screen_printf+0xfe>
c0d0183c:	e0bb      	b.n	c0d019b6 <screen_printf+0x276>
c0d0183e:	2902      	cmp	r1, #2
c0d01840:	d100      	bne.n	c0d01844 <screen_printf+0x104>
c0d01842:	e0ba      	b.n	c0d019ba <screen_printf+0x27a>
c0d01844:	2903      	cmp	r1, #3
c0d01846:	4611      	mov	r1, r2
c0d01848:	4623      	mov	r3, r4
c0d0184a:	d0ae      	beq.n	c0d017aa <screen_printf+0x6a>
c0d0184c:	e0c1      	b.n	c0d019d2 <screen_printf+0x292>
c0d0184e:	2b2e      	cmp	r3, #46	; 0x2e
c0d01850:	d000      	beq.n	c0d01854 <screen_printf+0x114>
c0d01852:	e0b5      	b.n	c0d019c0 <screen_printf+0x280>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0d01854:	7821      	ldrb	r1, [r4, #0]
c0d01856:	292a      	cmp	r1, #42	; 0x2a
c0d01858:	d000      	beq.n	c0d0185c <screen_printf+0x11c>
c0d0185a:	e0b1      	b.n	c0d019c0 <screen_printf+0x280>
c0d0185c:	7862      	ldrb	r2, [r4, #1]
c0d0185e:	1c63      	adds	r3, r4, #1
c0d01860:	2101      	movs	r1, #1
c0d01862:	2a48      	cmp	r2, #72	; 0x48
c0d01864:	d004      	beq.n	c0d01870 <screen_printf+0x130>
c0d01866:	2a68      	cmp	r2, #104	; 0x68
c0d01868:	d002      	beq.n	c0d01870 <screen_printf+0x130>
c0d0186a:	2a73      	cmp	r2, #115	; 0x73
c0d0186c:	d000      	beq.n	c0d01870 <screen_printf+0x130>
c0d0186e:	e0a7      	b.n	c0d019c0 <screen_printf+0x280>
c0d01870:	9a07      	ldr	r2, [sp, #28]
c0d01872:	1d14      	adds	r4, r2, #4
c0d01874:	9407      	str	r4, [sp, #28]
c0d01876:	6812      	ldr	r2, [r2, #0]
 * - screen_prints
 * - screen_printc
 */


void screen_printf(const char* format, ...) {
c0d01878:	9206      	str	r2, [sp, #24]
c0d0187a:	e796      	b.n	c0d017aa <screen_printf+0x6a>
c0d0187c:	2b75      	cmp	r3, #117	; 0x75
c0d0187e:	d023      	beq.n	c0d018c8 <screen_printf+0x188>
c0d01880:	2b78      	cmp	r3, #120	; 0x78
c0d01882:	d018      	beq.n	c0d018b6 <screen_printf+0x176>
c0d01884:	e09c      	b.n	c0d019c0 <screen_printf+0x280>
c0d01886:	2b63      	cmp	r3, #99	; 0x63
c0d01888:	d100      	bne.n	c0d0188c <screen_printf+0x14c>
c0d0188a:	e08d      	b.n	c0d019a8 <screen_printf+0x268>
c0d0188c:	2b64      	cmp	r3, #100	; 0x64
c0d0188e:	d000      	beq.n	c0d01892 <screen_printf+0x152>
c0d01890:	e096      	b.n	c0d019c0 <screen_printf+0x280>
                case 'd':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01892:	9807      	ldr	r0, [sp, #28]
c0d01894:	1d01      	adds	r1, r0, #4
c0d01896:	9107      	str	r1, [sp, #28]
c0d01898:	6800      	ldr	r0, [r0, #0]
c0d0189a:	17c1      	asrs	r1, r0, #31
c0d0189c:	1842      	adds	r2, r0, r1
c0d0189e:	404a      	eors	r2, r1

                    //
                    // If the value is negative, make it positive and indicate
                    // that a minus sign is needed.
                    //
                    if((long)ulValue < 0)
c0d018a0:	0fc0      	lsrs	r0, r0, #31
c0d018a2:	e016      	b.n	c0d018d2 <screen_printf+0x192>
c0d018a4:	2b58      	cmp	r3, #88	; 0x58
c0d018a6:	d000      	beq.n	c0d018aa <screen_printf+0x16a>
c0d018a8:	e08a      	b.n	c0d019c0 <screen_printf+0x280>
c0d018aa:	2001      	movs	r0, #1

        screen_printc(str[i]);
    }
    */

    unsigned long ulIdx, ulValue, ulPos, ulCount, ulBase, ulNeg, ulStrlen, ulCap;
c0d018ac:	9003      	str	r0, [sp, #12]
c0d018ae:	e002      	b.n	c0d018b6 <screen_printf+0x176>
c0d018b0:	2b70      	cmp	r3, #112	; 0x70
c0d018b2:	d000      	beq.n	c0d018b6 <screen_printf+0x176>
c0d018b4:	e084      	b.n	c0d019c0 <screen_printf+0x280>
                case 'p':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d018b6:	9807      	ldr	r0, [sp, #28]
c0d018b8:	1d01      	adds	r1, r0, #4
c0d018ba:	9107      	str	r1, [sp, #28]
c0d018bc:	6802      	ldr	r2, [r0, #0]
c0d018be:	2000      	movs	r0, #0
c0d018c0:	2610      	movs	r6, #16
c0d018c2:	e007      	b.n	c0d018d4 <screen_printf+0x194>
#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
    screen_printc(*str++);
c0d018c4:	2025      	movs	r0, #37	; 0x25
c0d018c6:	e073      	b.n	c0d019b0 <screen_printf+0x270>
                case 'u':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d018c8:	9807      	ldr	r0, [sp, #28]
c0d018ca:	1d01      	adds	r1, r0, #4
c0d018cc:	9107      	str	r1, [sp, #28]
c0d018ce:	6802      	ldr	r2, [r0, #0]
c0d018d0:	2000      	movs	r0, #0
c0d018d2:	260a      	movs	r6, #10
c0d018d4:	9002      	str	r0, [sp, #8]
c0d018d6:	2701      	movs	r7, #1
c0d018d8:	9206      	str	r2, [sp, #24]
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
                        (((ulIdx * ulBase) <= ulValue) &&
c0d018da:	4296      	cmp	r6, r2
c0d018dc:	d812      	bhi.n	c0d01904 <screen_printf+0x1c4>
c0d018de:	2501      	movs	r5, #1
c0d018e0:	4630      	mov	r0, r6
c0d018e2:	4607      	mov	r7, r0
                         (((ulIdx * ulBase) / ulBase) == ulIdx));
c0d018e4:	4631      	mov	r1, r6
c0d018e6:	f002 fbcf 	bl	c0d04088 <__aeabi_uidiv>
                    //
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
c0d018ea:	42a8      	cmp	r0, r5
c0d018ec:	d109      	bne.n	c0d01902 <screen_printf+0x1c2>
                        (((ulIdx * ulBase) <= ulValue) &&
c0d018ee:	4630      	mov	r0, r6
c0d018f0:	4378      	muls	r0, r7
                         (((ulIdx * ulBase) / ulBase) == ulIdx));
                        ulIdx *= ulBase, ulCount--)
c0d018f2:	9905      	ldr	r1, [sp, #20]
c0d018f4:	1e49      	subs	r1, r1, #1
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
                        (((ulIdx * ulBase) <= ulValue) &&
c0d018f6:	9105      	str	r1, [sp, #20]
c0d018f8:	9906      	ldr	r1, [sp, #24]
c0d018fa:	4288      	cmp	r0, r1
c0d018fc:	463d      	mov	r5, r7
c0d018fe:	d9f0      	bls.n	c0d018e2 <screen_printf+0x1a2>
c0d01900:	e000      	b.n	c0d01904 <screen_printf+0x1c4>
c0d01902:	462f      	mov	r7, r5

                    //
                    // If the value is negative, reduce the count of padding
                    // characters needed.
                    //
                    if(ulNeg)
c0d01904:	2500      	movs	r5, #0
c0d01906:	43e9      	mvns	r1, r5
c0d01908:	9b02      	ldr	r3, [sp, #8]
c0d0190a:	2b00      	cmp	r3, #0
c0d0190c:	d100      	bne.n	c0d01910 <screen_printf+0x1d0>
c0d0190e:	4619      	mov	r1, r3
c0d01910:	9805      	ldr	r0, [sp, #20]
c0d01912:	9101      	str	r1, [sp, #4]
c0d01914:	1840      	adds	r0, r0, r1

                    //
                    // If the value is negative and the value is padded with
                    // zeros, then place the minus sign before the padding.
                    //
                    if(ulNeg && (cFill == '0'))
c0d01916:	9904      	ldr	r1, [sp, #16]
c0d01918:	b2ca      	uxtb	r2, r1
c0d0191a:	2a30      	cmp	r2, #48	; 0x30
c0d0191c:	d106      	bne.n	c0d0192c <screen_printf+0x1ec>
c0d0191e:	2b00      	cmp	r3, #0
c0d01920:	d004      	beq.n	c0d0192c <screen_printf+0x1ec>
c0d01922:	a908      	add	r1, sp, #32
                    {
                        //
                        // Place the minus sign in the output buffer.
                        //
                        pcBuf[ulPos++] = '-';
c0d01924:	232d      	movs	r3, #45	; 0x2d
c0d01926:	700b      	strb	r3, [r1, #0]
c0d01928:	2501      	movs	r5, #1
c0d0192a:	2300      	movs	r3, #0

                    //
                    // Provide additional padding at the beginning of the
                    // string conversion if needed.
                    //
                    if((ulCount > 1) && (ulCount < 16))
c0d0192c:	1e81      	subs	r1, r0, #2
c0d0192e:	290d      	cmp	r1, #13
c0d01930:	d80c      	bhi.n	c0d0194c <screen_printf+0x20c>
c0d01932:	1e41      	subs	r1, r0, #1
c0d01934:	d00a      	beq.n	c0d0194c <screen_printf+0x20c>
c0d01936:	a808      	add	r0, sp, #32
                    {
                        for(ulCount--; ulCount; ulCount--)
                        {
                            pcBuf[ulPos++] = cFill;
c0d01938:	4328      	orrs	r0, r5
c0d0193a:	9302      	str	r3, [sp, #8]
c0d0193c:	f002 fc3a 	bl	c0d041b4 <__aeabi_memset>
c0d01940:	9b02      	ldr	r3, [sp, #8]
c0d01942:	9805      	ldr	r0, [sp, #20]
c0d01944:	1940      	adds	r0, r0, r5
c0d01946:	9901      	ldr	r1, [sp, #4]
c0d01948:	1840      	adds	r0, r0, r1
c0d0194a:	1e45      	subs	r5, r0, #1

                    //
                    // If the value is negative, then place the minus sign
                    // before the number.
                    //
                    if(ulNeg)
c0d0194c:	2b00      	cmp	r3, #0
c0d0194e:	d003      	beq.n	c0d01958 <screen_printf+0x218>
c0d01950:	a808      	add	r0, sp, #32
                    {
                        //
                        // Place the minus sign in the output buffer.
                        //
                        pcBuf[ulPos++] = '-';
c0d01952:	212d      	movs	r1, #45	; 0x2d
c0d01954:	5541      	strb	r1, [r0, r5]
c0d01956:	1c6d      	adds	r5, r5, #1
                    }

                    //
                    // Convert the value into a string.
                    //
                    for(; ulIdx; ulIdx /= ulBase)
c0d01958:	2f00      	cmp	r7, #0
c0d0195a:	d01b      	beq.n	c0d01994 <screen_printf+0x254>
c0d0195c:	9803      	ldr	r0, [sp, #12]
c0d0195e:	2800      	cmp	r0, #0
c0d01960:	d002      	beq.n	c0d01968 <screen_printf+0x228>
c0d01962:	4849      	ldr	r0, [pc, #292]	; (c0d01a88 <screen_printf+0x348>)
c0d01964:	4478      	add	r0, pc
c0d01966:	e001      	b.n	c0d0196c <screen_printf+0x22c>
c0d01968:	4846      	ldr	r0, [pc, #280]	; (c0d01a84 <screen_printf+0x344>)
c0d0196a:	4478      	add	r0, pc
c0d0196c:	9005      	str	r0, [sp, #20]
c0d0196e:	9806      	ldr	r0, [sp, #24]
c0d01970:	4639      	mov	r1, r7
c0d01972:	f002 fb89 	bl	c0d04088 <__aeabi_uidiv>
c0d01976:	4631      	mov	r1, r6
c0d01978:	f002 fc0c 	bl	c0d04194 <__aeabi_uidivmod>
c0d0197c:	9805      	ldr	r0, [sp, #20]
c0d0197e:	5c40      	ldrb	r0, [r0, r1]
c0d01980:	a908      	add	r1, sp, #32
c0d01982:	5548      	strb	r0, [r1, r5]
c0d01984:	4638      	mov	r0, r7
c0d01986:	4631      	mov	r1, r6
c0d01988:	f002 fb7e 	bl	c0d04088 <__aeabi_uidiv>
c0d0198c:	1c6d      	adds	r5, r5, #1
c0d0198e:	42be      	cmp	r6, r7
c0d01990:	4607      	mov	r7, r0
c0d01992:	d9ec      	bls.n	c0d0196e <screen_printf+0x22e>

#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
c0d01994:	2d00      	cmp	r5, #0
c0d01996:	d066      	beq.n	c0d01a66 <screen_printf+0x326>
c0d01998:	ae08      	add	r6, sp, #32
    screen_printc(*str++);
c0d0199a:	7830      	ldrb	r0, [r6, #0]
c0d0199c:	f7ff feba 	bl	c0d01714 <screen_printc>
c0d019a0:	1c76      	adds	r6, r6, #1

#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
c0d019a2:	1e6d      	subs	r5, r5, #1
c0d019a4:	d1f9      	bne.n	c0d0199a <screen_printf+0x25a>
c0d019a6:	e05e      	b.n	c0d01a66 <screen_printf+0x326>
                case 'c':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d019a8:	9807      	ldr	r0, [sp, #28]
c0d019aa:	1d01      	adds	r1, r0, #4
c0d019ac:	9107      	str	r1, [sp, #28]
#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
    screen_printc(*str++);
c0d019ae:	7800      	ldrb	r0, [r0, #0]
c0d019b0:	f7ff feb0 	bl	c0d01714 <screen_printc>
c0d019b4:	e057      	b.n	c0d01a66 <screen_printf+0x326>
c0d019b6:	9a06      	ldr	r2, [sp, #24]
c0d019b8:	e011      	b.n	c0d019de <screen_printf+0x29e>
                        break;
                        
                      // printout prepad
                      case 2:
                        // if string is empty, then, ' ' padding
                        if (pcStr[0] == '\0') {
c0d019ba:	7838      	ldrb	r0, [r7, #0]
c0d019bc:	2800      	cmp	r0, #0
c0d019be:	d03f      	beq.n	c0d01a40 <screen_printf+0x300>

#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
c0d019c0:	482d      	ldr	r0, [pc, #180]	; (c0d01a78 <screen_printf+0x338>)
c0d019c2:	4478      	add	r0, pc
c0d019c4:	1940      	adds	r0, r0, r5
    screen_printc(*str++);
c0d019c6:	7940      	ldrb	r0, [r0, #5]
c0d019c8:	f7ff fea4 	bl	c0d01714 <screen_printc>

#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
c0d019cc:	1c6d      	adds	r5, r5, #1
c0d019ce:	d1f7      	bne.n	c0d019c0 <screen_printf+0x280>
c0d019d0:	e049      	b.n	c0d01a66 <screen_printf+0x326>
c0d019d2:	1d2a      	adds	r2, r5, #4
                    // Determine the length of the string. (if not specified using .*)
                    //
                    switch(cStrlenSet) {
                      // compute length with strlen
                      case 0:
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0d019d4:	18b9      	adds	r1, r7, r2
c0d019d6:	7849      	ldrb	r1, [r1, #1]
c0d019d8:	1c52      	adds	r2, r2, #1
c0d019da:	2900      	cmp	r1, #0
c0d019dc:	d1fa      	bne.n	c0d019d4 <screen_printf+0x294>
c0d019de:	9206      	str	r2, [sp, #24]
                    }

                    //
                    // Write the string.
                    //
                    switch(ulBase) {
c0d019e0:	2810      	cmp	r0, #16
c0d019e2:	9e03      	ldr	r6, [sp, #12]
c0d019e4:	d11f      	bne.n	c0d01a26 <screen_printf+0x2e6>
                      default:
                        screen_prints(pcStr, ulIdx);
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0d019e6:	9806      	ldr	r0, [sp, #24]
c0d019e8:	e01a      	b.n	c0d01a20 <screen_printf+0x2e0>
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0d019ea:	7838      	ldrb	r0, [r7, #0]
                          nibble2 = pcStr[ulCount]&0xF;
c0d019ec:	250f      	movs	r5, #15
c0d019ee:	4005      	ands	r5, r0
                        screen_prints(pcStr, ulIdx);
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0d019f0:	0900      	lsrs	r0, r0, #4
                          nibble2 = pcStr[ulCount]&0xF;
                          switch(ulCap) {
c0d019f2:	2e01      	cmp	r6, #1
c0d019f4:	d005      	beq.n	c0d01a02 <screen_printf+0x2c2>
c0d019f6:	2e00      	cmp	r6, #0
c0d019f8:	d10e      	bne.n	c0d01a18 <screen_printf+0x2d8>
                            case 0:
                              screen_printc(g_pcHex[nibble1]);
c0d019fa:	b2c0      	uxtb	r0, r0
c0d019fc:	4e1f      	ldr	r6, [pc, #124]	; (c0d01a7c <screen_printf+0x33c>)
c0d019fe:	447e      	add	r6, pc
c0d01a00:	e002      	b.n	c0d01a08 <screen_printf+0x2c8>
                              screen_printc(g_pcHex[nibble2]);
                              break;
                            case 1:
                              screen_printc(g_pcHex_cap[nibble1]);
c0d01a02:	b2c0      	uxtb	r0, r0
c0d01a04:	4e1e      	ldr	r6, [pc, #120]	; (c0d01a80 <screen_printf+0x340>)
c0d01a06:	447e      	add	r6, pc
c0d01a08:	5c30      	ldrb	r0, [r6, r0]
c0d01a0a:	f7ff fe83 	bl	c0d01714 <screen_printc>
c0d01a0e:	b2e8      	uxtb	r0, r5
c0d01a10:	5c30      	ldrb	r0, [r6, r0]
c0d01a12:	9e03      	ldr	r6, [sp, #12]
c0d01a14:	f7ff fe7e 	bl	c0d01714 <screen_printc>
c0d01a18:	9806      	ldr	r0, [sp, #24]
                      default:
                        screen_prints(pcStr, ulIdx);
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0d01a1a:	1e40      	subs	r0, r0, #1
c0d01a1c:	1c7f      	adds	r7, r7, #1
c0d01a1e:	9006      	str	r0, [sp, #24]
c0d01a20:	2800      	cmp	r0, #0
c0d01a22:	d1e2      	bne.n	c0d019ea <screen_printf+0x2aa>
c0d01a24:	e01f      	b.n	c0d01a66 <screen_printf+0x326>
c0d01a26:	2600      	movs	r6, #0

#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
c0d01a28:	9806      	ldr	r0, [sp, #24]
c0d01a2a:	2800      	cmp	r0, #0
c0d01a2c:	d010      	beq.n	c0d01a50 <screen_printf+0x310>
c0d01a2e:	2500      	movs	r5, #0
c0d01a30:	9e06      	ldr	r6, [sp, #24]
    screen_printc(*str++);
c0d01a32:	5d78      	ldrb	r0, [r7, r5]
c0d01a34:	f7ff fe6e 	bl	c0d01714 <screen_printc>

#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
c0d01a38:	1c6d      	adds	r5, r5, #1
c0d01a3a:	42ae      	cmp	r6, r5
c0d01a3c:	d1f9      	bne.n	c0d01a32 <screen_printf+0x2f2>
c0d01a3e:	e007      	b.n	c0d01a50 <screen_printf+0x310>

        screen_printc(str[i]);
    }
    */

    unsigned long ulIdx, ulValue, ulPos, ulCount, ulBase, ulNeg, ulStrlen, ulCap;
c0d01a40:	1d28      	adds	r0, r5, #4
c0d01a42:	9906      	ldr	r1, [sp, #24]
c0d01a44:	1a45      	subs	r5, r0, r1
#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
  while(charcount--) {
    screen_printc(*str++);
c0d01a46:	2020      	movs	r0, #32
c0d01a48:	f7ff fe64 	bl	c0d01714 <screen_printc>
                        if (pcStr[0] == '\0') {
                        
                          // padd ulStrlen white space
                          do {
                            screen_prints(" ", 1);
                          } while(ulStrlen-- > 0);
c0d01a4c:	1c6d      	adds	r5, r5, #1
c0d01a4e:	d1fa      	bne.n	c0d01a46 <screen_printf+0x306>
c0d01a50:	9905      	ldr	r1, [sp, #20]

s_pad:
                    //
                    // Write any required padding spaces
                    //
                    if(ulCount > ulIdx)
c0d01a52:	42b1      	cmp	r1, r6
c0d01a54:	d907      	bls.n	c0d01a66 <screen_printf+0x326>
                    {
                        ulCount -= ulIdx;
c0d01a56:	1b88      	subs	r0, r1, r6
c0d01a58:	d005      	beq.n	c0d01a66 <screen_printf+0x326>
};

#ifdef HAVE_PRINTF

#ifndef BOLOS_RELEASE
void screen_prints(const char* str, unsigned int charcount) {
c0d01a5a:	1a75      	subs	r5, r6, r1
  while(charcount--) {
    screen_printc(*str++);
c0d01a5c:	2020      	movs	r0, #32
c0d01a5e:	f7ff fe59 	bl	c0d01714 <screen_printc>
                    // Write any required padding spaces
                    //
                    if(ulCount > ulIdx)
                    {
                        ulCount -= ulIdx;
                        while(ulCount--)
c0d01a62:	1c6d      	adds	r5, r5, #1
c0d01a64:	d1fa      	bne.n	c0d01a5c <screen_printf+0x31c>
c0d01a66:	7820      	ldrb	r0, [r4, #0]
c0d01a68:	2800      	cmp	r0, #0
c0d01a6a:	d000      	beq.n	c0d01a6e <screen_printf+0x32e>
c0d01a6c:	e674      	b.n	c0d01758 <screen_printf+0x18>

    //
    // End the varargs processing.
    //
    va_end(vaArgP);
}
c0d01a6e:	b00c      	add	sp, #48	; 0x30
c0d01a70:	bcf0      	pop	{r4, r5, r6, r7}
c0d01a72:	bc01      	pop	{r0}
c0d01a74:	b003      	add	sp, #12
c0d01a76:	4700      	bx	r0
c0d01a78:	00002a0e 	.word	0x00002a0e
c0d01a7c:	000029b2 	.word	0x000029b2
c0d01a80:	000029ba 	.word	0x000029ba
c0d01a84:	00002a46 	.word	0x00002a46
c0d01a88:	00002a5c 	.word	0x00002a5c

c0d01a8c <snprintf>:
#endif // HAVE_PRINTF

#ifdef HAVE_SPRINTF
//unsigned int snprintf(unsigned char * str, unsigned int str_size, const char* format, ...)
int snprintf(char * str, size_t str_size, const char * format, ...)
 {
c0d01a8c:	b081      	sub	sp, #4
c0d01a8e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01a90:	b090      	sub	sp, #64	; 0x40
c0d01a92:	4615      	mov	r5, r2
c0d01a94:	460c      	mov	r4, r1
c0d01a96:	900a      	str	r0, [sp, #40]	; 0x28
c0d01a98:	9315      	str	r3, [sp, #84]	; 0x54
    char cStrlenSet;
    
    //
    // Check the arguments.
    //
    if(format == 0 || str == 0 ||str_size < 2) {
c0d01a9a:	2c02      	cmp	r4, #2
c0d01a9c:	d200      	bcs.n	c0d01aa0 <snprintf+0x14>
c0d01a9e:	e1f5      	b.n	c0d01e8c <snprintf+0x400>
c0d01aa0:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01aa2:	2800      	cmp	r0, #0
c0d01aa4:	d100      	bne.n	c0d01aa8 <snprintf+0x1c>
c0d01aa6:	e1f1      	b.n	c0d01e8c <snprintf+0x400>
c0d01aa8:	2d00      	cmp	r5, #0
c0d01aaa:	d100      	bne.n	c0d01aae <snprintf+0x22>
c0d01aac:	e1ee      	b.n	c0d01e8c <snprintf+0x400>
c0d01aae:	2100      	movs	r1, #0
      return 0;
    }

    // ensure terminating string with a \0
    os_memset(str, 0, str_size);
c0d01ab0:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01ab2:	9107      	str	r1, [sp, #28]
c0d01ab4:	4622      	mov	r2, r4
c0d01ab6:	f7ff f8f5 	bl	c0d00ca4 <os_memset>
c0d01aba:	a815      	add	r0, sp, #84	; 0x54


    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0d01abc:	900b      	str	r0, [sp, #44]	; 0x2c

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0d01abe:	7828      	ldrb	r0, [r5, #0]
c0d01ac0:	2800      	cmp	r0, #0
c0d01ac2:	d100      	bne.n	c0d01ac6 <snprintf+0x3a>
c0d01ac4:	e1e2      	b.n	c0d01e8c <snprintf+0x400>
c0d01ac6:	9907      	ldr	r1, [sp, #28]
c0d01ac8:	43c9      	mvns	r1, r1
      return 0;
    }

    // ensure terminating string with a \0
    os_memset(str, 0, str_size);
    str_size--;
c0d01aca:	1e67      	subs	r7, r4, #1
c0d01acc:	9105      	str	r1, [sp, #20]
c0d01ace:	e1c2      	b.n	c0d01e56 <snprintf+0x3ca>
        }

        //
        // Skip the portion of the string that was written.
        //
        format += ulIdx;
c0d01ad0:	1928      	adds	r0, r5, r4

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0d01ad2:	5d29      	ldrb	r1, [r5, r4]
c0d01ad4:	2925      	cmp	r1, #37	; 0x25
c0d01ad6:	d10b      	bne.n	c0d01af0 <snprintf+0x64>
c0d01ad8:	9703      	str	r7, [sp, #12]
c0d01ada:	9202      	str	r2, [sp, #8]
        {
            //
            // Skip the %.
            //
            format++;
c0d01adc:	1c43      	adds	r3, r0, #1
c0d01ade:	2000      	movs	r0, #0
c0d01ae0:	2120      	movs	r1, #32
c0d01ae2:	9108      	str	r1, [sp, #32]
c0d01ae4:	210a      	movs	r1, #10
c0d01ae6:	9101      	str	r1, [sp, #4]
c0d01ae8:	9000      	str	r0, [sp, #0]
c0d01aea:	9004      	str	r0, [sp, #16]
c0d01aec:	9009      	str	r0, [sp, #36]	; 0x24
c0d01aee:	e056      	b.n	c0d01b9e <snprintf+0x112>
c0d01af0:	4605      	mov	r5, r0
c0d01af2:	920a      	str	r2, [sp, #40]	; 0x28
c0d01af4:	e121      	b.n	c0d01d3a <snprintf+0x2ae>
c0d01af6:	462b      	mov	r3, r5
c0d01af8:	4608      	mov	r0, r1
c0d01afa:	e04b      	b.n	c0d01b94 <snprintf+0x108>
c0d01afc:	2b47      	cmp	r3, #71	; 0x47
c0d01afe:	dc13      	bgt.n	c0d01b28 <snprintf+0x9c>
c0d01b00:	4619      	mov	r1, r3
c0d01b02:	3930      	subs	r1, #48	; 0x30
c0d01b04:	290a      	cmp	r1, #10
c0d01b06:	d234      	bcs.n	c0d01b72 <snprintf+0xe6>
                {
                    //
                    // If this is a zero, and it is the first digit, then the
                    // fill character is a zero instead of a space.
                    //
                    if((format[-1] == '0') && (ulCount == 0))
c0d01b08:	2b30      	cmp	r3, #48	; 0x30
c0d01b0a:	9908      	ldr	r1, [sp, #32]
c0d01b0c:	d100      	bne.n	c0d01b10 <snprintf+0x84>
c0d01b0e:	4619      	mov	r1, r3
c0d01b10:	9f09      	ldr	r7, [sp, #36]	; 0x24
c0d01b12:	2f00      	cmp	r7, #0
c0d01b14:	d000      	beq.n	c0d01b18 <snprintf+0x8c>
c0d01b16:	9908      	ldr	r1, [sp, #32]
                    }

                    //
                    // Update the digit count.
                    //
                    ulCount *= 10;
c0d01b18:	220a      	movs	r2, #10
c0d01b1a:	437a      	muls	r2, r7
                    ulCount += format[-1] - '0';
c0d01b1c:	18d2      	adds	r2, r2, r3
c0d01b1e:	3a30      	subs	r2, #48	; 0x30
c0d01b20:	9209      	str	r2, [sp, #36]	; 0x24
c0d01b22:	462b      	mov	r3, r5
c0d01b24:	9108      	str	r1, [sp, #32]
c0d01b26:	e03a      	b.n	c0d01b9e <snprintf+0x112>
c0d01b28:	2b67      	cmp	r3, #103	; 0x67
c0d01b2a:	dd04      	ble.n	c0d01b36 <snprintf+0xaa>
c0d01b2c:	2b72      	cmp	r3, #114	; 0x72
c0d01b2e:	dd09      	ble.n	c0d01b44 <snprintf+0xb8>
c0d01b30:	2b73      	cmp	r3, #115	; 0x73
c0d01b32:	d146      	bne.n	c0d01bc2 <snprintf+0x136>
c0d01b34:	e00a      	b.n	c0d01b4c <snprintf+0xc0>
c0d01b36:	2b62      	cmp	r3, #98	; 0x62
c0d01b38:	dc48      	bgt.n	c0d01bcc <snprintf+0x140>
c0d01b3a:	2b48      	cmp	r3, #72	; 0x48
c0d01b3c:	d155      	bne.n	c0d01bea <snprintf+0x15e>
c0d01b3e:	2201      	movs	r2, #1
c0d01b40:	9204      	str	r2, [sp, #16]
c0d01b42:	e001      	b.n	c0d01b48 <snprintf+0xbc>
c0d01b44:	2b68      	cmp	r3, #104	; 0x68
c0d01b46:	d156      	bne.n	c0d01bf6 <snprintf+0x16a>
c0d01b48:	2210      	movs	r2, #16
c0d01b4a:	9201      	str	r2, [sp, #4]
                case_s:
                {
                    //
                    // Get the string pointer from the varargs.
                    //
                    pcStr = va_arg(vaArgP, char *);
c0d01b4c:	9a0b      	ldr	r2, [sp, #44]	; 0x2c
c0d01b4e:	1d13      	adds	r3, r2, #4
c0d01b50:	930b      	str	r3, [sp, #44]	; 0x2c
c0d01b52:	2303      	movs	r3, #3
c0d01b54:	4018      	ands	r0, r3
c0d01b56:	1c4f      	adds	r7, r1, #1
c0d01b58:	6811      	ldr	r1, [r2, #0]

                    //
                    // Determine the length of the string. (if not specified using .*)
                    //
                    switch(cStrlenSet) {
c0d01b5a:	2801      	cmp	r0, #1
c0d01b5c:	d100      	bne.n	c0d01b60 <snprintf+0xd4>
c0d01b5e:	e0d0      	b.n	c0d01d02 <snprintf+0x276>
c0d01b60:	2802      	cmp	r0, #2
c0d01b62:	d100      	bne.n	c0d01b66 <snprintf+0xda>
c0d01b64:	e0d2      	b.n	c0d01d0c <snprintf+0x280>
c0d01b66:	2803      	cmp	r0, #3
c0d01b68:	462b      	mov	r3, r5
c0d01b6a:	4638      	mov	r0, r7
c0d01b6c:	9f06      	ldr	r7, [sp, #24]
c0d01b6e:	d016      	beq.n	c0d01b9e <snprintf+0x112>
c0d01b70:	e0e9      	b.n	c0d01d46 <snprintf+0x2ba>
c0d01b72:	2b2e      	cmp	r3, #46	; 0x2e
c0d01b74:	d000      	beq.n	c0d01b78 <snprintf+0xec>
c0d01b76:	e0cc      	b.n	c0d01d12 <snprintf+0x286>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'/'h'/'H'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0d01b78:	7828      	ldrb	r0, [r5, #0]
c0d01b7a:	282a      	cmp	r0, #42	; 0x2a
c0d01b7c:	d000      	beq.n	c0d01b80 <snprintf+0xf4>
c0d01b7e:	e0c8      	b.n	c0d01d12 <snprintf+0x286>
c0d01b80:	7869      	ldrb	r1, [r5, #1]
c0d01b82:	1c6b      	adds	r3, r5, #1
c0d01b84:	2001      	movs	r0, #1
c0d01b86:	2948      	cmp	r1, #72	; 0x48
c0d01b88:	d004      	beq.n	c0d01b94 <snprintf+0x108>
c0d01b8a:	2968      	cmp	r1, #104	; 0x68
c0d01b8c:	d002      	beq.n	c0d01b94 <snprintf+0x108>
c0d01b8e:	2973      	cmp	r1, #115	; 0x73
c0d01b90:	d000      	beq.n	c0d01b94 <snprintf+0x108>
c0d01b92:	e0be      	b.n	c0d01d12 <snprintf+0x286>
c0d01b94:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d01b96:	1d0a      	adds	r2, r1, #4
c0d01b98:	920b      	str	r2, [sp, #44]	; 0x2c
c0d01b9a:	6809      	ldr	r1, [r1, #0]
int snprintf(char * str, size_t str_size, const char * format, ...)
 {
    unsigned int ulIdx, ulValue, ulPos, ulCount, ulBase, ulNeg, ulStrlen, ulCap;
    char *pcStr, pcBuf[16], cFill;
    va_list vaArgP;
    char cStrlenSet;
c0d01b9c:	9100      	str	r1, [sp, #0]
c0d01b9e:	2102      	movs	r1, #2
c0d01ba0:	461d      	mov	r5, r3
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0d01ba2:	782b      	ldrb	r3, [r5, #0]
c0d01ba4:	1c6d      	adds	r5, r5, #1
c0d01ba6:	2200      	movs	r2, #0
c0d01ba8:	2b2d      	cmp	r3, #45	; 0x2d
c0d01baa:	dca7      	bgt.n	c0d01afc <snprintf+0x70>
c0d01bac:	4610      	mov	r0, r2
c0d01bae:	d0f8      	beq.n	c0d01ba2 <snprintf+0x116>
c0d01bb0:	2b25      	cmp	r3, #37	; 0x25
c0d01bb2:	d02a      	beq.n	c0d01c0a <snprintf+0x17e>
c0d01bb4:	2b2a      	cmp	r3, #42	; 0x2a
c0d01bb6:	d000      	beq.n	c0d01bba <snprintf+0x12e>
c0d01bb8:	e0ab      	b.n	c0d01d12 <snprintf+0x286>
                  goto error;
                }
                
                case '*':
                {
                  if (*format == 's' ) {                    
c0d01bba:	7828      	ldrb	r0, [r5, #0]
c0d01bbc:	2873      	cmp	r0, #115	; 0x73
c0d01bbe:	d09a      	beq.n	c0d01af6 <snprintf+0x6a>
c0d01bc0:	e0a7      	b.n	c0d01d12 <snprintf+0x286>
c0d01bc2:	2b75      	cmp	r3, #117	; 0x75
c0d01bc4:	d023      	beq.n	c0d01c0e <snprintf+0x182>
c0d01bc6:	2b78      	cmp	r3, #120	; 0x78
c0d01bc8:	d018      	beq.n	c0d01bfc <snprintf+0x170>
c0d01bca:	e0a2      	b.n	c0d01d12 <snprintf+0x286>
c0d01bcc:	2b63      	cmp	r3, #99	; 0x63
c0d01bce:	d100      	bne.n	c0d01bd2 <snprintf+0x146>
c0d01bd0:	e08d      	b.n	c0d01cee <snprintf+0x262>
c0d01bd2:	2b64      	cmp	r3, #100	; 0x64
c0d01bd4:	d000      	beq.n	c0d01bd8 <snprintf+0x14c>
c0d01bd6:	e09c      	b.n	c0d01d12 <snprintf+0x286>
                case 'd':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01bd8:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01bda:	1d01      	adds	r1, r0, #4
c0d01bdc:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01bde:	6800      	ldr	r0, [r0, #0]
c0d01be0:	17c1      	asrs	r1, r0, #31
c0d01be2:	1842      	adds	r2, r0, r1
c0d01be4:	404a      	eors	r2, r1

                    //
                    // If the value is negative, make it positive and indicate
                    // that a minus sign is needed.
                    //
                    if((long)ulValue < 0)
c0d01be6:	0fc0      	lsrs	r0, r0, #31
c0d01be8:	e016      	b.n	c0d01c18 <snprintf+0x18c>
c0d01bea:	2b58      	cmp	r3, #88	; 0x58
c0d01bec:	d000      	beq.n	c0d01bf0 <snprintf+0x164>
c0d01bee:	e090      	b.n	c0d01d12 <snprintf+0x286>
c0d01bf0:	2001      	movs	r0, #1

#ifdef HAVE_SPRINTF
//unsigned int snprintf(unsigned char * str, unsigned int str_size, const char* format, ...)
int snprintf(char * str, size_t str_size, const char * format, ...)
 {
    unsigned int ulIdx, ulValue, ulPos, ulCount, ulBase, ulNeg, ulStrlen, ulCap;
c0d01bf2:	9004      	str	r0, [sp, #16]
c0d01bf4:	e002      	b.n	c0d01bfc <snprintf+0x170>
c0d01bf6:	2b70      	cmp	r3, #112	; 0x70
c0d01bf8:	d000      	beq.n	c0d01bfc <snprintf+0x170>
c0d01bfa:	e08a      	b.n	c0d01d12 <snprintf+0x286>
                case 'p':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01bfc:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01bfe:	1d01      	adds	r1, r0, #4
c0d01c00:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01c02:	6802      	ldr	r2, [r0, #0]
c0d01c04:	2000      	movs	r0, #0
c0d01c06:	2710      	movs	r7, #16
c0d01c08:	e007      	b.n	c0d01c1a <snprintf+0x18e>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    str[0] = '%';
c0d01c0a:	2025      	movs	r0, #37	; 0x25
c0d01c0c:	e073      	b.n	c0d01cf6 <snprintf+0x26a>
                case 'u':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01c0e:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01c10:	1d01      	adds	r1, r0, #4
c0d01c12:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01c14:	6802      	ldr	r2, [r0, #0]
c0d01c16:	2000      	movs	r0, #0
c0d01c18:	270a      	movs	r7, #10
c0d01c1a:	9006      	str	r0, [sp, #24]
c0d01c1c:	2601      	movs	r6, #1
c0d01c1e:	920a      	str	r2, [sp, #40]	; 0x28
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
                        (((ulIdx * ulBase) <= ulValue) &&
c0d01c20:	4297      	cmp	r7, r2
c0d01c22:	d812      	bhi.n	c0d01c4a <snprintf+0x1be>
c0d01c24:	2401      	movs	r4, #1
c0d01c26:	4638      	mov	r0, r7
c0d01c28:	4606      	mov	r6, r0
                         (((ulIdx * ulBase) / ulBase) == ulIdx));
c0d01c2a:	4639      	mov	r1, r7
c0d01c2c:	f002 fa2c 	bl	c0d04088 <__aeabi_uidiv>
                    //
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
c0d01c30:	42a0      	cmp	r0, r4
c0d01c32:	d109      	bne.n	c0d01c48 <snprintf+0x1bc>
                        (((ulIdx * ulBase) <= ulValue) &&
c0d01c34:	4638      	mov	r0, r7
c0d01c36:	4370      	muls	r0, r6
                         (((ulIdx * ulBase) / ulBase) == ulIdx));
                        ulIdx *= ulBase, ulCount--)
c0d01c38:	9909      	ldr	r1, [sp, #36]	; 0x24
c0d01c3a:	1e49      	subs	r1, r1, #1
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
                        (((ulIdx * ulBase) <= ulValue) &&
c0d01c3c:	9109      	str	r1, [sp, #36]	; 0x24
c0d01c3e:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d01c40:	4288      	cmp	r0, r1
c0d01c42:	4634      	mov	r4, r6
c0d01c44:	d9f0      	bls.n	c0d01c28 <snprintf+0x19c>
c0d01c46:	e000      	b.n	c0d01c4a <snprintf+0x1be>
c0d01c48:	4626      	mov	r6, r4

                    //
                    // If the value is negative, reduce the count of padding
                    // characters needed.
                    //
                    if(ulNeg)
c0d01c4a:	2400      	movs	r4, #0
c0d01c4c:	43e1      	mvns	r1, r4
c0d01c4e:	9b06      	ldr	r3, [sp, #24]
c0d01c50:	2b00      	cmp	r3, #0
c0d01c52:	d100      	bne.n	c0d01c56 <snprintf+0x1ca>
c0d01c54:	4619      	mov	r1, r3
c0d01c56:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01c58:	9101      	str	r1, [sp, #4]
c0d01c5a:	1840      	adds	r0, r0, r1

                    //
                    // If the value is negative and the value is padded with
                    // zeros, then place the minus sign before the padding.
                    //
                    if(ulNeg && (cFill == '0'))
c0d01c5c:	9908      	ldr	r1, [sp, #32]
c0d01c5e:	b2ca      	uxtb	r2, r1
c0d01c60:	2a30      	cmp	r2, #48	; 0x30
c0d01c62:	d106      	bne.n	c0d01c72 <snprintf+0x1e6>
c0d01c64:	2b00      	cmp	r3, #0
c0d01c66:	d004      	beq.n	c0d01c72 <snprintf+0x1e6>
c0d01c68:	a90c      	add	r1, sp, #48	; 0x30
                    {
                        //
                        // Place the minus sign in the output buffer.
                        //
                        pcBuf[ulPos++] = '-';
c0d01c6a:	232d      	movs	r3, #45	; 0x2d
c0d01c6c:	700b      	strb	r3, [r1, #0]
c0d01c6e:	2300      	movs	r3, #0
c0d01c70:	2401      	movs	r4, #1

                    //
                    // Provide additional padding at the beginning of the
                    // string conversion if needed.
                    //
                    if((ulCount > 1) && (ulCount < 16))
c0d01c72:	1e81      	subs	r1, r0, #2
c0d01c74:	290d      	cmp	r1, #13
c0d01c76:	d80c      	bhi.n	c0d01c92 <snprintf+0x206>
c0d01c78:	1e41      	subs	r1, r0, #1
c0d01c7a:	d00a      	beq.n	c0d01c92 <snprintf+0x206>
c0d01c7c:	a80c      	add	r0, sp, #48	; 0x30
                    {
                        for(ulCount--; ulCount; ulCount--)
                        {
                            pcBuf[ulPos++] = cFill;
c0d01c7e:	4320      	orrs	r0, r4
c0d01c80:	9306      	str	r3, [sp, #24]
c0d01c82:	f002 fa97 	bl	c0d041b4 <__aeabi_memset>
c0d01c86:	9b06      	ldr	r3, [sp, #24]
c0d01c88:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01c8a:	1900      	adds	r0, r0, r4
c0d01c8c:	9901      	ldr	r1, [sp, #4]
c0d01c8e:	1840      	adds	r0, r0, r1
c0d01c90:	1e44      	subs	r4, r0, #1

                    //
                    // If the value is negative, then place the minus sign
                    // before the number.
                    //
                    if(ulNeg)
c0d01c92:	2b00      	cmp	r3, #0
c0d01c94:	d003      	beq.n	c0d01c9e <snprintf+0x212>
c0d01c96:	a80c      	add	r0, sp, #48	; 0x30
                    {
                        //
                        // Place the minus sign in the output buffer.
                        //
                        pcBuf[ulPos++] = '-';
c0d01c98:	212d      	movs	r1, #45	; 0x2d
c0d01c9a:	5501      	strb	r1, [r0, r4]
c0d01c9c:	1c64      	adds	r4, r4, #1
c0d01c9e:	9804      	ldr	r0, [sp, #16]
                    }

                    //
                    // Convert the value into a string.
                    //
                    for(; ulIdx; ulIdx /= ulBase)
c0d01ca0:	2e00      	cmp	r6, #0
c0d01ca2:	d01a      	beq.n	c0d01cda <snprintf+0x24e>
c0d01ca4:	2800      	cmp	r0, #0
c0d01ca6:	d002      	beq.n	c0d01cae <snprintf+0x222>
c0d01ca8:	487f      	ldr	r0, [pc, #508]	; (c0d01ea8 <snprintf+0x41c>)
c0d01caa:	4478      	add	r0, pc
c0d01cac:	e001      	b.n	c0d01cb2 <snprintf+0x226>
c0d01cae:	487d      	ldr	r0, [pc, #500]	; (c0d01ea4 <snprintf+0x418>)
c0d01cb0:	4478      	add	r0, pc
c0d01cb2:	9009      	str	r0, [sp, #36]	; 0x24
c0d01cb4:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01cb6:	4631      	mov	r1, r6
c0d01cb8:	f002 f9e6 	bl	c0d04088 <__aeabi_uidiv>
c0d01cbc:	4639      	mov	r1, r7
c0d01cbe:	f002 fa69 	bl	c0d04194 <__aeabi_uidivmod>
c0d01cc2:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01cc4:	5c40      	ldrb	r0, [r0, r1]
c0d01cc6:	a90c      	add	r1, sp, #48	; 0x30
c0d01cc8:	5508      	strb	r0, [r1, r4]
c0d01cca:	4630      	mov	r0, r6
c0d01ccc:	4639      	mov	r1, r7
c0d01cce:	f002 f9db 	bl	c0d04088 <__aeabi_uidiv>
c0d01cd2:	1c64      	adds	r4, r4, #1
c0d01cd4:	42b7      	cmp	r7, r6
c0d01cd6:	4606      	mov	r6, r0
c0d01cd8:	d9ec      	bls.n	c0d01cb4 <snprintf+0x228>
c0d01cda:	9b03      	ldr	r3, [sp, #12]
                    }

                    //
                    // Write the string.
                    //
                    ulPos = MIN(ulPos, str_size);
c0d01cdc:	429c      	cmp	r4, r3
c0d01cde:	d300      	bcc.n	c0d01ce2 <snprintf+0x256>
c0d01ce0:	461c      	mov	r4, r3
c0d01ce2:	a90c      	add	r1, sp, #48	; 0x30
c0d01ce4:	9e02      	ldr	r6, [sp, #8]
                    os_memmove(str, pcBuf, ulPos);
c0d01ce6:	4630      	mov	r0, r6
c0d01ce8:	4622      	mov	r2, r4
c0d01cea:	461f      	mov	r7, r3
c0d01cec:	e01c      	b.n	c0d01d28 <snprintf+0x29c>
                case 'c':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01cee:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01cf0:	1d01      	adds	r1, r0, #4
c0d01cf2:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01cf4:	6800      	ldr	r0, [r0, #0]
c0d01cf6:	9902      	ldr	r1, [sp, #8]
c0d01cf8:	7008      	strb	r0, [r1, #0]
c0d01cfa:	9803      	ldr	r0, [sp, #12]
c0d01cfc:	1e40      	subs	r0, r0, #1
c0d01cfe:	1c49      	adds	r1, r1, #1
c0d01d00:	e016      	b.n	c0d01d30 <snprintf+0x2a4>
c0d01d02:	9c00      	ldr	r4, [sp, #0]
c0d01d04:	9a05      	ldr	r2, [sp, #20]
c0d01d06:	9b03      	ldr	r3, [sp, #12]
c0d01d08:	9f06      	ldr	r7, [sp, #24]
c0d01d0a:	e024      	b.n	c0d01d56 <snprintf+0x2ca>
                        break;
                        
                      // printout prepad
                      case 2:
                        // if string is empty, then, ' ' padding
                        if (pcStr[0] == '\0') {
c0d01d0c:	7808      	ldrb	r0, [r1, #0]
c0d01d0e:	2800      	cmp	r0, #0
c0d01d10:	d077      	beq.n	c0d01e02 <snprintf+0x376>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    ulPos = MIN(strlen("ERROR"), str_size);
c0d01d12:	2005      	movs	r0, #5
c0d01d14:	9f03      	ldr	r7, [sp, #12]
c0d01d16:	2f05      	cmp	r7, #5
c0d01d18:	463c      	mov	r4, r7
c0d01d1a:	d300      	bcc.n	c0d01d1e <snprintf+0x292>
c0d01d1c:	4604      	mov	r4, r0
                    os_memmove(str, "ERROR", ulPos);
c0d01d1e:	495e      	ldr	r1, [pc, #376]	; (c0d01e98 <snprintf+0x40c>)
c0d01d20:	4479      	add	r1, pc
c0d01d22:	9e02      	ldr	r6, [sp, #8]
c0d01d24:	4630      	mov	r0, r6
c0d01d26:	4622      	mov	r2, r4
c0d01d28:	f7fe ffc5 	bl	c0d00cb6 <os_memmove>
c0d01d2c:	1b38      	subs	r0, r7, r4
c0d01d2e:	1931      	adds	r1, r6, r4
c0d01d30:	910a      	str	r1, [sp, #40]	; 0x28
c0d01d32:	4607      	mov	r7, r0
c0d01d34:	2800      	cmp	r0, #0
c0d01d36:	d100      	bne.n	c0d01d3a <snprintf+0x2ae>
c0d01d38:	e0a8      	b.n	c0d01e8c <snprintf+0x400>
    va_start(vaArgP, format);

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0d01d3a:	7828      	ldrb	r0, [r5, #0]
c0d01d3c:	2800      	cmp	r0, #0
c0d01d3e:	9905      	ldr	r1, [sp, #20]
c0d01d40:	d000      	beq.n	c0d01d44 <snprintf+0x2b8>
c0d01d42:	e088      	b.n	c0d01e56 <snprintf+0x3ca>
c0d01d44:	e0a2      	b.n	c0d01e8c <snprintf+0x400>
c0d01d46:	9a05      	ldr	r2, [sp, #20]
c0d01d48:	4614      	mov	r4, r2
c0d01d4a:	9b03      	ldr	r3, [sp, #12]
                    // Determine the length of the string. (if not specified using .*)
                    //
                    switch(cStrlenSet) {
                      // compute length with strlen
                      case 0:
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0d01d4c:	1908      	adds	r0, r1, r4
c0d01d4e:	7840      	ldrb	r0, [r0, #1]
c0d01d50:	1c64      	adds	r4, r4, #1
c0d01d52:	2800      	cmp	r0, #0
c0d01d54:	d1fa      	bne.n	c0d01d4c <snprintf+0x2c0>
                    }

                    //
                    // Write the string.
                    //
                    switch(ulBase) {
c0d01d56:	9801      	ldr	r0, [sp, #4]
c0d01d58:	2810      	cmp	r0, #16
c0d01d5a:	9802      	ldr	r0, [sp, #8]
c0d01d5c:	d146      	bne.n	c0d01dec <snprintf+0x360>
                            return 0;
                        }
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0d01d5e:	2c00      	cmp	r4, #0
c0d01d60:	d076      	beq.n	c0d01e50 <snprintf+0x3c4>
c0d01d62:	9108      	str	r1, [sp, #32]
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0d01d64:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01d66:	1883      	adds	r3, r0, r2
c0d01d68:	1bd0      	subs	r0, r2, r7
c0d01d6a:	4286      	cmp	r6, r0
c0d01d6c:	4631      	mov	r1, r6
c0d01d6e:	d800      	bhi.n	c0d01d72 <snprintf+0x2e6>
c0d01d70:	4601      	mov	r1, r0
c0d01d72:	9103      	str	r1, [sp, #12]
c0d01d74:	434a      	muls	r2, r1
c0d01d76:	9202      	str	r2, [sp, #8]
c0d01d78:	1c50      	adds	r0, r2, #1
c0d01d7a:	9001      	str	r0, [sp, #4]
c0d01d7c:	2000      	movs	r0, #0
c0d01d7e:	463a      	mov	r2, r7
c0d01d80:	930a      	str	r3, [sp, #40]	; 0x28
c0d01d82:	9902      	ldr	r1, [sp, #8]
c0d01d84:	185b      	adds	r3, r3, r1
c0d01d86:	9009      	str	r0, [sp, #36]	; 0x24
c0d01d88:	9908      	ldr	r1, [sp, #32]
c0d01d8a:	5c08      	ldrb	r0, [r1, r0]
                          nibble2 = pcStr[ulCount]&0xF;
c0d01d8c:	270f      	movs	r7, #15
c0d01d8e:	4007      	ands	r7, r0
                        }
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0d01d90:	0900      	lsrs	r0, r0, #4
c0d01d92:	9903      	ldr	r1, [sp, #12]
c0d01d94:	1889      	adds	r1, r1, r2
c0d01d96:	1c49      	adds	r1, r1, #1
                          nibble2 = pcStr[ulCount]&0xF;
                          if (str_size < 2) {
c0d01d98:	2902      	cmp	r1, #2
c0d01d9a:	d377      	bcc.n	c0d01e8c <snprintf+0x400>
c0d01d9c:	9904      	ldr	r1, [sp, #16]
                              return 0;
                          }
                          switch(ulCap) {
c0d01d9e:	2901      	cmp	r1, #1
c0d01da0:	d004      	beq.n	c0d01dac <snprintf+0x320>
c0d01da2:	2900      	cmp	r1, #0
c0d01da4:	d10a      	bne.n	c0d01dbc <snprintf+0x330>
c0d01da6:	493e      	ldr	r1, [pc, #248]	; (c0d01ea0 <snprintf+0x414>)
c0d01da8:	4479      	add	r1, pc
c0d01daa:	e001      	b.n	c0d01db0 <snprintf+0x324>
c0d01dac:	493b      	ldr	r1, [pc, #236]	; (c0d01e9c <snprintf+0x410>)
c0d01dae:	4479      	add	r1, pc
c0d01db0:	b2c0      	uxtb	r0, r0
c0d01db2:	5c08      	ldrb	r0, [r1, r0]
c0d01db4:	7018      	strb	r0, [r3, #0]
c0d01db6:	b2f8      	uxtb	r0, r7
c0d01db8:	5c08      	ldrb	r0, [r1, r0]
c0d01dba:	7058      	strb	r0, [r3, #1]
                                str[1] = g_pcHex_cap[nibble2];
                              break;
                          }
                          str+= 2;
                          str_size -= 2;
                          if (str_size == 0) {
c0d01dbc:	9801      	ldr	r0, [sp, #4]
c0d01dbe:	4290      	cmp	r0, r2
c0d01dc0:	d064      	beq.n	c0d01e8c <snprintf+0x400>
                            return 0;
                        }
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0d01dc2:	1e92      	subs	r2, r2, #2
c0d01dc4:	9b0a      	ldr	r3, [sp, #40]	; 0x28
c0d01dc6:	1c9b      	adds	r3, r3, #2
c0d01dc8:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01dca:	1c40      	adds	r0, r0, #1
c0d01dcc:	42a0      	cmp	r0, r4
c0d01dce:	d3d7      	bcc.n	c0d01d80 <snprintf+0x2f4>
c0d01dd0:	9009      	str	r0, [sp, #36]	; 0x24
c0d01dd2:	9905      	ldr	r1, [sp, #20]
 
#endif // HAVE_PRINTF

#ifdef HAVE_SPRINTF
//unsigned int snprintf(unsigned char * str, unsigned int str_size, const char* format, ...)
int snprintf(char * str, size_t str_size, const char * format, ...)
c0d01dd4:	9806      	ldr	r0, [sp, #24]
c0d01dd6:	1a08      	subs	r0, r1, r0
c0d01dd8:	4286      	cmp	r6, r0
c0d01dda:	d800      	bhi.n	c0d01dde <snprintf+0x352>
c0d01ddc:	4606      	mov	r6, r0
c0d01dde:	4608      	mov	r0, r1
c0d01de0:	4370      	muls	r0, r6
c0d01de2:	1818      	adds	r0, r3, r0
c0d01de4:	900a      	str	r0, [sp, #40]	; 0x28
c0d01de6:	18b0      	adds	r0, r6, r2
c0d01de8:	1c47      	adds	r7, r0, #1
c0d01dea:	e01c      	b.n	c0d01e26 <snprintf+0x39a>
                    //
                    // Write the string.
                    //
                    switch(ulBase) {
                      default:
                        ulIdx = MIN(ulIdx, str_size);
c0d01dec:	429c      	cmp	r4, r3
c0d01dee:	d300      	bcc.n	c0d01df2 <snprintf+0x366>
c0d01df0:	461c      	mov	r4, r3
                        os_memmove(str, pcStr, ulIdx);
c0d01df2:	4622      	mov	r2, r4
c0d01df4:	4606      	mov	r6, r0
c0d01df6:	461f      	mov	r7, r3
c0d01df8:	f7fe ff5d 	bl	c0d00cb6 <os_memmove>
                        str+= ulIdx;
                        str_size -= ulIdx;
c0d01dfc:	1b38      	subs	r0, r7, r4
                    //
                    switch(ulBase) {
                      default:
                        ulIdx = MIN(ulIdx, str_size);
                        os_memmove(str, pcStr, ulIdx);
                        str+= ulIdx;
c0d01dfe:	1931      	adds	r1, r6, r4
c0d01e00:	e00d      	b.n	c0d01e1e <snprintf+0x392>
c0d01e02:	9b03      	ldr	r3, [sp, #12]
c0d01e04:	9f00      	ldr	r7, [sp, #0]
                      case 2:
                        // if string is empty, then, ' ' padding
                        if (pcStr[0] == '\0') {
                        
                          // padd ulStrlen white space
                          ulStrlen = MIN(ulStrlen, str_size);
c0d01e06:	429f      	cmp	r7, r3
c0d01e08:	d300      	bcc.n	c0d01e0c <snprintf+0x380>
c0d01e0a:	461f      	mov	r7, r3
                          os_memset(str, ' ', ulStrlen);
c0d01e0c:	2120      	movs	r1, #32
c0d01e0e:	9e02      	ldr	r6, [sp, #8]
c0d01e10:	4630      	mov	r0, r6
c0d01e12:	463a      	mov	r2, r7
c0d01e14:	f7fe ff46 	bl	c0d00ca4 <os_memset>
                          str+= ulStrlen;
                          str_size -= ulStrlen;
c0d01e18:	9803      	ldr	r0, [sp, #12]
c0d01e1a:	1bc0      	subs	r0, r0, r7
                        if (pcStr[0] == '\0') {
                        
                          // padd ulStrlen white space
                          ulStrlen = MIN(ulStrlen, str_size);
                          os_memset(str, ' ', ulStrlen);
                          str+= ulStrlen;
c0d01e1c:	19f1      	adds	r1, r6, r7
c0d01e1e:	910a      	str	r1, [sp, #40]	; 0x28
c0d01e20:	4607      	mov	r7, r0
c0d01e22:	2800      	cmp	r0, #0
c0d01e24:	d032      	beq.n	c0d01e8c <snprintf+0x400>
c0d01e26:	9809      	ldr	r0, [sp, #36]	; 0x24

s_pad:
                    //
                    // Write any required padding spaces
                    //
                    if(ulCount > ulIdx)
c0d01e28:	42a0      	cmp	r0, r4
c0d01e2a:	d986      	bls.n	c0d01d3a <snprintf+0x2ae>
                    {
                        ulCount -= ulIdx;
c0d01e2c:	1b04      	subs	r4, r0, r4
c0d01e2e:	463e      	mov	r6, r7
                        ulCount = MIN(ulCount, str_size);
c0d01e30:	42b4      	cmp	r4, r6
c0d01e32:	d300      	bcc.n	c0d01e36 <snprintf+0x3aa>
c0d01e34:	4634      	mov	r4, r6
                        os_memset(str, ' ', ulCount);
c0d01e36:	2120      	movs	r1, #32
c0d01e38:	9f0a      	ldr	r7, [sp, #40]	; 0x28
c0d01e3a:	4638      	mov	r0, r7
c0d01e3c:	4622      	mov	r2, r4
c0d01e3e:	f7fe ff31 	bl	c0d00ca4 <os_memset>
                        str+= ulCount;
                        str_size -= ulCount;
c0d01e42:	1b36      	subs	r6, r6, r4
                    if(ulCount > ulIdx)
                    {
                        ulCount -= ulIdx;
                        ulCount = MIN(ulCount, str_size);
                        os_memset(str, ' ', ulCount);
                        str+= ulCount;
c0d01e44:	193f      	adds	r7, r7, r4
c0d01e46:	970a      	str	r7, [sp, #40]	; 0x28
c0d01e48:	4637      	mov	r7, r6
                        str_size -= ulCount;
                        if (str_size == 0) {
c0d01e4a:	2e00      	cmp	r6, #0
c0d01e4c:	d01e      	beq.n	c0d01e8c <snprintf+0x400>
c0d01e4e:	e774      	b.n	c0d01d3a <snprintf+0x2ae>
c0d01e50:	461f      	mov	r7, r3
c0d01e52:	900a      	str	r0, [sp, #40]	; 0x28
c0d01e54:	e771      	b.n	c0d01d3a <snprintf+0x2ae>
    while(*format)
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0d01e56:	460e      	mov	r6, r1
c0d01e58:	9c07      	ldr	r4, [sp, #28]
c0d01e5a:	e003      	b.n	c0d01e64 <snprintf+0x3d8>
c0d01e5c:	1928      	adds	r0, r5, r4
c0d01e5e:	7840      	ldrb	r0, [r0, #1]
c0d01e60:	1e76      	subs	r6, r6, #1
            ulIdx++)
c0d01e62:	1c64      	adds	r4, r4, #1
c0d01e64:	b2c0      	uxtb	r0, r0
    while(*format)
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0d01e66:	2800      	cmp	r0, #0
c0d01e68:	d001      	beq.n	c0d01e6e <snprintf+0x3e2>
c0d01e6a:	2825      	cmp	r0, #37	; 0x25
c0d01e6c:	d1f6      	bne.n	c0d01e5c <snprintf+0x3d0>
        }

        //
        // Write this portion of the string.
        //
        ulIdx = MIN(ulIdx, str_size);
c0d01e6e:	42bc      	cmp	r4, r7
c0d01e70:	d300      	bcc.n	c0d01e74 <snprintf+0x3e8>
c0d01e72:	463c      	mov	r4, r7
        os_memmove(str, format, ulIdx);
c0d01e74:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01e76:	4629      	mov	r1, r5
c0d01e78:	4622      	mov	r2, r4
c0d01e7a:	f7fe ff1c 	bl	c0d00cb6 <os_memmove>
c0d01e7e:	9706      	str	r7, [sp, #24]
        str+= ulIdx;
        str_size -= ulIdx;
c0d01e80:	1b3f      	subs	r7, r7, r4
        //
        // Write this portion of the string.
        //
        ulIdx = MIN(ulIdx, str_size);
        os_memmove(str, format, ulIdx);
        str+= ulIdx;
c0d01e82:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01e84:	1902      	adds	r2, r0, r4
        str_size -= ulIdx;
        if (str_size == 0) {
c0d01e86:	2f00      	cmp	r7, #0
c0d01e88:	d000      	beq.n	c0d01e8c <snprintf+0x400>
c0d01e8a:	e621      	b.n	c0d01ad0 <snprintf+0x44>
    // End the varargs processing.
    //
    va_end(vaArgP);

    return 0;
}
c0d01e8c:	2000      	movs	r0, #0
c0d01e8e:	b010      	add	sp, #64	; 0x40
c0d01e90:	bcf0      	pop	{r4, r5, r6, r7}
c0d01e92:	bc02      	pop	{r1}
c0d01e94:	b001      	add	sp, #4
c0d01e96:	4708      	bx	r1
c0d01e98:	000026b0 	.word	0x000026b0
c0d01e9c:	00002612 	.word	0x00002612
c0d01ea0:	00002608 	.word	0x00002608
c0d01ea4:	00002700 	.word	0x00002700
c0d01ea8:	00002716 	.word	0x00002716

c0d01eac <pic>:

// only apply PIC conversion if link_address is in linked code (over 0xC0D00000 in our example)
// this way, PIC call are armless if the address is not meant to be converted
extern unsigned int _nvram;
extern unsigned int _envram;
unsigned int pic(unsigned int link_address) {
c0d01eac:	b580      	push	{r7, lr}
//  screen_printf(" %08X", link_address);
	if (link_address >= ((unsigned int)&_nvram) && link_address < ((unsigned int)&_envram)) {
c0d01eae:	4904      	ldr	r1, [pc, #16]	; (c0d01ec0 <pic+0x14>)
c0d01eb0:	4288      	cmp	r0, r1
c0d01eb2:	d304      	bcc.n	c0d01ebe <pic+0x12>
c0d01eb4:	4903      	ldr	r1, [pc, #12]	; (c0d01ec4 <pic+0x18>)
c0d01eb6:	4288      	cmp	r0, r1
c0d01eb8:	d201      	bcs.n	c0d01ebe <pic+0x12>
		link_address = pic_internal(link_address);
c0d01eba:	f000 f805 	bl	c0d01ec8 <pic_internal>
//    screen_printf(" -> %08X\n", link_address);
  }
	return link_address;
c0d01ebe:	bd80      	pop	{r7, pc}
c0d01ec0:	c0d00000 	.word	0xc0d00000
c0d01ec4:	c0d04940 	.word	0xc0d04940

c0d01ec8 <pic_internal>:

unsigned int pic_internal(unsigned int link_address) __attribute__((naked));
unsigned int pic_internal(unsigned int link_address) 
{
  // compute the delta offset between LinkMemAddr & ExecMemAddr
  __asm volatile ("mov r2, pc\n");          // r2 = 0x109004
c0d01ec8:	467a      	mov	r2, pc
  __asm volatile ("ldr r1, =pic_internal\n");        // r1 = 0xC0D00001
c0d01eca:	4902      	ldr	r1, [pc, #8]	; (c0d01ed4 <pic_internal+0xc>)
  __asm volatile ("adds r1, r1, #3\n");     // r1 = 0xC0D00004
c0d01ecc:	1cc9      	adds	r1, r1, #3
  __asm volatile ("subs r1, r1, r2\n");     // r1 = 0xC0BF7000 (delta between load and exec address)
c0d01ece:	1a89      	subs	r1, r1, r2

  // adjust value of the given parameter
  __asm volatile ("subs r0, r0, r1\n");     // r0 = 0xC0D0C244 => r0 = 0x115244
c0d01ed0:	1a40      	subs	r0, r0, r1
  __asm volatile ("bx lr\n");
c0d01ed2:	4770      	bx	lr
c0d01ed4:	c0d01ec9 	.word	0xc0d01ec9

c0d01ed8 <SVC_Call>:
  // avoid a separate asm file, but avoid any intrusion from the compiler
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) __attribute__ ((naked));
  //                    r0                       r1
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) {
    // delegate svc
    asm volatile("svc #1":::"r0","r1");
c0d01ed8:	df01      	svc	1
    // directly return R0 value
    asm volatile("bx  lr");
c0d01eda:	4770      	bx	lr

c0d01edc <check_api_level>:
  }
  void check_api_level ( unsigned int apiLevel ) 
{
c0d01edc:	b580      	push	{r7, lr}
c0d01ede:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
c0d01ee0:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
c0d01ee2:	4807      	ldr	r0, [pc, #28]	; (c0d01f00 <check_api_level+0x24>)
c0d01ee4:	4669      	mov	r1, sp
c0d01ee6:	f7ff fff7 	bl	c0d01ed8 <SVC_Call>
c0d01eea:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01eec:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_check_api_level_ID_OUT) {
c0d01eee:	4905      	ldr	r1, [pc, #20]	; (c0d01f04 <check_api_level+0x28>)
c0d01ef0:	4288      	cmp	r0, r1
c0d01ef2:	d101      	bne.n	c0d01ef8 <check_api_level+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d01ef4:	b002      	add	sp, #8
c0d01ef6:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_check_api_level_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01ef8:	2004      	movs	r0, #4
c0d01efa:	f7fe ff90 	bl	c0d00e1e <os_longjmp>
c0d01efe:	46c0      	nop			; (mov r8, r8)
c0d01f00:	60000137 	.word	0x60000137
c0d01f04:	900001c6 	.word	0x900001c6

c0d01f08 <reset>:
  }
}

void reset ( void ) 
{
c0d01f08:	b580      	push	{r7, lr}
c0d01f0a:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
c0d01f0c:	4806      	ldr	r0, [pc, #24]	; (c0d01f28 <reset+0x20>)
c0d01f0e:	a901      	add	r1, sp, #4
c0d01f10:	f7ff ffe2 	bl	c0d01ed8 <SVC_Call>
c0d01f14:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01f16:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_reset_ID_OUT) {
c0d01f18:	4904      	ldr	r1, [pc, #16]	; (c0d01f2c <reset+0x24>)
c0d01f1a:	4288      	cmp	r0, r1
c0d01f1c:	d101      	bne.n	c0d01f22 <reset+0x1a>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d01f1e:	b002      	add	sp, #8
c0d01f20:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_reset_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01f22:	2004      	movs	r0, #4
c0d01f24:	f7fe ff7b 	bl	c0d00e1e <os_longjmp>
c0d01f28:	60000200 	.word	0x60000200
c0d01f2c:	900002f1 	.word	0x900002f1

c0d01f30 <cx_rng>:
  }
  return (unsigned char)ret;
}

unsigned char * cx_rng ( unsigned char * buffer, unsigned int len ) 
{
c0d01f30:	b580      	push	{r7, lr}
c0d01f32:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d01f34:	9001      	str	r0, [sp, #4]
  parameters[1] = (unsigned int)len;
c0d01f36:	9102      	str	r1, [sp, #8]
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
c0d01f38:	4807      	ldr	r0, [pc, #28]	; (c0d01f58 <cx_rng+0x28>)
c0d01f3a:	a901      	add	r1, sp, #4
c0d01f3c:	f7ff ffcc 	bl	c0d01ed8 <SVC_Call>
c0d01f40:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01f42:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_rng_ID_OUT) {
c0d01f44:	4905      	ldr	r1, [pc, #20]	; (c0d01f5c <cx_rng+0x2c>)
c0d01f46:	4288      	cmp	r0, r1
c0d01f48:	d102      	bne.n	c0d01f50 <cx_rng+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned char *)ret;
c0d01f4a:	9803      	ldr	r0, [sp, #12]
c0d01f4c:	b004      	add	sp, #16
c0d01f4e:	bd80      	pop	{r7, pc}
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_rng_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01f50:	2004      	movs	r0, #4
c0d01f52:	f7fe ff64 	bl	c0d00e1e <os_longjmp>
c0d01f56:	46c0      	nop			; (mov r8, r8)
c0d01f58:	6000052c 	.word	0x6000052c
c0d01f5c:	90000567 	.word	0x90000567

c0d01f60 <cx_hash>:
  }
  return (int)ret;
}

int cx_hash ( cx_hash_t * hash, int mode, const unsigned char * in, unsigned int len, unsigned char * out, unsigned int out_len ) 
{
c0d01f60:	b580      	push	{r7, lr}
c0d01f62:	b088      	sub	sp, #32
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+6];
  parameters[0] = (unsigned int)hash;
c0d01f64:	af01      	add	r7, sp, #4
c0d01f66:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d01f68:	980a      	ldr	r0, [sp, #40]	; 0x28
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)in;
  parameters[3] = (unsigned int)len;
  parameters[4] = (unsigned int)out;
c0d01f6a:	9005      	str	r0, [sp, #20]
c0d01f6c:	980b      	ldr	r0, [sp, #44]	; 0x2c
  parameters[5] = (unsigned int)out_len;
c0d01f6e:	9006      	str	r0, [sp, #24]
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
c0d01f70:	4807      	ldr	r0, [pc, #28]	; (c0d01f90 <cx_hash+0x30>)
c0d01f72:	a901      	add	r1, sp, #4
c0d01f74:	f7ff ffb0 	bl	c0d01ed8 <SVC_Call>
c0d01f78:	aa07      	add	r2, sp, #28
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01f7a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_hash_ID_OUT) {
c0d01f7c:	4905      	ldr	r1, [pc, #20]	; (c0d01f94 <cx_hash+0x34>)
c0d01f7e:	4288      	cmp	r0, r1
c0d01f80:	d102      	bne.n	c0d01f88 <cx_hash+0x28>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d01f82:	9807      	ldr	r0, [sp, #28]
c0d01f84:	b008      	add	sp, #32
c0d01f86:	bd80      	pop	{r7, pc}
  parameters[4] = (unsigned int)out;
  parameters[5] = (unsigned int)out_len;
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_hash_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01f88:	2004      	movs	r0, #4
c0d01f8a:	f7fe ff48 	bl	c0d00e1e <os_longjmp>
c0d01f8e:	46c0      	nop			; (mov r8, r8)
c0d01f90:	6000073b 	.word	0x6000073b
c0d01f94:	900007ad 	.word	0x900007ad

c0d01f98 <cx_ripemd160_init>:
  }
  return (int)ret;
}

int cx_ripemd160_init ( cx_ripemd160_t * hash ) 
{
c0d01f98:	b580      	push	{r7, lr}
c0d01f9a:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
c0d01f9c:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_cx_ripemd160_init_ID_IN, parameters);
c0d01f9e:	4807      	ldr	r0, [pc, #28]	; (c0d01fbc <cx_ripemd160_init+0x24>)
c0d01fa0:	4669      	mov	r1, sp
c0d01fa2:	f7ff ff99 	bl	c0d01ed8 <SVC_Call>
c0d01fa6:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01fa8:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ripemd160_init_ID_OUT) {
c0d01faa:	4905      	ldr	r1, [pc, #20]	; (c0d01fc0 <cx_ripemd160_init+0x28>)
c0d01fac:	4288      	cmp	r0, r1
c0d01fae:	d102      	bne.n	c0d01fb6 <cx_ripemd160_init+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d01fb0:	9801      	ldr	r0, [sp, #4]
c0d01fb2:	b002      	add	sp, #8
c0d01fb4:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
  retid = SVC_Call(SYSCALL_cx_ripemd160_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ripemd160_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01fb6:	2004      	movs	r0, #4
c0d01fb8:	f7fe ff31 	bl	c0d00e1e <os_longjmp>
c0d01fbc:	6000087f 	.word	0x6000087f
c0d01fc0:	900008f8 	.word	0x900008f8

c0d01fc4 <cx_sha256_init>:
  }
  return (int)ret;
}

int cx_sha256_init ( cx_sha256_t * hash ) 
{
c0d01fc4:	b580      	push	{r7, lr}
c0d01fc6:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
c0d01fc8:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_cx_sha256_init_ID_IN, parameters);
c0d01fca:	4807      	ldr	r0, [pc, #28]	; (c0d01fe8 <cx_sha256_init+0x24>)
c0d01fcc:	4669      	mov	r1, sp
c0d01fce:	f7ff ff83 	bl	c0d01ed8 <SVC_Call>
c0d01fd2:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01fd4:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_sha256_init_ID_OUT) {
c0d01fd6:	4905      	ldr	r1, [pc, #20]	; (c0d01fec <cx_sha256_init+0x28>)
c0d01fd8:	4288      	cmp	r0, r1
c0d01fda:	d102      	bne.n	c0d01fe2 <cx_sha256_init+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d01fdc:	9801      	ldr	r0, [sp, #4]
c0d01fde:	b002      	add	sp, #8
c0d01fe0:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
  retid = SVC_Call(SYSCALL_cx_sha256_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_sha256_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01fe2:	2004      	movs	r0, #4
c0d01fe4:	f7fe ff1b 	bl	c0d00e1e <os_longjmp>
c0d01fe8:	60000adb 	.word	0x60000adb
c0d01fec:	90000a64 	.word	0x90000a64

c0d01ff0 <cx_ecfp_init_public_key>:
  }
  return (int)ret;
}

int cx_ecfp_init_public_key ( cx_curve_t curve, const unsigned char * rawkey, unsigned int key_len, cx_ecfp_public_key_t * key ) 
{
c0d01ff0:	b580      	push	{r7, lr}
c0d01ff2:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d01ff4:	af01      	add	r7, sp, #4
c0d01ff6:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)rawkey;
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_public_key_ID_IN, parameters);
c0d01ff8:	4807      	ldr	r0, [pc, #28]	; (c0d02018 <cx_ecfp_init_public_key+0x28>)
c0d01ffa:	a901      	add	r1, sp, #4
c0d01ffc:	f7ff ff6c 	bl	c0d01ed8 <SVC_Call>
c0d02000:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02002:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_init_public_key_ID_OUT) {
c0d02004:	4905      	ldr	r1, [pc, #20]	; (c0d0201c <cx_ecfp_init_public_key+0x2c>)
c0d02006:	4288      	cmp	r0, r1
c0d02008:	d102      	bne.n	c0d02010 <cx_ecfp_init_public_key+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d0200a:	9805      	ldr	r0, [sp, #20]
c0d0200c:	b006      	add	sp, #24
c0d0200e:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_public_key_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_init_public_key_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02010:	2004      	movs	r0, #4
c0d02012:	f7fe ff04 	bl	c0d00e1e <os_longjmp>
c0d02016:	46c0      	nop			; (mov r8, r8)
c0d02018:	60002ded 	.word	0x60002ded
c0d0201c:	90002d49 	.word	0x90002d49

c0d02020 <cx_ecfp_init_private_key>:
  }
  return (int)ret;
}

int cx_ecfp_init_private_key ( cx_curve_t curve, const unsigned char * rawkey, unsigned int key_len, cx_ecfp_private_key_t * pvkey ) 
{
c0d02020:	b580      	push	{r7, lr}
c0d02022:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d02024:	af01      	add	r7, sp, #4
c0d02026:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)rawkey;
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)pvkey;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_private_key_ID_IN, parameters);
c0d02028:	4807      	ldr	r0, [pc, #28]	; (c0d02048 <cx_ecfp_init_private_key+0x28>)
c0d0202a:	a901      	add	r1, sp, #4
c0d0202c:	f7ff ff54 	bl	c0d01ed8 <SVC_Call>
c0d02030:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02032:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_init_private_key_ID_OUT) {
c0d02034:	4905      	ldr	r1, [pc, #20]	; (c0d0204c <cx_ecfp_init_private_key+0x2c>)
c0d02036:	4288      	cmp	r0, r1
c0d02038:	d102      	bne.n	c0d02040 <cx_ecfp_init_private_key+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d0203a:	9805      	ldr	r0, [sp, #20]
c0d0203c:	b006      	add	sp, #24
c0d0203e:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)pvkey;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_private_key_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_init_private_key_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02040:	2004      	movs	r0, #4
c0d02042:	f7fe feec 	bl	c0d00e1e <os_longjmp>
c0d02046:	46c0      	nop			; (mov r8, r8)
c0d02048:	60002eea 	.word	0x60002eea
c0d0204c:	90002e63 	.word	0x90002e63

c0d02050 <cx_ecfp_generate_pair>:
  }
  return (int)ret;
}

int cx_ecfp_generate_pair ( cx_curve_t curve, cx_ecfp_public_key_t * pubkey, cx_ecfp_private_key_t * privkey, int keepprivate ) 
{
c0d02050:	b580      	push	{r7, lr}
c0d02052:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d02054:	af01      	add	r7, sp, #4
c0d02056:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)pubkey;
  parameters[2] = (unsigned int)privkey;
  parameters[3] = (unsigned int)keepprivate;
  retid = SVC_Call(SYSCALL_cx_ecfp_generate_pair_ID_IN, parameters);
c0d02058:	4807      	ldr	r0, [pc, #28]	; (c0d02078 <cx_ecfp_generate_pair+0x28>)
c0d0205a:	a901      	add	r1, sp, #4
c0d0205c:	f7ff ff3c 	bl	c0d01ed8 <SVC_Call>
c0d02060:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02062:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_generate_pair_ID_OUT) {
c0d02064:	4905      	ldr	r1, [pc, #20]	; (c0d0207c <cx_ecfp_generate_pair+0x2c>)
c0d02066:	4288      	cmp	r0, r1
c0d02068:	d102      	bne.n	c0d02070 <cx_ecfp_generate_pair+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d0206a:	9805      	ldr	r0, [sp, #20]
c0d0206c:	b006      	add	sp, #24
c0d0206e:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)privkey;
  parameters[3] = (unsigned int)keepprivate;
  retid = SVC_Call(SYSCALL_cx_ecfp_generate_pair_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_generate_pair_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02070:	2004      	movs	r0, #4
c0d02072:	f7fe fed4 	bl	c0d00e1e <os_longjmp>
c0d02076:	46c0      	nop			; (mov r8, r8)
c0d02078:	60002f2e 	.word	0x60002f2e
c0d0207c:	90002f74 	.word	0x90002f74

c0d02080 <cx_ecdsa_sign>:
  }
  return (int)ret;
}

int cx_ecdsa_sign ( const cx_ecfp_private_key_t * pvkey, int mode, cx_md_t hashID, const unsigned char * hash, unsigned int hash_len, unsigned char * sig, unsigned int sig_len, unsigned int * info ) 
{
c0d02080:	b580      	push	{r7, lr}
c0d02082:	b08a      	sub	sp, #40	; 0x28
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+8];
  parameters[0] = (unsigned int)pvkey;
c0d02084:	af01      	add	r7, sp, #4
c0d02086:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d02088:	980c      	ldr	r0, [sp, #48]	; 0x30
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)hashID;
  parameters[3] = (unsigned int)hash;
  parameters[4] = (unsigned int)hash_len;
c0d0208a:	9005      	str	r0, [sp, #20]
c0d0208c:	980d      	ldr	r0, [sp, #52]	; 0x34
  parameters[5] = (unsigned int)sig;
c0d0208e:	9006      	str	r0, [sp, #24]
c0d02090:	980e      	ldr	r0, [sp, #56]	; 0x38
  parameters[6] = (unsigned int)sig_len;
c0d02092:	9007      	str	r0, [sp, #28]
c0d02094:	980f      	ldr	r0, [sp, #60]	; 0x3c
  parameters[7] = (unsigned int)info;
c0d02096:	9008      	str	r0, [sp, #32]
  retid = SVC_Call(SYSCALL_cx_ecdsa_sign_ID_IN, parameters);
c0d02098:	4807      	ldr	r0, [pc, #28]	; (c0d020b8 <cx_ecdsa_sign+0x38>)
c0d0209a:	a901      	add	r1, sp, #4
c0d0209c:	f7ff ff1c 	bl	c0d01ed8 <SVC_Call>
c0d020a0:	aa09      	add	r2, sp, #36	; 0x24
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d020a2:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecdsa_sign_ID_OUT) {
c0d020a4:	4905      	ldr	r1, [pc, #20]	; (c0d020bc <cx_ecdsa_sign+0x3c>)
c0d020a6:	4288      	cmp	r0, r1
c0d020a8:	d102      	bne.n	c0d020b0 <cx_ecdsa_sign+0x30>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d020aa:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d020ac:	b00a      	add	sp, #40	; 0x28
c0d020ae:	bd80      	pop	{r7, pc}
  parameters[6] = (unsigned int)sig_len;
  parameters[7] = (unsigned int)info;
  retid = SVC_Call(SYSCALL_cx_ecdsa_sign_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecdsa_sign_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d020b0:	2004      	movs	r0, #4
c0d020b2:	f7fe feb4 	bl	c0d00e1e <os_longjmp>
c0d020b6:	46c0      	nop			; (mov r8, r8)
c0d020b8:	600038f3 	.word	0x600038f3
c0d020bc:	90003876 	.word	0x90003876

c0d020c0 <cx_crc16_update>:
  }
  return (unsigned short)ret;
}

unsigned short cx_crc16_update ( unsigned short crc, const void * buffer, unsigned int len ) 
{
c0d020c0:	b580      	push	{r7, lr}
c0d020c2:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)crc;
c0d020c4:	ab00      	add	r3, sp, #0
c0d020c6:	c307      	stmia	r3!, {r0, r1, r2}
  parameters[1] = (unsigned int)buffer;
  parameters[2] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_crc16_update_ID_IN, parameters);
c0d020c8:	4807      	ldr	r0, [pc, #28]	; (c0d020e8 <cx_crc16_update+0x28>)
c0d020ca:	4669      	mov	r1, sp
c0d020cc:	f7ff ff04 	bl	c0d01ed8 <SVC_Call>
c0d020d0:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d020d2:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_crc16_update_ID_OUT) {
c0d020d4:	4905      	ldr	r1, [pc, #20]	; (c0d020ec <cx_crc16_update+0x2c>)
c0d020d6:	4288      	cmp	r0, r1
c0d020d8:	d103      	bne.n	c0d020e2 <cx_crc16_update+0x22>
c0d020da:	a803      	add	r0, sp, #12
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned short)ret;
c0d020dc:	8800      	ldrh	r0, [r0, #0]
c0d020de:	b004      	add	sp, #16
c0d020e0:	bd80      	pop	{r7, pc}
  parameters[1] = (unsigned int)buffer;
  parameters[2] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_crc16_update_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_crc16_update_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d020e2:	2004      	movs	r0, #4
c0d020e4:	f7fe fe9b 	bl	c0d00e1e <os_longjmp>
c0d020e8:	60003c9e 	.word	0x60003c9e
c0d020ec:	90003cb9 	.word	0x90003cb9

c0d020f0 <os_perso_derive_node_bip32>:
  }
  return (unsigned int)ret;
}

void os_perso_derive_node_bip32 ( cx_curve_t curve, const unsigned int * path, unsigned int pathLength, unsigned char * privateKey, unsigned char * chain ) 
{
c0d020f0:	b580      	push	{r7, lr}
c0d020f2:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)curve;
c0d020f4:	af00      	add	r7, sp, #0
c0d020f6:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d020f8:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)path;
  parameters[2] = (unsigned int)pathLength;
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
c0d020fa:	9004      	str	r0, [sp, #16]
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
c0d020fc:	4806      	ldr	r0, [pc, #24]	; (c0d02118 <os_perso_derive_node_bip32+0x28>)
c0d020fe:	4669      	mov	r1, sp
c0d02100:	f7ff feea 	bl	c0d01ed8 <SVC_Call>
c0d02104:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02106:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
c0d02108:	4904      	ldr	r1, [pc, #16]	; (c0d0211c <os_perso_derive_node_bip32+0x2c>)
c0d0210a:	4288      	cmp	r0, r1
c0d0210c:	d101      	bne.n	c0d02112 <os_perso_derive_node_bip32+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d0210e:	b006      	add	sp, #24
c0d02110:	bd80      	pop	{r7, pc}
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02112:	2004      	movs	r0, #4
c0d02114:	f7fe fe83 	bl	c0d00e1e <os_longjmp>
c0d02118:	600053ba 	.word	0x600053ba
c0d0211c:	9000531e 	.word	0x9000531e

c0d02120 <os_sched_exit>:
  }
  return (unsigned int)ret;
}

void os_sched_exit ( unsigned int exit_code ) 
{
c0d02120:	b580      	push	{r7, lr}
c0d02122:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
c0d02124:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
c0d02126:	4807      	ldr	r0, [pc, #28]	; (c0d02144 <os_sched_exit+0x24>)
c0d02128:	4669      	mov	r1, sp
c0d0212a:	f7ff fed5 	bl	c0d01ed8 <SVC_Call>
c0d0212e:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02130:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
c0d02132:	4905      	ldr	r1, [pc, #20]	; (c0d02148 <os_sched_exit+0x28>)
c0d02134:	4288      	cmp	r0, r1
c0d02136:	d101      	bne.n	c0d0213c <os_sched_exit+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d02138:	b002      	add	sp, #8
c0d0213a:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0213c:	2004      	movs	r0, #4
c0d0213e:	f7fe fe6e 	bl	c0d00e1e <os_longjmp>
c0d02142:	46c0      	nop			; (mov r8, r8)
c0d02144:	600062e1 	.word	0x600062e1
c0d02148:	9000626f 	.word	0x9000626f

c0d0214c <os_ux>:
    THROW(EXCEPTION_SECURITY);
  }
}

unsigned int os_ux ( bolos_ux_params_t * params ) 
{
c0d0214c:	b580      	push	{r7, lr}
c0d0214e:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
c0d02150:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
c0d02152:	4807      	ldr	r0, [pc, #28]	; (c0d02170 <os_ux+0x24>)
c0d02154:	4669      	mov	r1, sp
c0d02156:	f7ff febf 	bl	c0d01ed8 <SVC_Call>
c0d0215a:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0215c:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_ux_ID_OUT) {
c0d0215e:	4905      	ldr	r1, [pc, #20]	; (c0d02174 <os_ux+0x28>)
c0d02160:	4288      	cmp	r0, r1
c0d02162:	d102      	bne.n	c0d0216a <os_ux+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d02164:	9801      	ldr	r0, [sp, #4]
c0d02166:	b002      	add	sp, #8
c0d02168:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_ux_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0216a:	2004      	movs	r0, #4
c0d0216c:	f7fe fe57 	bl	c0d00e1e <os_longjmp>
c0d02170:	60006458 	.word	0x60006458
c0d02174:	9000641f 	.word	0x9000641f

c0d02178 <os_flags>:
    THROW(EXCEPTION_SECURITY);
  }
}

unsigned int os_flags ( void ) 
{
c0d02178:	b580      	push	{r7, lr}
c0d0217a:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_flags_ID_IN, parameters);
c0d0217c:	4807      	ldr	r0, [pc, #28]	; (c0d0219c <os_flags+0x24>)
c0d0217e:	a901      	add	r1, sp, #4
c0d02180:	f7ff feaa 	bl	c0d01ed8 <SVC_Call>
c0d02184:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02186:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_flags_ID_OUT) {
c0d02188:	4905      	ldr	r1, [pc, #20]	; (c0d021a0 <os_flags+0x28>)
c0d0218a:	4288      	cmp	r0, r1
c0d0218c:	d102      	bne.n	c0d02194 <os_flags+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d0218e:	9800      	ldr	r0, [sp, #0]
c0d02190:	b002      	add	sp, #8
c0d02192:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_flags_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_flags_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02194:	2004      	movs	r0, #4
c0d02196:	f7fe fe42 	bl	c0d00e1e <os_longjmp>
c0d0219a:	46c0      	nop			; (mov r8, r8)
c0d0219c:	6000686e 	.word	0x6000686e
c0d021a0:	9000687f 	.word	0x9000687f

c0d021a4 <os_registry_get_current_app_tag>:
  }
  return (unsigned int)ret;
}

unsigned int os_registry_get_current_app_tag ( unsigned int tag, unsigned char * buffer, unsigned int maxlen ) 
{
c0d021a4:	b580      	push	{r7, lr}
c0d021a6:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)tag;
c0d021a8:	ab00      	add	r3, sp, #0
c0d021aa:	c307      	stmia	r3!, {r0, r1, r2}
  parameters[1] = (unsigned int)buffer;
  parameters[2] = (unsigned int)maxlen;
  retid = SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID_IN, parameters);
c0d021ac:	4807      	ldr	r0, [pc, #28]	; (c0d021cc <os_registry_get_current_app_tag+0x28>)
c0d021ae:	4669      	mov	r1, sp
c0d021b0:	f7ff fe92 	bl	c0d01ed8 <SVC_Call>
c0d021b4:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d021b6:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_registry_get_current_app_tag_ID_OUT) {
c0d021b8:	4905      	ldr	r1, [pc, #20]	; (c0d021d0 <os_registry_get_current_app_tag+0x2c>)
c0d021ba:	4288      	cmp	r0, r1
c0d021bc:	d102      	bne.n	c0d021c4 <os_registry_get_current_app_tag+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d021be:	9803      	ldr	r0, [sp, #12]
c0d021c0:	b004      	add	sp, #16
c0d021c2:	bd80      	pop	{r7, pc}
  parameters[1] = (unsigned int)buffer;
  parameters[2] = (unsigned int)maxlen;
  retid = SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_registry_get_current_app_tag_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d021c4:	2004      	movs	r0, #4
c0d021c6:	f7fe fe2a 	bl	c0d00e1e <os_longjmp>
c0d021ca:	46c0      	nop			; (mov r8, r8)
c0d021cc:	600070d4 	.word	0x600070d4
c0d021d0:	90007087 	.word	0x90007087

c0d021d4 <io_seproxyhal_spi_send>:
  }
  return (unsigned int)ret;
}

void io_seproxyhal_spi_send ( const unsigned char * buffer, unsigned short length ) 
{
c0d021d4:	b580      	push	{r7, lr}
c0d021d6:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d021d8:	9001      	str	r0, [sp, #4]
  parameters[1] = (unsigned int)length;
c0d021da:	9102      	str	r1, [sp, #8]
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
c0d021dc:	4806      	ldr	r0, [pc, #24]	; (c0d021f8 <io_seproxyhal_spi_send+0x24>)
c0d021de:	a901      	add	r1, sp, #4
c0d021e0:	f7ff fe7a 	bl	c0d01ed8 <SVC_Call>
c0d021e4:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d021e6:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
c0d021e8:	4904      	ldr	r1, [pc, #16]	; (c0d021fc <io_seproxyhal_spi_send+0x28>)
c0d021ea:	4288      	cmp	r0, r1
c0d021ec:	d101      	bne.n	c0d021f2 <io_seproxyhal_spi_send+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d021ee:	b004      	add	sp, #16
c0d021f0:	bd80      	pop	{r7, pc}
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d021f2:	2004      	movs	r0, #4
c0d021f4:	f7fe fe13 	bl	c0d00e1e <os_longjmp>
c0d021f8:	6000721c 	.word	0x6000721c
c0d021fc:	900072f3 	.word	0x900072f3

c0d02200 <io_seproxyhal_spi_is_status_sent>:
  }
}

unsigned int io_seproxyhal_spi_is_status_sent ( void ) 
{
c0d02200:	b580      	push	{r7, lr}
c0d02202:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
c0d02204:	4807      	ldr	r0, [pc, #28]	; (c0d02224 <io_seproxyhal_spi_is_status_sent+0x24>)
c0d02206:	a901      	add	r1, sp, #4
c0d02208:	f7ff fe66 	bl	c0d01ed8 <SVC_Call>
c0d0220c:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0220e:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
c0d02210:	4905      	ldr	r1, [pc, #20]	; (c0d02228 <io_seproxyhal_spi_is_status_sent+0x28>)
c0d02212:	4288      	cmp	r0, r1
c0d02214:	d102      	bne.n	c0d0221c <io_seproxyhal_spi_is_status_sent+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d02216:	9800      	ldr	r0, [sp, #0]
c0d02218:	b002      	add	sp, #8
c0d0221a:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0221c:	2004      	movs	r0, #4
c0d0221e:	f7fe fdfe 	bl	c0d00e1e <os_longjmp>
c0d02222:	46c0      	nop			; (mov r8, r8)
c0d02224:	600073cf 	.word	0x600073cf
c0d02228:	9000737f 	.word	0x9000737f

c0d0222c <io_seproxyhal_spi_recv>:
  }
  return (unsigned int)ret;
}

unsigned short io_seproxyhal_spi_recv ( unsigned char * buffer, unsigned short maxlength, unsigned int flags ) 
{
c0d0222c:	b580      	push	{r7, lr}
c0d0222e:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)buffer;
c0d02230:	ab00      	add	r3, sp, #0
c0d02232:	c307      	stmia	r3!, {r0, r1, r2}
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
c0d02234:	4807      	ldr	r0, [pc, #28]	; (c0d02254 <io_seproxyhal_spi_recv+0x28>)
c0d02236:	4669      	mov	r1, sp
c0d02238:	f7ff fe4e 	bl	c0d01ed8 <SVC_Call>
c0d0223c:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0223e:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
c0d02240:	4905      	ldr	r1, [pc, #20]	; (c0d02258 <io_seproxyhal_spi_recv+0x2c>)
c0d02242:	4288      	cmp	r0, r1
c0d02244:	d103      	bne.n	c0d0224e <io_seproxyhal_spi_recv+0x22>
c0d02246:	a803      	add	r0, sp, #12
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned short)ret;
c0d02248:	8800      	ldrh	r0, [r0, #0]
c0d0224a:	b004      	add	sp, #16
c0d0224c:	bd80      	pop	{r7, pc}
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0224e:	2004      	movs	r0, #4
c0d02250:	f7fe fde5 	bl	c0d00e1e <os_longjmp>
c0d02254:	600074d1 	.word	0x600074d1
c0d02258:	9000742b 	.word	0x9000742b

c0d0225c <u2f_apdu_sign>:

    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)SW_INTERNAL, sizeof(SW_INTERNAL));
}

void u2f_apdu_sign(u2f_service_t *service, uint8_t p1, uint8_t p2,
                     uint8_t *buffer, uint16_t length) {
c0d0225c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0225e:	b085      	sub	sp, #20
    UNUSED(p2);
    uint8_t keyHandleLength;
    uint8_t i;

    // can't process the apdu if another one is already scheduled in
    if (G_io_apdu_state != APDU_IDLE) {
c0d02260:	4a34      	ldr	r2, [pc, #208]	; (c0d02334 <u2f_apdu_sign+0xd8>)
c0d02262:	7812      	ldrb	r2, [r2, #0]
    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02264:	2483      	movs	r4, #131	; 0x83
    UNUSED(p2);
    uint8_t keyHandleLength;
    uint8_t i;

    // can't process the apdu if another one is already scheduled in
    if (G_io_apdu_state != APDU_IDLE) {
c0d02266:	2a00      	cmp	r2, #0
c0d02268:	d002      	beq.n	c0d02270 <u2f_apdu_sign+0x14>
        u2f_message_reply(service, U2F_CMD_MSG,
c0d0226a:	4a3b      	ldr	r2, [pc, #236]	; (c0d02358 <u2f_apdu_sign+0xfc>)
c0d0226c:	447a      	add	r2, pc
c0d0226e:	e009      	b.n	c0d02284 <u2f_apdu_sign+0x28>
c0d02270:	9a0a      	ldr	r2, [sp, #40]	; 0x28
                  (uint8_t *)SW_BUSY,
                  sizeof(SW_BUSY));
        return;        
    }

    if (length < U2F_HANDLE_SIGN_HEADER_SIZE + 5 /*at least an apdu header*/) {
c0d02272:	2a45      	cmp	r2, #69	; 0x45
c0d02274:	d802      	bhi.n	c0d0227c <u2f_apdu_sign+0x20>
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02276:	4a39      	ldr	r2, [pc, #228]	; (c0d0235c <u2f_apdu_sign+0x100>)
c0d02278:	447a      	add	r2, pc
c0d0227a:	e003      	b.n	c0d02284 <u2f_apdu_sign+0x28>
                  sizeof(SW_WRONG_LENGTH));
        return;
    }
    
    // Confirm immediately if it's just a validation call
    if (p1 == P1_SIGN_CHECK_ONLY) {
c0d0227c:	2907      	cmp	r1, #7
c0d0227e:	d107      	bne.n	c0d02290 <u2f_apdu_sign+0x34>
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02280:	4a37      	ldr	r2, [pc, #220]	; (c0d02360 <u2f_apdu_sign+0x104>)
c0d02282:	447a      	add	r2, pc
c0d02284:	2302      	movs	r3, #2
c0d02286:	4621      	mov	r1, r4
c0d02288:	f000 fccf 	bl	c0d02c2a <u2f_message_reply>
    app_dispatch();
    if ((btchip_context_D.io_flags & IO_ASYNCH_REPLY) == 0) {
        u2f_proxy_response(service, btchip_context_D.outLength);
    }
    */
}
c0d0228c:	b005      	add	sp, #20
c0d0228e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02290:	9202      	str	r2, [sp, #8]
c0d02292:	9401      	str	r4, [sp, #4]
c0d02294:	9003      	str	r0, [sp, #12]
                  sizeof(SW_PROOF_OF_PRESENCE_REQUIRED));
        return;
    }

    // Unwrap magic
    keyHandleLength = buffer[U2F_HANDLE_SIGN_HEADER_SIZE-1];
c0d02296:	2040      	movs	r0, #64	; 0x40
c0d02298:	9304      	str	r3, [sp, #16]
c0d0229a:	5c1f      	ldrb	r7, [r3, r0]
    
    // reply to the "get magic" question of the host
    if (keyHandleLength == 5) {
c0d0229c:	2f00      	cmp	r7, #0
c0d0229e:	d018      	beq.n	c0d022d2 <u2f_apdu_sign+0x76>
c0d022a0:	2f05      	cmp	r7, #5
c0d022a2:	9e04      	ldr	r6, [sp, #16]
c0d022a4:	d107      	bne.n	c0d022b6 <u2f_apdu_sign+0x5a>
        // GET U2F PROXY PARAMETERS
        // this apdu is not subject to proxy magic masking
        // APDU is F1 D0 00 00 00 to get the magic proxy
        // RAPDU: <>
        if (os_memcmp(buffer+U2F_HANDLE_SIGN_HEADER_SIZE, "\xF1\xD0\x00\x00\x00", 5) == 0 ) {
c0d022a6:	4630      	mov	r0, r6
c0d022a8:	3041      	adds	r0, #65	; 0x41
c0d022aa:	a123      	add	r1, pc, #140	; (adr r1, c0d02338 <u2f_apdu_sign+0xdc>)
c0d022ac:	2205      	movs	r2, #5
c0d022ae:	f7fe fd9f 	bl	c0d00df0 <os_memcmp>
c0d022b2:	2800      	cmp	r0, #0
c0d022b4:	d02c      	beq.n	c0d02310 <u2f_apdu_sign+0xb4>
        }
    }
    

    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
c0d022b6:	3641      	adds	r6, #65	; 0x41
c0d022b8:	2400      	movs	r4, #0
c0d022ba:	a522      	add	r5, pc, #136	; (adr r5, c0d02344 <u2f_apdu_sign+0xe8>)
c0d022bc:	b2e0      	uxtb	r0, r4
c0d022be:	2103      	movs	r1, #3
c0d022c0:	f001 ff68 	bl	c0d04194 <__aeabi_uidivmod>
c0d022c4:	5d30      	ldrb	r0, [r6, r4]
c0d022c6:	5c69      	ldrb	r1, [r5, r1]
c0d022c8:	4041      	eors	r1, r0
c0d022ca:	5531      	strb	r1, [r6, r4]
            return;
        }
    }
    

    for (i = 0; i < keyHandleLength; i++) {
c0d022cc:	1c64      	adds	r4, r4, #1
c0d022ce:	42a7      	cmp	r7, r4
c0d022d0:	d1f4      	bne.n	c0d022bc <u2f_apdu_sign+0x60>
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
c0d022d2:	2045      	movs	r0, #69	; 0x45
c0d022d4:	9904      	ldr	r1, [sp, #16]
c0d022d6:	5c08      	ldrb	r0, [r1, r0]
c0d022d8:	3046      	adds	r0, #70	; 0x46
c0d022da:	9a02      	ldr	r2, [sp, #8]
c0d022dc:	4282      	cmp	r2, r0
c0d022de:	d111      	bne.n	c0d02304 <u2f_apdu_sign+0xa8>
                  sizeof(SW_BAD_KEY_HANDLE));
        return;
    }

    // make the apdu available to higher layers
    os_memmove(G_io_apdu_buffer, buffer + U2F_HANDLE_SIGN_HEADER_SIZE, keyHandleLength);
c0d022e0:	3141      	adds	r1, #65	; 0x41
c0d022e2:	4817      	ldr	r0, [pc, #92]	; (c0d02340 <u2f_apdu_sign+0xe4>)
c0d022e4:	463a      	mov	r2, r7
c0d022e6:	f7fe fce6 	bl	c0d00cb6 <os_memmove>
    G_io_apdu_length = keyHandleLength;
c0d022ea:	4819      	ldr	r0, [pc, #100]	; (c0d02350 <u2f_apdu_sign+0xf4>)
c0d022ec:	8007      	strh	r7, [r0, #0]
    G_io_apdu_media = IO_APDU_MEDIA_U2F; // the effective transport is managed by the U2F layer
c0d022ee:	4819      	ldr	r0, [pc, #100]	; (c0d02354 <u2f_apdu_sign+0xf8>)
c0d022f0:	2107      	movs	r1, #7
c0d022f2:	7001      	strb	r1, [r0, #0]
    G_io_apdu_state = APDU_U2F;
c0d022f4:	2009      	movs	r0, #9
c0d022f6:	490f      	ldr	r1, [pc, #60]	; (c0d02334 <u2f_apdu_sign+0xd8>)
c0d022f8:	7008      	strb	r0, [r1, #0]

    // prepare for asynch reply
    u2f_message_set_autoreply_wait_user_presence(service, true);
c0d022fa:	2101      	movs	r1, #1
c0d022fc:	9803      	ldr	r0, [sp, #12]
c0d022fe:	f000 fc69 	bl	c0d02bd4 <u2f_message_set_autoreply_wait_user_presence>
c0d02302:	e7c3      	b.n	c0d0228c <u2f_apdu_sign+0x30>
    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02304:	4a17      	ldr	r2, [pc, #92]	; (c0d02364 <u2f_apdu_sign+0x108>)
c0d02306:	447a      	add	r2, pc
c0d02308:	2302      	movs	r3, #2
c0d0230a:	9803      	ldr	r0, [sp, #12]
c0d0230c:	9901      	ldr	r1, [sp, #4]
c0d0230e:	e7bb      	b.n	c0d02288 <u2f_apdu_sign+0x2c>
        // this apdu is not subject to proxy magic masking
        // APDU is F1 D0 00 00 00 to get the magic proxy
        // RAPDU: <>
        if (os_memcmp(buffer+U2F_HANDLE_SIGN_HEADER_SIZE, "\xF1\xD0\x00\x00\x00", 5) == 0 ) {
            // U2F_PROXY_MAGIC is given as a 0 terminated string
            G_io_apdu_buffer[0] = sizeof(U2F_PROXY_MAGIC)-1;
c0d02310:	4e0b      	ldr	r6, [pc, #44]	; (c0d02340 <u2f_apdu_sign+0xe4>)
c0d02312:	2203      	movs	r2, #3
c0d02314:	7032      	strb	r2, [r6, #0]
            os_memmove(G_io_apdu_buffer+1, U2F_PROXY_MAGIC, sizeof(U2F_PROXY_MAGIC)-1);
c0d02316:	1c70      	adds	r0, r6, #1
c0d02318:	a10a      	add	r1, pc, #40	; (adr r1, c0d02344 <u2f_apdu_sign+0xe8>)
c0d0231a:	f7fe fccc 	bl	c0d00cb6 <os_memmove>
            os_memmove(G_io_apdu_buffer+1+sizeof(U2F_PROXY_MAGIC)-1, "\x90\x00\x90\x00", 4);
c0d0231e:	1d30      	adds	r0, r6, #4
c0d02320:	a109      	add	r1, pc, #36	; (adr r1, c0d02348 <u2f_apdu_sign+0xec>)
c0d02322:	2204      	movs	r2, #4
c0d02324:	f7fe fcc7 	bl	c0d00cb6 <os_memmove>
            u2f_message_reply(service, U2F_CMD_MSG,
                              (uint8_t *)G_io_apdu_buffer,
                              G_io_apdu_buffer[0]+1+2+2);
c0d02328:	7830      	ldrb	r0, [r6, #0]
c0d0232a:	1d43      	adds	r3, r0, #5
        if (os_memcmp(buffer+U2F_HANDLE_SIGN_HEADER_SIZE, "\xF1\xD0\x00\x00\x00", 5) == 0 ) {
            // U2F_PROXY_MAGIC is given as a 0 terminated string
            G_io_apdu_buffer[0] = sizeof(U2F_PROXY_MAGIC)-1;
            os_memmove(G_io_apdu_buffer+1, U2F_PROXY_MAGIC, sizeof(U2F_PROXY_MAGIC)-1);
            os_memmove(G_io_apdu_buffer+1+sizeof(U2F_PROXY_MAGIC)-1, "\x90\x00\x90\x00", 4);
            u2f_message_reply(service, U2F_CMD_MSG,
c0d0232c:	9803      	ldr	r0, [sp, #12]
c0d0232e:	9901      	ldr	r1, [sp, #4]
c0d02330:	4632      	mov	r2, r6
c0d02332:	e7a9      	b.n	c0d02288 <u2f_apdu_sign+0x2c>
c0d02334:	20001a6a 	.word	0x20001a6a
c0d02338:	0000d0f1 	.word	0x0000d0f1
c0d0233c:	00000000 	.word	0x00000000
c0d02340:	200018f8 	.word	0x200018f8
c0d02344:	00544e4f 	.word	0x00544e4f
c0d02348:	00900090 	.word	0x00900090
c0d0234c:	00000000 	.word	0x00000000
c0d02350:	20001a6c 	.word	0x20001a6c
c0d02354:	20001a54 	.word	0x20001a54
c0d02358:	0000216c 	.word	0x0000216c
c0d0235c:	00002162 	.word	0x00002162
c0d02360:	0000215a 	.word	0x0000215a
c0d02364:	000020d8 	.word	0x000020d8

c0d02368 <u2f_handle_cmd_init>:
}

#endif

void u2f_handle_cmd_init(u2f_service_t *service, uint8_t *buffer,
                         uint16_t length, uint8_t *channelInit) {
c0d02368:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0236a:	b081      	sub	sp, #4
c0d0236c:	461d      	mov	r5, r3
c0d0236e:	460e      	mov	r6, r1
c0d02370:	4604      	mov	r4, r0
    // screen_printf("U2F init\n");
    uint8_t channel[4];
    (void)length;
    if (u2f_is_channel_broadcast(channelInit)) {
c0d02372:	4628      	mov	r0, r5
c0d02374:	f000 fc1e 	bl	c0d02bb4 <u2f_is_channel_broadcast>
c0d02378:	2801      	cmp	r0, #1
c0d0237a:	d104      	bne.n	c0d02386 <u2f_handle_cmd_init+0x1e>
c0d0237c:	4668      	mov	r0, sp
        cx_rng(channel, 4);
c0d0237e:	2104      	movs	r1, #4
c0d02380:	f7ff fdd6 	bl	c0d01f30 <cx_rng>
c0d02384:	e004      	b.n	c0d02390 <u2f_handle_cmd_init+0x28>
c0d02386:	4668      	mov	r0, sp
    } else {
        os_memmove(channel, channelInit, 4);
c0d02388:	2204      	movs	r2, #4
c0d0238a:	4629      	mov	r1, r5
c0d0238c:	f7fe fc93 	bl	c0d00cb6 <os_memmove>
    }
    os_memmove(G_io_apdu_buffer, buffer, 8);
c0d02390:	4f17      	ldr	r7, [pc, #92]	; (c0d023f0 <u2f_handle_cmd_init+0x88>)
c0d02392:	2208      	movs	r2, #8
c0d02394:	4638      	mov	r0, r7
c0d02396:	4631      	mov	r1, r6
c0d02398:	f7fe fc8d 	bl	c0d00cb6 <os_memmove>
    os_memmove(G_io_apdu_buffer + 8, channel, 4);
c0d0239c:	4638      	mov	r0, r7
c0d0239e:	3008      	adds	r0, #8
c0d023a0:	4669      	mov	r1, sp
c0d023a2:	2204      	movs	r2, #4
c0d023a4:	f7fe fc87 	bl	c0d00cb6 <os_memmove>
    G_io_apdu_buffer[12] = INIT_U2F_VERSION;
c0d023a8:	2002      	movs	r0, #2
c0d023aa:	7338      	strb	r0, [r7, #12]
    G_io_apdu_buffer[13] = INIT_DEVICE_VERSION_MAJOR;
c0d023ac:	2000      	movs	r0, #0
c0d023ae:	7378      	strb	r0, [r7, #13]
c0d023b0:	2101      	movs	r1, #1
    G_io_apdu_buffer[14] = INIT_DEVICE_VERSION_MINOR;
c0d023b2:	73b9      	strb	r1, [r7, #14]
    G_io_apdu_buffer[15] = INIT_BUILD_VERSION;
c0d023b4:	73f8      	strb	r0, [r7, #15]
    G_io_apdu_buffer[16] = INIT_CAPABILITIES;
c0d023b6:	7438      	strb	r0, [r7, #16]

    if (u2f_is_channel_broadcast(channelInit)) {
c0d023b8:	4628      	mov	r0, r5
c0d023ba:	f000 fbfb 	bl	c0d02bb4 <u2f_is_channel_broadcast>
c0d023be:	4601      	mov	r1, r0
c0d023c0:	1d20      	adds	r0, r4, #4
        os_memset(service->channel, 0xff, 4);
c0d023c2:	2586      	movs	r5, #134	; 0x86
    G_io_apdu_buffer[13] = INIT_DEVICE_VERSION_MAJOR;
    G_io_apdu_buffer[14] = INIT_DEVICE_VERSION_MINOR;
    G_io_apdu_buffer[15] = INIT_BUILD_VERSION;
    G_io_apdu_buffer[16] = INIT_CAPABILITIES;

    if (u2f_is_channel_broadcast(channelInit)) {
c0d023c4:	2901      	cmp	r1, #1
c0d023c6:	d106      	bne.n	c0d023d6 <u2f_handle_cmd_init+0x6e>
        os_memset(service->channel, 0xff, 4);
c0d023c8:	4629      	mov	r1, r5
c0d023ca:	3179      	adds	r1, #121	; 0x79
c0d023cc:	b2c9      	uxtb	r1, r1
c0d023ce:	2204      	movs	r2, #4
c0d023d0:	f7fe fc68 	bl	c0d00ca4 <os_memset>
c0d023d4:	e003      	b.n	c0d023de <u2f_handle_cmd_init+0x76>
c0d023d6:	4669      	mov	r1, sp
    } else {
        os_memmove(service->channel, channel, 4);
c0d023d8:	2204      	movs	r2, #4
c0d023da:	f7fe fc6c 	bl	c0d00cb6 <os_memmove>
    }
    u2f_message_reply(service, U2F_CMD_INIT, G_io_apdu_buffer, 17);
c0d023de:	4a04      	ldr	r2, [pc, #16]	; (c0d023f0 <u2f_handle_cmd_init+0x88>)
c0d023e0:	2311      	movs	r3, #17
c0d023e2:	4620      	mov	r0, r4
c0d023e4:	4629      	mov	r1, r5
c0d023e6:	f000 fc20 	bl	c0d02c2a <u2f_message_reply>
}
c0d023ea:	b001      	add	sp, #4
c0d023ec:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d023ee:	46c0      	nop			; (mov r8, r8)
c0d023f0:	200018f8 	.word	0x200018f8

c0d023f4 <u2f_handle_cmd_msg>:
    // screen_printf("U2F ping\n");
    u2f_message_reply(service, U2F_CMD_PING, buffer, length);
}

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
c0d023f4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d023f6:	b085      	sub	sp, #20
c0d023f8:	4615      	mov	r5, r2
c0d023fa:	460c      	mov	r4, r1
c0d023fc:	9004      	str	r0, [sp, #16]
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
c0d023fe:	79a0      	ldrb	r0, [r4, #6]
c0d02400:	7961      	ldrb	r1, [r4, #5]
c0d02402:	020e      	lsls	r6, r1, #8
c0d02404:	4306      	orrs	r6, r0
void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
c0d02406:	78a0      	ldrb	r0, [r4, #2]

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
c0d02408:	9002      	str	r0, [sp, #8]
c0d0240a:	7861      	ldrb	r1, [r4, #1]
}

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
c0d0240c:	7827      	ldrb	r7, [r4, #0]
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
c0d0240e:	3a09      	subs	r2, #9
c0d02410:	b290      	uxth	r0, r2
        u2f_apdu_get_info(service, p1, p2, buffer + 7, dataLength);
        break;

    default:
        // screen_printf("unsupported\n");
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02412:	2383      	movs	r3, #131	; 0x83
c0d02414:	9303      	str	r3, [sp, #12]
c0d02416:	4b1f      	ldr	r3, [pc, #124]	; (c0d02494 <u2f_handle_cmd_msg+0xa0>)
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
c0d02418:	4286      	cmp	r6, r0
c0d0241a:	d003      	beq.n	c0d02424 <u2f_handle_cmd_msg+0x30>
c0d0241c:	1fed      	subs	r5, r5, #7
c0d0241e:	402b      	ands	r3, r5
c0d02420:	429e      	cmp	r6, r3
c0d02422:	d11b      	bne.n	c0d0245c <u2f_handle_cmd_msg+0x68>
c0d02424:	4632      	mov	r2, r6
    G_io_apdu_media = IO_APDU_MEDIA_U2F; // the effective transport is managed by the U2F layer
    G_io_apdu_state = APDU_U2F;

#else

    if (cla != FIDO_CLA) {
c0d02426:	2f00      	cmp	r7, #0
c0d02428:	d008      	beq.n	c0d0243c <u2f_handle_cmd_msg+0x48>
        u2f_message_reply(service, U2F_CMD_MSG,
c0d0242a:	4a1b      	ldr	r2, [pc, #108]	; (c0d02498 <u2f_handle_cmd_msg+0xa4>)
c0d0242c:	447a      	add	r2, pc
c0d0242e:	2302      	movs	r3, #2
c0d02430:	9804      	ldr	r0, [sp, #16]
c0d02432:	9903      	ldr	r1, [sp, #12]
c0d02434:	f000 fbf9 	bl	c0d02c2a <u2f_message_reply>
                 sizeof(SW_UNKNOWN_INSTRUCTION));
        return;
    }

#endif    
}
c0d02438:	b005      	add	sp, #20
c0d0243a:	bdf0      	pop	{r4, r5, r6, r7, pc}
        u2f_message_reply(service, U2F_CMD_MSG,
                  (uint8_t *)SW_UNKNOWN_CLASS,
                  sizeof(SW_UNKNOWN_CLASS));
        return;
    }
    switch (ins) {
c0d0243c:	2902      	cmp	r1, #2
c0d0243e:	dc17      	bgt.n	c0d02470 <u2f_handle_cmd_msg+0x7c>
c0d02440:	2901      	cmp	r1, #1
c0d02442:	d020      	beq.n	c0d02486 <u2f_handle_cmd_msg+0x92>
c0d02444:	2902      	cmp	r1, #2
c0d02446:	d11b      	bne.n	c0d02480 <u2f_handle_cmd_msg+0x8c>
        // screen_printf("enroll\n");
        u2f_apdu_enroll(service, p1, p2, buffer + 7, dataLength);
        break;
    case FIDO_INS_SIGN:
        // screen_printf("sign\n");
        u2f_apdu_sign(service, p1, p2, buffer + 7, dataLength);
c0d02448:	b290      	uxth	r0, r2
c0d0244a:	4669      	mov	r1, sp
c0d0244c:	6008      	str	r0, [r1, #0]
c0d0244e:	1de3      	adds	r3, r4, #7
c0d02450:	2200      	movs	r2, #0
c0d02452:	9804      	ldr	r0, [sp, #16]
c0d02454:	9902      	ldr	r1, [sp, #8]
c0d02456:	f7ff ff01 	bl	c0d0225c <u2f_apdu_sign>
c0d0245a:	e7ed      	b.n	c0d02438 <u2f_handle_cmd_msg+0x44>
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
        // Le is optional
        // nominal case from the specification
    }
    // circumvent google chrome extended length encoding done on the last byte only (module 256) but all data being transferred
    else if (dataLength == (uint16_t)(length - 9)%256) {
c0d0245c:	b2d0      	uxtb	r0, r2
c0d0245e:	4286      	cmp	r6, r0
c0d02460:	d0e1      	beq.n	c0d02426 <u2f_handle_cmd_msg+0x32>
        dataLength = length - 9;
    }
    else if (dataLength == (uint16_t)(length - 7)%256) {
c0d02462:	b2e8      	uxtb	r0, r5
c0d02464:	4286      	cmp	r6, r0
c0d02466:	462a      	mov	r2, r5
c0d02468:	d0dd      	beq.n	c0d02426 <u2f_handle_cmd_msg+0x32>
        dataLength = length - 7;
    }    
    else { 
        // invalid size
        u2f_message_reply(service, U2F_CMD_MSG,
c0d0246a:	4a0c      	ldr	r2, [pc, #48]	; (c0d0249c <u2f_handle_cmd_msg+0xa8>)
c0d0246c:	447a      	add	r2, pc
c0d0246e:	e7de      	b.n	c0d0242e <u2f_handle_cmd_msg+0x3a>
c0d02470:	2903      	cmp	r1, #3
c0d02472:	d00b      	beq.n	c0d0248c <u2f_handle_cmd_msg+0x98>
c0d02474:	29c1      	cmp	r1, #193	; 0xc1
c0d02476:	d103      	bne.n	c0d02480 <u2f_handle_cmd_msg+0x8c>
                            uint8_t *buffer, uint16_t length) {
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)INFO, sizeof(INFO));
c0d02478:	4a09      	ldr	r2, [pc, #36]	; (c0d024a0 <u2f_handle_cmd_msg+0xac>)
c0d0247a:	447a      	add	r2, pc
c0d0247c:	2304      	movs	r3, #4
c0d0247e:	e7d7      	b.n	c0d02430 <u2f_handle_cmd_msg+0x3c>
        u2f_apdu_get_info(service, p1, p2, buffer + 7, dataLength);
        break;

    default:
        // screen_printf("unsupported\n");
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02480:	4a0a      	ldr	r2, [pc, #40]	; (c0d024ac <u2f_handle_cmd_msg+0xb8>)
c0d02482:	447a      	add	r2, pc
c0d02484:	e7d3      	b.n	c0d0242e <u2f_handle_cmd_msg+0x3a>
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);

    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)SW_INTERNAL, sizeof(SW_INTERNAL));
c0d02486:	4a07      	ldr	r2, [pc, #28]	; (c0d024a4 <u2f_handle_cmd_msg+0xb0>)
c0d02488:	447a      	add	r2, pc
c0d0248a:	e7d0      	b.n	c0d0242e <u2f_handle_cmd_msg+0x3a>
    // screen_printf("U2F version\n");
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)U2F_VERSION, sizeof(U2F_VERSION));
c0d0248c:	4a06      	ldr	r2, [pc, #24]	; (c0d024a8 <u2f_handle_cmd_msg+0xb4>)
c0d0248e:	447a      	add	r2, pc
c0d02490:	2308      	movs	r3, #8
c0d02492:	e7cd      	b.n	c0d02430 <u2f_handle_cmd_msg+0x3c>
c0d02494:	0000ffff 	.word	0x0000ffff
c0d02498:	00001fc0 	.word	0x00001fc0
c0d0249c:	00001f6e 	.word	0x00001f6e
c0d024a0:	00001f6e 	.word	0x00001f6e
c0d024a4:	00001f4e 	.word	0x00001f4e
c0d024a8:	00001f52 	.word	0x00001f52
c0d024ac:	00001f6c 	.word	0x00001f6c

c0d024b0 <u2f_message_complete>:
    }

#endif    
}

void u2f_message_complete(u2f_service_t *service) {
c0d024b0:	b580      	push	{r7, lr}
    uint8_t cmd = service->transportBuffer[0];
c0d024b2:	69c1      	ldr	r1, [r0, #28]
    uint16_t length = (service->transportBuffer[1] << 8) | (service->transportBuffer[2]);
c0d024b4:	788a      	ldrb	r2, [r1, #2]
c0d024b6:	784b      	ldrb	r3, [r1, #1]
c0d024b8:	021b      	lsls	r3, r3, #8
c0d024ba:	4313      	orrs	r3, r2

#endif    
}

void u2f_message_complete(u2f_service_t *service) {
    uint8_t cmd = service->transportBuffer[0];
c0d024bc:	780a      	ldrb	r2, [r1, #0]
    uint16_t length = (service->transportBuffer[1] << 8) | (service->transportBuffer[2]);
    switch (cmd) {
c0d024be:	2a81      	cmp	r2, #129	; 0x81
c0d024c0:	d009      	beq.n	c0d024d6 <u2f_message_complete+0x26>
c0d024c2:	2a83      	cmp	r2, #131	; 0x83
c0d024c4:	d00c      	beq.n	c0d024e0 <u2f_message_complete+0x30>
c0d024c6:	2a86      	cmp	r2, #134	; 0x86
c0d024c8:	d10e      	bne.n	c0d024e8 <u2f_message_complete+0x38>
    case U2F_CMD_INIT:
        u2f_handle_cmd_init(service, service->transportBuffer + 3, length, service->channel);
c0d024ca:	1cc9      	adds	r1, r1, #3
c0d024cc:	1d03      	adds	r3, r0, #4
c0d024ce:	2200      	movs	r2, #0
c0d024d0:	f7ff ff4a 	bl	c0d02368 <u2f_handle_cmd_init>
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
        break;
    }
}
c0d024d4:	bd80      	pop	{r7, pc}
    switch (cmd) {
    case U2F_CMD_INIT:
        u2f_handle_cmd_init(service, service->transportBuffer + 3, length, service->channel);
        break;
    case U2F_CMD_PING:
        u2f_handle_cmd_ping(service, service->transportBuffer + 3, length);
c0d024d6:	1cca      	adds	r2, r1, #3
}

void u2f_handle_cmd_ping(u2f_service_t *service, uint8_t *buffer,
                         uint16_t length) {
    // screen_printf("U2F ping\n");
    u2f_message_reply(service, U2F_CMD_PING, buffer, length);
c0d024d8:	2181      	movs	r1, #129	; 0x81
c0d024da:	f000 fba6 	bl	c0d02c2a <u2f_message_reply>
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
        break;
    }
}
c0d024de:	bd80      	pop	{r7, pc}
        break;
    case U2F_CMD_PING:
        u2f_handle_cmd_ping(service, service->transportBuffer + 3, length);
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
c0d024e0:	1cc9      	adds	r1, r1, #3
c0d024e2:	461a      	mov	r2, r3
c0d024e4:	f7ff ff86 	bl	c0d023f4 <u2f_handle_cmd_msg>
        break;
    }
}
c0d024e8:	bd80      	pop	{r7, pc}
	...

c0d024ec <u2f_io_send>:
#include "u2f_processing.h"
#include "u2f_impl.h"

#include "os_io_seproxyhal.h"

void u2f_io_send(uint8_t *buffer, uint16_t length, u2f_transport_media_t media) {
c0d024ec:	b570      	push	{r4, r5, r6, lr}
c0d024ee:	460d      	mov	r5, r1
c0d024f0:	4601      	mov	r1, r0
    if (media == U2F_MEDIA_USB) {
c0d024f2:	2a01      	cmp	r2, #1
c0d024f4:	d112      	bne.n	c0d0251c <u2f_io_send+0x30>
        os_memmove(G_io_usb_ep_buffer, buffer, length);
c0d024f6:	4c17      	ldr	r4, [pc, #92]	; (c0d02554 <u2f_io_send+0x68>)
c0d024f8:	4620      	mov	r0, r4
c0d024fa:	462a      	mov	r2, r5
c0d024fc:	f7fe fbdb 	bl	c0d00cb6 <os_memmove>
        // wipe the remaining to avoid :
        // 1/ data leaks
        // 2/ invalid junk
        os_memset(G_io_usb_ep_buffer+length, 0, sizeof(G_io_usb_ep_buffer)-length);
c0d02500:	1960      	adds	r0, r4, r5
c0d02502:	2640      	movs	r6, #64	; 0x40
c0d02504:	1b72      	subs	r2, r6, r5
c0d02506:	2500      	movs	r5, #0
c0d02508:	4629      	mov	r1, r5
c0d0250a:	f7fe fbcb 	bl	c0d00ca4 <os_memset>
    }
    switch (media) {
    case U2F_MEDIA_USB:
        io_usb_send_ep(U2F_EPIN_ADDR, G_io_usb_ep_buffer, USB_SEGMENT_SIZE, 0);
c0d0250e:	2081      	movs	r0, #129	; 0x81
c0d02510:	4621      	mov	r1, r4
c0d02512:	4632      	mov	r2, r6
c0d02514:	462b      	mov	r3, r5
c0d02516:	f7fe fd1d 	bl	c0d00f54 <io_usb_send_ep>
#endif
    default:
        PRINTF("Request to send on unsupported media %d\n", media);
        break;
    }
}
c0d0251a:	bd70      	pop	{r4, r5, r6, pc}
    case U2F_MEDIA_BLE:
        BLE_protocol_send(buffer, length);
        break;
#endif
    default:
        PRINTF("Request to send on unsupported media %d\n", media);
c0d0251c:	a002      	add	r0, pc, #8	; (adr r0, c0d02528 <u2f_io_send+0x3c>)
c0d0251e:	4611      	mov	r1, r2
c0d02520:	f7ff f90e 	bl	c0d01740 <screen_printf>
        break;
    }
}
c0d02524:	bd70      	pop	{r4, r5, r6, pc}
c0d02526:	46c0      	nop			; (mov r8, r8)
c0d02528:	75716552 	.word	0x75716552
c0d0252c:	20747365 	.word	0x20747365
c0d02530:	73206f74 	.word	0x73206f74
c0d02534:	20646e65 	.word	0x20646e65
c0d02538:	75206e6f 	.word	0x75206e6f
c0d0253c:	7075736e 	.word	0x7075736e
c0d02540:	74726f70 	.word	0x74726f70
c0d02544:	6d206465 	.word	0x6d206465
c0d02548:	61696465 	.word	0x61696465
c0d0254c:	0a642520 	.word	0x0a642520
c0d02550:	00000000 	.word	0x00000000
c0d02554:	20001ac0 	.word	0x20001ac0

c0d02558 <u2f_transport_init>:

/**
 * Initialize the u2f transport and provide the buffer into which to store incoming message
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
c0d02558:	60c1      	str	r1, [r0, #12]
    service->transportReceiveBufferLength = message_buffer_length;
c0d0255a:	8202      	strh	r2, [r0, #16]
c0d0255c:	2200      	movs	r2, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d0255e:	82c2      	strh	r2, [r0, #22]
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d02560:	7682      	strb	r2, [r0, #26]
    service->fakeChannelTransportState = U2F_IDLE;
    service->fakeChannelTransportOffset = 0;
    service->fakeChannelTransportPacketIndex = 0;    
    service->sending = false;
c0d02562:	232b      	movs	r3, #43	; 0x2b
c0d02564:	54c2      	strb	r2, [r0, r3]
    service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_IDLE;
c0d02566:	232a      	movs	r3, #42	; 0x2a
c0d02568:	54c2      	strb	r2, [r0, r3]

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
    service->transportMedia = 0;
c0d0256a:	8482      	strh	r2, [r0, #36]	; 0x24
    service->fakeChannelTransportOffset = 0;
    service->fakeChannelTransportPacketIndex = 0;    
    service->sending = false;
    service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_IDLE;
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d0256c:	61c1      	str	r1, [r0, #28]

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
    service->transportMedia = 0;
c0d0256e:	6202      	str	r2, [r0, #32]
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
    service->transportReceiveBufferLength = message_buffer_length;
    u2f_transport_reset(service);
}
c0d02570:	4770      	bx	lr
	...

c0d02574 <u2f_transport_sent>:

/**
 * Function called when the previously scheduled message to be sent on the media is effectively sent.
 * And a new message can be scheduled.
 */
void u2f_transport_sent(u2f_service_t* service, u2f_transport_media_t media) {
c0d02574:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02576:	b083      	sub	sp, #12
c0d02578:	460d      	mov	r5, r1
c0d0257a:	4604      	mov	r4, r0

    // previous mark packet as sent
    if (service->sending) {
c0d0257c:	202b      	movs	r0, #43	; 0x2b
c0d0257e:	5c21      	ldrb	r1, [r4, r0]
c0d02580:	4620      	mov	r0, r4
c0d02582:	302b      	adds	r0, #43	; 0x2b
c0d02584:	2900      	cmp	r1, #0
c0d02586:	d002      	beq.n	c0d0258e <u2f_transport_sent+0x1a>
        service->sending = false;
c0d02588:	2100      	movs	r1, #0
c0d0258a:	7001      	strb	r1, [r0, #0]
c0d0258c:	e061      	b.n	c0d02652 <u2f_transport_sent+0xde>
        return;
    }

    // if idle (possibly after an error), then only await for a transmission 
    if (service->transportState != U2F_SENDING_RESPONSE 
c0d0258e:	2120      	movs	r1, #32
c0d02590:	5c61      	ldrb	r1, [r4, r1]
        && service->transportState != U2F_SENDING_ERROR) {
c0d02592:	1ec9      	subs	r1, r1, #3
c0d02594:	b2c9      	uxtb	r1, r1
        service->sending = false;
        return;
    }

    // if idle (possibly after an error), then only await for a transmission 
    if (service->transportState != U2F_SENDING_RESPONSE 
c0d02596:	4623      	mov	r3, r4
c0d02598:	3320      	adds	r3, #32
        && service->transportState != U2F_SENDING_ERROR) {
c0d0259a:	2901      	cmp	r1, #1
c0d0259c:	d859      	bhi.n	c0d02652 <u2f_transport_sent+0xde>
        // absorb the error, transport is erroneous but that won't hurt in the end.
        // also absorb the fake channel user presence check reply ack
        //THROW(INVALID_STATE);
        return;
    }
    if (service->transportOffset < service->transportLength) {
c0d0259e:	8b21      	ldrh	r1, [r4, #24]
c0d025a0:	8ae2      	ldrh	r2, [r4, #22]
c0d025a2:	4291      	cmp	r1, r2
c0d025a4:	d924      	bls.n	c0d025f0 <u2f_transport_sent+0x7c>
        uint16_t mtu = (media == U2F_MEDIA_USB) ? USB_SEGMENT_SIZE : BLE_SEGMENT_SIZE;
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
c0d025a6:	2304      	movs	r3, #4
c0d025a8:	2000      	movs	r0, #0
c0d025aa:	2d01      	cmp	r5, #1
c0d025ac:	d000      	beq.n	c0d025b0 <u2f_transport_sent+0x3c>
c0d025ae:	4603      	mov	r3, r0
c0d025b0:	9002      	str	r0, [sp, #8]
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
c0d025b2:	7ea0      	ldrb	r0, [r4, #26]
c0d025b4:	2703      	movs	r7, #3
c0d025b6:	2601      	movs	r6, #1
c0d025b8:	2800      	cmp	r0, #0
c0d025ba:	d000      	beq.n	c0d025be <u2f_transport_sent+0x4a>
c0d025bc:	4637      	mov	r7, r6
c0d025be:	431f      	orrs	r7, r3
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
                                      (mtu - headerSize)
c0d025c0:	2340      	movs	r3, #64	; 0x40
c0d025c2:	1bde      	subs	r6, r3, r7
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
c0d025c4:	1a89      	subs	r1, r1, r2
c0d025c6:	42b1      	cmp	r1, r6
c0d025c8:	dc00      	bgt.n	c0d025cc <u2f_transport_sent+0x58>
c0d025ca:	460e      	mov	r6, r1
                                      (mtu - headerSize)
                                  ? (mtu - headerSize)
                                  : service->transportLength - service->transportOffset);
        uint16_t dataSize = blockSize + headerSize;
c0d025cc:	19f1      	adds	r1, r6, r7
        uint16_t offset = 0;
        // Fragment
        if (media == U2F_MEDIA_USB) {
c0d025ce:	9101      	str	r1, [sp, #4]
c0d025d0:	2d01      	cmp	r5, #1
c0d025d2:	d108      	bne.n	c0d025e6 <u2f_transport_sent+0x72>
            os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d025d4:	1d21      	adds	r1, r4, #4
c0d025d6:	4821      	ldr	r0, [pc, #132]	; (c0d0265c <u2f_transport_sent+0xe8>)
c0d025d8:	2204      	movs	r2, #4
c0d025da:	9202      	str	r2, [sp, #8]
c0d025dc:	9300      	str	r3, [sp, #0]
c0d025de:	f7fe fb6a 	bl	c0d00cb6 <os_memmove>
c0d025e2:	9b00      	ldr	r3, [sp, #0]
c0d025e4:	7ea0      	ldrb	r0, [r4, #26]
            offset += 4;
        }
        if (service->transportPacketIndex == 0) {
c0d025e6:	2800      	cmp	r0, #0
c0d025e8:	d00f      	beq.n	c0d0260a <u2f_transport_sent+0x96>
            G_io_usb_ep_buffer[offset++] = service->sendCmd;
            G_io_usb_ep_buffer[offset++] = (service->transportLength >> 8);
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
c0d025ea:	30ff      	adds	r0, #255	; 0xff
c0d025ec:	9902      	ldr	r1, [sp, #8]
c0d025ee:	e018      	b.n	c0d02622 <u2f_transport_sent+0xae>
c0d025f0:	d12f      	bne.n	c0d02652 <u2f_transport_sent+0xde>
c0d025f2:	2100      	movs	r1, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d025f4:	82e1      	strh	r1, [r4, #22]
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d025f6:	76a1      	strb	r1, [r4, #26]
    service->fakeChannelTransportState = U2F_IDLE;
    service->fakeChannelTransportOffset = 0;
    service->fakeChannelTransportPacketIndex = 0;    
    service->sending = false;
c0d025f8:	7001      	strb	r1, [r0, #0]
    service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_IDLE;
c0d025fa:	202a      	movs	r0, #42	; 0x2a
c0d025fc:	5421      	strb	r1, [r4, r0]

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
    service->transportMedia = 0;
c0d025fe:	8099      	strh	r1, [r3, #4]
c0d02600:	6019      	str	r1, [r3, #0]
    service->fakeChannelTransportOffset = 0;
    service->fakeChannelTransportPacketIndex = 0;    
    service->sending = false;
    service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_IDLE;
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d02602:	68e0      	ldr	r0, [r4, #12]
c0d02604:	61e0      	str	r0, [r4, #28]
    }
    // last part sent
    else if (service->transportOffset == service->transportLength) {
        u2f_transport_reset(service);
        // we sent the whole response (even if we haven't yet received the ack for the last sent usb in packet)
        G_io_apdu_state = APDU_IDLE;
c0d02606:	4814      	ldr	r0, [pc, #80]	; (c0d02658 <u2f_transport_sent+0xe4>)
c0d02608:	e7bf      	b.n	c0d0258a <u2f_transport_sent+0x16>
        if (media == U2F_MEDIA_USB) {
            os_memmove(G_io_usb_ep_buffer, service->channel, 4);
            offset += 4;
        }
        if (service->transportPacketIndex == 0) {
            G_io_usb_ep_buffer[offset++] = service->sendCmd;
c0d0260a:	5ce0      	ldrb	r0, [r4, r3]
c0d0260c:	9b02      	ldr	r3, [sp, #8]
c0d0260e:	b299      	uxth	r1, r3
c0d02610:	4a12      	ldr	r2, [pc, #72]	; (c0d0265c <u2f_transport_sent+0xe8>)
c0d02612:	5450      	strb	r0, [r2, r1]
c0d02614:	2001      	movs	r0, #1
c0d02616:	4318      	orrs	r0, r3
            G_io_usb_ep_buffer[offset++] = (service->transportLength >> 8);
c0d02618:	b281      	uxth	r1, r0
c0d0261a:	7e63      	ldrb	r3, [r4, #25]
c0d0261c:	5453      	strb	r3, [r2, r1]
c0d0261e:	1c41      	adds	r1, r0, #1
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
c0d02620:	7e20      	ldrb	r0, [r4, #24]
c0d02622:	b289      	uxth	r1, r1
c0d02624:	4b0d      	ldr	r3, [pc, #52]	; (c0d0265c <u2f_transport_sent+0xe8>)
c0d02626:	5458      	strb	r0, [r3, r1]
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
c0d02628:	69e1      	ldr	r1, [r4, #28]
c0d0262a:	2900      	cmp	r1, #0
c0d0262c:	d005      	beq.n	c0d0263a <u2f_transport_sent+0xc6>
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
                                      (mtu - headerSize)
                                  ? (mtu - headerSize)
                                  : service->transportLength - service->transportOffset);
        uint16_t dataSize = blockSize + headerSize;
c0d0262e:	b2b2      	uxth	r2, r6
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
            os_memmove(G_io_usb_ep_buffer + headerSize,
c0d02630:	19d8      	adds	r0, r3, r7
                       service->transportBuffer + service->transportOffset, blockSize);
c0d02632:	8ae3      	ldrh	r3, [r4, #22]
c0d02634:	18c9      	adds	r1, r1, r3
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
            os_memmove(G_io_usb_ep_buffer + headerSize,
c0d02636:	f7fe fb3e 	bl	c0d00cb6 <os_memmove>
                       service->transportBuffer + service->transportOffset, blockSize);
        }
        service->transportOffset += blockSize;
c0d0263a:	8ae0      	ldrh	r0, [r4, #22]
c0d0263c:	1980      	adds	r0, r0, r6
c0d0263e:	82e0      	strh	r0, [r4, #22]
        service->transportPacketIndex++;
c0d02640:	7ea0      	ldrb	r0, [r4, #26]
c0d02642:	1c40      	adds	r0, r0, #1
c0d02644:	76a0      	strb	r0, [r4, #26]
        u2f_io_send(G_io_usb_ep_buffer, dataSize, media);
c0d02646:	9801      	ldr	r0, [sp, #4]
c0d02648:	b281      	uxth	r1, r0
c0d0264a:	4804      	ldr	r0, [pc, #16]	; (c0d0265c <u2f_transport_sent+0xe8>)
c0d0264c:	462a      	mov	r2, r5
c0d0264e:	f7ff ff4d 	bl	c0d024ec <u2f_io_send>
    else if (service->transportOffset == service->transportLength) {
        u2f_transport_reset(service);
        // we sent the whole response (even if we haven't yet received the ack for the last sent usb in packet)
        G_io_apdu_state = APDU_IDLE;
    }
}
c0d02652:	b003      	add	sp, #12
c0d02654:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02656:	46c0      	nop			; (mov r8, r8)
c0d02658:	20001a6a 	.word	0x20001a6a
c0d0265c:	20001ac0 	.word	0x20001ac0

c0d02660 <u2f_transport_send_usb_user_presence_required>:

void u2f_transport_send_usb_user_presence_required(u2f_service_t *service) {
c0d02660:	b5b0      	push	{r4, r5, r7, lr}
    uint16_t offset = 0;
    service->sending = true;
c0d02662:	212b      	movs	r1, #43	; 0x2b
c0d02664:	2401      	movs	r4, #1
c0d02666:	5444      	strb	r4, [r0, r1]
    os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d02668:	1d01      	adds	r1, r0, #4
c0d0266a:	4d0b      	ldr	r5, [pc, #44]	; (c0d02698 <u2f_transport_send_usb_user_presence_required+0x38>)
c0d0266c:	2204      	movs	r2, #4
c0d0266e:	4628      	mov	r0, r5
c0d02670:	f7fe fb21 	bl	c0d00cb6 <os_memmove>
    offset += 4;
    G_io_usb_ep_buffer[offset++] = U2F_CMD_MSG;
    G_io_usb_ep_buffer[offset++] = 0;
    G_io_usb_ep_buffer[offset++] = 2;
    G_io_usb_ep_buffer[offset++] = 0x69;
    G_io_usb_ep_buffer[offset++] = 0x85;
c0d02674:	2083      	movs	r0, #131	; 0x83
void u2f_transport_send_usb_user_presence_required(u2f_service_t *service) {
    uint16_t offset = 0;
    service->sending = true;
    os_memmove(G_io_usb_ep_buffer, service->channel, 4);
    offset += 4;
    G_io_usb_ep_buffer[offset++] = U2F_CMD_MSG;
c0d02676:	7128      	strb	r0, [r5, #4]
    G_io_usb_ep_buffer[offset++] = 0;
c0d02678:	2000      	movs	r0, #0
c0d0267a:	7168      	strb	r0, [r5, #5]
    G_io_usb_ep_buffer[offset++] = 2;
c0d0267c:	2002      	movs	r0, #2
c0d0267e:	71a8      	strb	r0, [r5, #6]
    G_io_usb_ep_buffer[offset++] = 0x69;
c0d02680:	2069      	movs	r0, #105	; 0x69
c0d02682:	71e8      	strb	r0, [r5, #7]
    G_io_usb_ep_buffer[offset++] = 0x85;
c0d02684:	207c      	movs	r0, #124	; 0x7c
c0d02686:	43c0      	mvns	r0, r0
c0d02688:	1c80      	adds	r0, r0, #2
c0d0268a:	7228      	strb	r0, [r5, #8]
    u2f_io_send(G_io_usb_ep_buffer, offset, U2F_MEDIA_USB);
c0d0268c:	2109      	movs	r1, #9
c0d0268e:	4628      	mov	r0, r5
c0d02690:	4622      	mov	r2, r4
c0d02692:	f7ff ff2b 	bl	c0d024ec <u2f_io_send>
}
c0d02696:	bdb0      	pop	{r4, r5, r7, pc}
c0d02698:	20001ac0 	.word	0x20001ac0

c0d0269c <u2f_transport_send_wink>:

void u2f_transport_send_wink(u2f_service_t *service) {
c0d0269c:	b5b0      	push	{r4, r5, r7, lr}
    uint16_t offset = 0;
    service->sending = true;
c0d0269e:	212b      	movs	r1, #43	; 0x2b
c0d026a0:	2401      	movs	r4, #1
c0d026a2:	5444      	strb	r4, [r0, r1]
    os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d026a4:	1d01      	adds	r1, r0, #4
c0d026a6:	4d08      	ldr	r5, [pc, #32]	; (c0d026c8 <u2f_transport_send_wink+0x2c>)
c0d026a8:	2204      	movs	r2, #4
c0d026aa:	4628      	mov	r0, r5
c0d026ac:	f7fe fb03 	bl	c0d00cb6 <os_memmove>
    offset += 4;
    G_io_usb_ep_buffer[offset++] = U2F_CMD_WINK;
c0d026b0:	2088      	movs	r0, #136	; 0x88
c0d026b2:	7128      	strb	r0, [r5, #4]
    G_io_usb_ep_buffer[offset++] = 0;
c0d026b4:	2000      	movs	r0, #0
c0d026b6:	7168      	strb	r0, [r5, #5]
    G_io_usb_ep_buffer[offset++] = 0;
c0d026b8:	71a8      	strb	r0, [r5, #6]
    u2f_io_send(G_io_usb_ep_buffer, offset, U2F_MEDIA_USB);
c0d026ba:	2107      	movs	r1, #7
c0d026bc:	4628      	mov	r0, r5
c0d026be:	4622      	mov	r2, r4
c0d026c0:	f7ff ff14 	bl	c0d024ec <u2f_io_send>
}
c0d026c4:	bdb0      	pop	{r4, r5, r7, pc}
c0d026c6:	46c0      	nop			; (mov r8, r8)
c0d026c8:	20001ac0 	.word	0x20001ac0

c0d026cc <u2f_transport_receive_fakeChannel>:

bool u2f_transport_receive_fakeChannel(u2f_service_t *service, uint8_t *buffer, uint16_t size) {
c0d026cc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d026ce:	b085      	sub	sp, #20
c0d026d0:	4604      	mov	r4, r0
    if (service->fakeChannelTransportState == U2F_INTERNAL_ERROR) {
c0d026d2:	2025      	movs	r0, #37	; 0x25
c0d026d4:	5c23      	ldrb	r3, [r4, r0]
c0d026d6:	4627      	mov	r7, r4
c0d026d8:	3725      	adds	r7, #37	; 0x25
c0d026da:	2000      	movs	r0, #0
c0d026dc:	2b05      	cmp	r3, #5
c0d026de:	d019      	beq.n	c0d02714 <u2f_transport_receive_fakeChannel+0x48>
c0d026e0:	9004      	str	r0, [sp, #16]
        return false;
    }
    if (memcmp(service->channel, buffer, 4) != 0) {
c0d026e2:	7808      	ldrb	r0, [r1, #0]
c0d026e4:	784b      	ldrb	r3, [r1, #1]
c0d026e6:	021b      	lsls	r3, r3, #8
c0d026e8:	4303      	orrs	r3, r0
c0d026ea:	7888      	ldrb	r0, [r1, #2]
c0d026ec:	78ce      	ldrb	r6, [r1, #3]
c0d026ee:	0236      	lsls	r6, r6, #8
c0d026f0:	4306      	orrs	r6, r0
c0d026f2:	0430      	lsls	r0, r6, #16
c0d026f4:	4318      	orrs	r0, r3
c0d026f6:	7923      	ldrb	r3, [r4, #4]
c0d026f8:	7966      	ldrb	r6, [r4, #5]
c0d026fa:	0236      	lsls	r6, r6, #8
c0d026fc:	431e      	orrs	r6, r3
c0d026fe:	79a3      	ldrb	r3, [r4, #6]
c0d02700:	79e5      	ldrb	r5, [r4, #7]
c0d02702:	022d      	lsls	r5, r5, #8
c0d02704:	431d      	orrs	r5, r3
c0d02706:	042b      	lsls	r3, r5, #16
c0d02708:	4333      	orrs	r3, r6
c0d0270a:	4283      	cmp	r3, r0
c0d0270c:	d004      	beq.n	c0d02718 <u2f_transport_receive_fakeChannel+0x4c>
            service->fakeChannelTransportState = U2F_IDLE;
        }
    }
    return true;
error:
    service->fakeChannelTransportState = U2F_INTERNAL_ERROR;
c0d0270e:	2005      	movs	r0, #5
c0d02710:	7038      	strb	r0, [r7, #0]
c0d02712:	9804      	ldr	r0, [sp, #16]
    return false;    
}
c0d02714:	b005      	add	sp, #20
c0d02716:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02718:	790e      	ldrb	r6, [r1, #4]
c0d0271a:	1d0d      	adds	r5, r1, #4
        return false;
    }
    if (memcmp(service->channel, buffer, 4) != 0) {
        goto error;
    }
    if (service->fakeChannelTransportOffset == 0) {        
c0d0271c:	8c60      	ldrh	r0, [r4, #34]	; 0x22
c0d0271e:	2301      	movs	r3, #1
c0d02720:	9303      	str	r3, [sp, #12]
c0d02722:	4b30      	ldr	r3, [pc, #192]	; (c0d027e4 <u2f_transport_receive_fakeChannel+0x118>)
c0d02724:	2800      	cmp	r0, #0
c0d02726:	d01e      	beq.n	c0d02766 <u2f_transport_receive_fakeChannel+0x9a>
c0d02728:	9302      	str	r3, [sp, #8]
        service->fakeChannelTransportOffset = MIN(size - 4, service->transportLength);
        service->fakeChannelTransportPacketIndex = 0;
        service->fakeChannelCrc = cx_crc16_update(0, buffer + 4, service->fakeChannelTransportOffset);
    }
    else {
        if (buffer[4] != service->fakeChannelTransportPacketIndex) {
c0d0272a:	2324      	movs	r3, #36	; 0x24
c0d0272c:	5ce5      	ldrb	r5, [r4, r3]
c0d0272e:	4623      	mov	r3, r4
c0d02730:	3324      	adds	r3, #36	; 0x24
c0d02732:	42ae      	cmp	r6, r5
c0d02734:	d1eb      	bne.n	c0d0270e <u2f_transport_receive_fakeChannel+0x42>
            goto error;
        }
        uint16_t xfer_len = MIN(size - 5, service->transportLength - service->fakeChannelTransportOffset);
c0d02736:	8b25      	ldrh	r5, [r4, #24]
        service->fakeChannelTransportPacketIndex++;
c0d02738:	9500      	str	r5, [sp, #0]
c0d0273a:	1c75      	adds	r5, r6, #1
c0d0273c:	701d      	strb	r5, [r3, #0]
    }
    else {
        if (buffer[4] != service->fakeChannelTransportPacketIndex) {
            goto error;
        }
        uint16_t xfer_len = MIN(size - 5, service->transportLength - service->fakeChannelTransportOffset);
c0d0273e:	9b00      	ldr	r3, [sp, #0]
c0d02740:	1a1e      	subs	r6, r3, r0
c0d02742:	1f53      	subs	r3, r2, #5
c0d02744:	2505      	movs	r5, #5
c0d02746:	9501      	str	r5, [sp, #4]
c0d02748:	42b3      	cmp	r3, r6
c0d0274a:	db00      	blt.n	c0d0274e <u2f_transport_receive_fakeChannel+0x82>
c0d0274c:	9001      	str	r0, [sp, #4]
c0d0274e:	42b3      	cmp	r3, r6
c0d02750:	db00      	blt.n	c0d02754 <u2f_transport_receive_fakeChannel+0x88>
c0d02752:	9a00      	ldr	r2, [sp, #0]
c0d02754:	9b01      	ldr	r3, [sp, #4]
c0d02756:	1ad3      	subs	r3, r2, r3
        service->fakeChannelTransportPacketIndex++;
        service->fakeChannelTransportOffset += xfer_len;
c0d02758:	1818      	adds	r0, r3, r0
c0d0275a:	8460      	strh	r0, [r4, #34]	; 0x22
c0d0275c:	9a02      	ldr	r2, [sp, #8]
c0d0275e:	401a      	ands	r2, r3
        service->fakeChannelCrc = cx_crc16_update(service->fakeChannelCrc, buffer + 5, xfer_len);   
c0d02760:	8d20      	ldrh	r0, [r4, #40]	; 0x28
c0d02762:	1d49      	adds	r1, r1, #5
c0d02764:	e025      	b.n	c0d027b2 <u2f_transport_receive_fakeChannel+0xe6>
c0d02766:	207c      	movs	r0, #124	; 0x7c
c0d02768:	43c0      	mvns	r0, r0
    }
    if (service->fakeChannelTransportOffset == 0) {        
        uint16_t commandLength =
            (buffer[4 + 1] << 8) | (buffer[4 + 2]) + U2F_COMMAND_HEADER_SIZE;
        // Some buggy implementations can send a WINK here, reply it gently
        if (buffer[4] == U2F_CMD_WINK) {
c0d0276a:	1d40      	adds	r0, r0, #5
c0d0276c:	b2c0      	uxtb	r0, r0
c0d0276e:	9002      	str	r0, [sp, #8]
c0d02770:	2083      	movs	r0, #131	; 0x83
c0d02772:	9001      	str	r0, [sp, #4]
c0d02774:	9802      	ldr	r0, [sp, #8]
c0d02776:	4286      	cmp	r6, r0
c0d02778:	d103      	bne.n	c0d02782 <u2f_transport_receive_fakeChannel+0xb6>
            u2f_transport_send_wink(service);
c0d0277a:	4620      	mov	r0, r4
c0d0277c:	f7ff ff8e 	bl	c0d0269c <u2f_transport_send_wink>
c0d02780:	e02d      	b.n	c0d027de <u2f_transport_receive_fakeChannel+0x112>
c0d02782:	9502      	str	r5, [sp, #8]
c0d02784:	461d      	mov	r5, r3
    if (memcmp(service->channel, buffer, 4) != 0) {
        goto error;
    }
    if (service->fakeChannelTransportOffset == 0) {        
        uint16_t commandLength =
            (buffer[4 + 1] << 8) | (buffer[4 + 2]) + U2F_COMMAND_HEADER_SIZE;
c0d02786:	7948      	ldrb	r0, [r1, #5]
c0d02788:	0203      	lsls	r3, r0, #8
c0d0278a:	7988      	ldrb	r0, [r1, #6]
c0d0278c:	1cc0      	adds	r0, r0, #3
c0d0278e:	4318      	orrs	r0, r3
        if (buffer[4] == U2F_CMD_WINK) {
            u2f_transport_send_wink(service);
            return true;
        }

        if (commandLength != service->transportLength) {
c0d02790:	9901      	ldr	r1, [sp, #4]
c0d02792:	428e      	cmp	r6, r1
c0d02794:	d1bb      	bne.n	c0d0270e <u2f_transport_receive_fakeChannel+0x42>
c0d02796:	8b21      	ldrh	r1, [r4, #24]
c0d02798:	4288      	cmp	r0, r1
c0d0279a:	d1b8      	bne.n	c0d0270e <u2f_transport_receive_fakeChannel+0x42>
            goto error;
        }
        if (buffer[4] != U2F_CMD_MSG) {
            goto error;
        }
        service->fakeChannelTransportOffset = MIN(size - 4, service->transportLength);
c0d0279c:	1f11      	subs	r1, r2, #4
c0d0279e:	4281      	cmp	r1, r0
c0d027a0:	db00      	blt.n	c0d027a4 <u2f_transport_receive_fakeChannel+0xd8>
c0d027a2:	4601      	mov	r1, r0
c0d027a4:	8461      	strh	r1, [r4, #34]	; 0x22
        service->fakeChannelTransportPacketIndex = 0;
c0d027a6:	2224      	movs	r2, #36	; 0x24
c0d027a8:	2000      	movs	r0, #0
c0d027aa:	54a0      	strb	r0, [r4, r2]
c0d027ac:	462a      	mov	r2, r5
        service->fakeChannelCrc = cx_crc16_update(0, buffer + 4, service->fakeChannelTransportOffset);
c0d027ae:	400a      	ands	r2, r1
c0d027b0:	9902      	ldr	r1, [sp, #8]
c0d027b2:	f7ff fc85 	bl	c0d020c0 <cx_crc16_update>
c0d027b6:	8520      	strh	r0, [r4, #40]	; 0x28
        uint16_t xfer_len = MIN(size - 5, service->transportLength - service->fakeChannelTransportOffset);
        service->fakeChannelTransportPacketIndex++;
        service->fakeChannelTransportOffset += xfer_len;
        service->fakeChannelCrc = cx_crc16_update(service->fakeChannelCrc, buffer + 5, xfer_len);   
    }
    if (service->fakeChannelTransportOffset >= service->transportLength) {
c0d027b8:	8b21      	ldrh	r1, [r4, #24]
c0d027ba:	8c62      	ldrh	r2, [r4, #34]	; 0x22
c0d027bc:	428a      	cmp	r2, r1
c0d027be:	d30e      	bcc.n	c0d027de <u2f_transport_receive_fakeChannel+0x112>
        if (service->fakeChannelCrc != service->commandCrc) {
c0d027c0:	8ce1      	ldrh	r1, [r4, #38]	; 0x26
c0d027c2:	4288      	cmp	r0, r1
c0d027c4:	d1a3      	bne.n	c0d0270e <u2f_transport_receive_fakeChannel+0x42>
            goto error;
        }
        service->fakeChannelTransportState = U2F_FAKE_RECEIVED;
c0d027c6:	2006      	movs	r0, #6
c0d027c8:	7038      	strb	r0, [r7, #0]
        service->fakeChannelTransportOffset = 0;
c0d027ca:	2500      	movs	r5, #0
c0d027cc:	8465      	strh	r5, [r4, #34]	; 0x22
        // reply immediately when the asynch response is not yet ready
        if (service->waitAsynchronousResponse == U2F_WAIT_ASYNCH_ON) {
c0d027ce:	202a      	movs	r0, #42	; 0x2a
c0d027d0:	5c20      	ldrb	r0, [r4, r0]
c0d027d2:	2801      	cmp	r0, #1
c0d027d4:	d103      	bne.n	c0d027de <u2f_transport_receive_fakeChannel+0x112>
            u2f_transport_send_usb_user_presence_required(service);
c0d027d6:	4620      	mov	r0, r4
c0d027d8:	f7ff ff42 	bl	c0d02660 <u2f_transport_send_usb_user_presence_required>
            // response sent
            service->fakeChannelTransportState = U2F_IDLE;
c0d027dc:	703d      	strb	r5, [r7, #0]
c0d027de:	9803      	ldr	r0, [sp, #12]
c0d027e0:	e798      	b.n	c0d02714 <u2f_transport_receive_fakeChannel+0x48>
c0d027e2:	46c0      	nop			; (mov r8, r8)
c0d027e4:	0000ffff 	.word	0x0000ffff

c0d027e8 <u2f_transport_received>:
/** 
 * Function that process every message received on a media.
 * Performs message concatenation when message is splitted.
 */
void u2f_transport_received(u2f_service_t *service, uint8_t *buffer,
                          uint16_t size, u2f_transport_media_t media) {
c0d027e8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d027ea:	b08b      	sub	sp, #44	; 0x2c
c0d027ec:	4604      	mov	r4, r0
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
    uint16_t xfer_len;
    service->media = media;
c0d027ee:	7223      	strb	r3, [r4, #8]

    // Handle a busy channel and avoid reentry
    if (service->transportState == U2F_SENDING_RESPONSE) {
c0d027f0:	2020      	movs	r0, #32
c0d027f2:	5c20      	ldrb	r0, [r4, r0]
c0d027f4:	4627      	mov	r7, r4
c0d027f6:	3720      	adds	r7, #32
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        // check this is a command, cannot accept continuation without previous command
        if ((buffer[channelHeader+0]&U2F_MASK_COMMAND) == 0) {
c0d027f8:	2585      	movs	r5, #133	; 0x85
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
    uint16_t xfer_len;
    service->media = media;

    // Handle a busy channel and avoid reentry
    if (service->transportState == U2F_SENDING_RESPONSE) {
c0d027fa:	2803      	cmp	r0, #3
c0d027fc:	d00e      	beq.n	c0d0281c <u2f_transport_received+0x34>
c0d027fe:	9109      	str	r1, [sp, #36]	; 0x24
c0d02800:	920a      	str	r2, [sp, #40]	; 0x28
        u2f_transport_error(service, ERROR_CHANNEL_BUSY);
        goto error;
    }
    if (service->waitAsynchronousResponse != U2F_WAIT_ASYNCH_IDLE) {
c0d02802:	212a      	movs	r1, #42	; 0x2a
c0d02804:	5c61      	ldrb	r1, [r4, r1]
c0d02806:	4626      	mov	r6, r4
c0d02808:	362a      	adds	r6, #42	; 0x2a
c0d0280a:	2900      	cmp	r1, #0
c0d0280c:	d013      	beq.n	c0d02836 <u2f_transport_received+0x4e>
        if (!u2f_transport_receive_fakeChannel(service, buffer, size)) {
c0d0280e:	4620      	mov	r0, r4
c0d02810:	9909      	ldr	r1, [sp, #36]	; 0x24
c0d02812:	9a0a      	ldr	r2, [sp, #40]	; 0x28
c0d02814:	f7ff ff5a 	bl	c0d026cc <u2f_transport_receive_fakeChannel>
c0d02818:	2800      	cmp	r0, #0
c0d0281a:	d173      	bne.n	c0d02904 <u2f_transport_received+0x11c>
c0d0281c:	48e0      	ldr	r0, [pc, #896]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d0281e:	2106      	movs	r1, #6
c0d02820:	7201      	strb	r1, [r0, #8]
c0d02822:	2104      	movs	r1, #4
c0d02824:	7039      	strb	r1, [r7, #0]
c0d02826:	2100      	movs	r1, #0
c0d02828:	76a1      	strb	r1, [r4, #26]
c0d0282a:	3008      	adds	r0, #8
c0d0282c:	61e0      	str	r0, [r4, #28]
c0d0282e:	82e1      	strh	r1, [r4, #22]
c0d02830:	2001      	movs	r0, #1
c0d02832:	8320      	strh	r0, [r4, #24]
c0d02834:	e05f      	b.n	c0d028f6 <u2f_transport_received+0x10e>
        }
        return;
    }
    
    // SENDING_ERROR is accepted, and triggers a reset => means the host hasn't consumed the error.
    if (service->transportState == U2F_SENDING_ERROR) {
c0d02836:	2804      	cmp	r0, #4
c0d02838:	d109      	bne.n	c0d0284e <u2f_transport_received+0x66>
c0d0283a:	2000      	movs	r0, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d0283c:	82e0      	strh	r0, [r4, #22]
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d0283e:	76a0      	strb	r0, [r4, #26]
    service->fakeChannelTransportState = U2F_IDLE;
    service->fakeChannelTransportOffset = 0;
    service->fakeChannelTransportPacketIndex = 0;    
    service->sending = false;
c0d02840:	212b      	movs	r1, #43	; 0x2b
c0d02842:	5460      	strb	r0, [r4, r1]
    service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_IDLE;
c0d02844:	7030      	strb	r0, [r6, #0]

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
    service->transportMedia = 0;
c0d02846:	80b8      	strh	r0, [r7, #4]
c0d02848:	6038      	str	r0, [r7, #0]
    service->fakeChannelTransportOffset = 0;
    service->fakeChannelTransportPacketIndex = 0;    
    service->sending = false;
    service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_IDLE;
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d0284a:	68e0      	ldr	r0, [r4, #12]
c0d0284c:	61e0      	str	r0, [r4, #28]
    // SENDING_ERROR is accepted, and triggers a reset => means the host hasn't consumed the error.
    if (service->transportState == U2F_SENDING_ERROR) {
        u2f_transport_reset(service);
    }

    if (size < (1 + channelHeader)) {
c0d0284e:	2104      	movs	r1, #4
c0d02850:	2000      	movs	r0, #0
c0d02852:	9308      	str	r3, [sp, #32]
c0d02854:	2b01      	cmp	r3, #1
c0d02856:	d000      	beq.n	c0d0285a <u2f_transport_received+0x72>
c0d02858:	4601      	mov	r1, r0
c0d0285a:	2301      	movs	r3, #1
c0d0285c:	460a      	mov	r2, r1
c0d0285e:	431a      	orrs	r2, r3
c0d02860:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d02862:	4290      	cmp	r0, r2
c0d02864:	d33d      	bcc.n	c0d028e2 <u2f_transport_received+0xfa>
c0d02866:	9204      	str	r2, [sp, #16]
        // Message to short, abort
        u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
        goto error;
    }
    if (media == U2F_MEDIA_USB) {
c0d02868:	9808      	ldr	r0, [sp, #32]
c0d0286a:	2801      	cmp	r0, #1
c0d0286c:	9106      	str	r1, [sp, #24]
c0d0286e:	9505      	str	r5, [sp, #20]
c0d02870:	9307      	str	r3, [sp, #28]
c0d02872:	d107      	bne.n	c0d02884 <u2f_transport_received+0x9c>
        // hold the current channel value to reply to, for example, INIT commands within flow of segments.
        os_memmove(service->channel, buffer, 4);
c0d02874:	1d20      	adds	r0, r4, #4
c0d02876:	2204      	movs	r2, #4
c0d02878:	9909      	ldr	r1, [sp, #36]	; 0x24
c0d0287a:	f7fe fa1c 	bl	c0d00cb6 <os_memmove>
c0d0287e:	9906      	ldr	r1, [sp, #24]
c0d02880:	9b07      	ldr	r3, [sp, #28]
c0d02882:	9d05      	ldr	r5, [sp, #20]
    }

    // no previous chunk processed for the current message
    if (service->transportOffset == 0
c0d02884:	8ae0      	ldrh	r0, [r4, #22]
c0d02886:	4ac7      	ldr	r2, [pc, #796]	; (c0d02ba4 <u2f_transport_received+0x3bc>)
        // on USB we could get an INIT within a flow of segments.
        || (media == U2F_MEDIA_USB && os_memcmp(service->transportChannel, service->channel, 4) != 0) ) {
c0d02888:	2800      	cmp	r0, #0
c0d0288a:	d00f      	beq.n	c0d028ac <u2f_transport_received+0xc4>
c0d0288c:	9808      	ldr	r0, [sp, #32]
c0d0288e:	2801      	cmp	r0, #1
c0d02890:	d122      	bne.n	c0d028d8 <u2f_transport_received+0xf0>
c0d02892:	4620      	mov	r0, r4
c0d02894:	3012      	adds	r0, #18
c0d02896:	1d21      	adds	r1, r4, #4
c0d02898:	4615      	mov	r5, r2
c0d0289a:	2204      	movs	r2, #4
c0d0289c:	f7fe faa8 	bl	c0d00df0 <os_memcmp>
c0d028a0:	9906      	ldr	r1, [sp, #24]
c0d028a2:	462a      	mov	r2, r5
c0d028a4:	9b07      	ldr	r3, [sp, #28]
c0d028a6:	9d05      	ldr	r5, [sp, #20]
        // hold the current channel value to reply to, for example, INIT commands within flow of segments.
        os_memmove(service->channel, buffer, 4);
    }

    // no previous chunk processed for the current message
    if (service->transportOffset == 0
c0d028a8:	2800      	cmp	r0, #0
c0d028aa:	d015      	beq.n	c0d028d8 <u2f_transport_received+0xf0>
        // on USB we could get an INIT within a flow of segments.
        || (media == U2F_MEDIA_USB && os_memcmp(service->transportChannel, service->channel, 4) != 0) ) {
        if (size < (channelHeader + 3)) {
c0d028ac:	2603      	movs	r6, #3
c0d028ae:	4608      	mov	r0, r1
c0d028b0:	9603      	str	r6, [sp, #12]
c0d028b2:	4330      	orrs	r0, r6
c0d028b4:	460e      	mov	r6, r1
c0d028b6:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d028b8:	4281      	cmp	r1, r0
c0d028ba:	d312      	bcc.n	c0d028e2 <u2f_transport_received+0xfa>
c0d028bc:	9909      	ldr	r1, [sp, #36]	; 0x24
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        // check this is a command, cannot accept continuation without previous command
        if ((buffer[channelHeader+0]&U2F_MASK_COMMAND) == 0) {
c0d028be:	1988      	adds	r0, r1, r6
c0d028c0:	9002      	str	r0, [sp, #8]
c0d028c2:	5788      	ldrsb	r0, [r1, r6]
c0d028c4:	460e      	mov	r6, r1
c0d028c6:	4629      	mov	r1, r5
c0d028c8:	317a      	adds	r1, #122	; 0x7a
c0d028ca:	b249      	sxtb	r1, r1
c0d028cc:	4288      	cmp	r0, r1
c0d028ce:	dd37      	ble.n	c0d02940 <u2f_transport_received+0x158>
c0d028d0:	48b3      	ldr	r0, [pc, #716]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d028d2:	2104      	movs	r1, #4
c0d028d4:	7201      	strb	r1, [r0, #8]
c0d028d6:	e007      	b.n	c0d028e8 <u2f_transport_received+0x100>
c0d028d8:	2002      	movs	r0, #2
            service->transportPacketIndex = 0;
            os_memmove(service->transportChannel, service->channel, 4);
        }
    } else {
        // Continuation
        if (size < (channelHeader + 2)) {
c0d028da:	4308      	orrs	r0, r1
c0d028dc:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d028de:	4281      	cmp	r1, r0
c0d028e0:	d212      	bcs.n	c0d02908 <u2f_transport_received+0x120>
c0d028e2:	48af      	ldr	r0, [pc, #700]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d028e4:	7205      	strb	r5, [r0, #8]
c0d028e6:	2104      	movs	r1, #4
c0d028e8:	7039      	strb	r1, [r7, #0]
c0d028ea:	2100      	movs	r1, #0
c0d028ec:	76a1      	strb	r1, [r4, #26]
c0d028ee:	3008      	adds	r0, #8
c0d028f0:	61e0      	str	r0, [r4, #28]
c0d028f2:	82e1      	strh	r1, [r4, #22]
c0d028f4:	8323      	strh	r3, [r4, #24]
c0d028f6:	353a      	adds	r5, #58	; 0x3a
c0d028f8:	2040      	movs	r0, #64	; 0x40
c0d028fa:	5425      	strb	r5, [r4, r0]
c0d028fc:	7a21      	ldrb	r1, [r4, #8]
c0d028fe:	4620      	mov	r0, r4
c0d02900:	f7ff fe38 	bl	c0d02574 <u2f_transport_sent>
        service->seqTimeout = 0;
        service->transportState = U2F_HANDLE_SEGMENTED;
    }
error:
    return;
}
c0d02904:	b00b      	add	sp, #44	; 0x2c
c0d02906:	bdf0      	pop	{r4, r5, r6, r7, pc}
        if (size < (channelHeader + 2)) {
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        if (media != service->transportMedia) {
c0d02908:	2021      	movs	r0, #33	; 0x21
c0d0290a:	5c20      	ldrb	r0, [r4, r0]
c0d0290c:	9908      	ldr	r1, [sp, #32]
c0d0290e:	4288      	cmp	r0, r1
c0d02910:	d14d      	bne.n	c0d029ae <u2f_transport_received+0x1c6>
            // Mixed medias
            u2f_transport_error(service, ERROR_PROP_MEDIA_MIXED);
            goto error;
        }
        if (service->transportState != U2F_HANDLE_SEGMENTED) {
c0d02912:	7838      	ldrb	r0, [r7, #0]
c0d02914:	2801      	cmp	r0, #1
c0d02916:	d156      	bne.n	c0d029c6 <u2f_transport_received+0x1de>
c0d02918:	9203      	str	r2, [sp, #12]
            } else {
                u2f_transport_error(service, ERROR_INVALID_SEQ);
                goto error;
            }
        }
        if (media == U2F_MEDIA_USB) {
c0d0291a:	9808      	ldr	r0, [sp, #32]
c0d0291c:	2801      	cmp	r0, #1
c0d0291e:	d000      	beq.n	c0d02922 <u2f_transport_received+0x13a>
c0d02920:	e085      	b.n	c0d02a2e <u2f_transport_received+0x246>
            // Check the channel
            if (os_memcmp(buffer, service->channel, 4) != 0) {
c0d02922:	1d21      	adds	r1, r4, #4
c0d02924:	2504      	movs	r5, #4
c0d02926:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d02928:	462a      	mov	r2, r5
c0d0292a:	461e      	mov	r6, r3
c0d0292c:	f7fe fa60 	bl	c0d00df0 <os_memcmp>
c0d02930:	4633      	mov	r3, r6
c0d02932:	2800      	cmp	r0, #0
c0d02934:	d07b      	beq.n	c0d02a2e <u2f_transport_received+0x246>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d02936:	489a      	ldr	r0, [pc, #616]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d02938:	2106      	movs	r1, #6
c0d0293a:	7201      	strb	r1, [r0, #8]

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d0293c:	703d      	strb	r5, [r7, #0]
c0d0293e:	e0f6      	b.n	c0d02b2e <u2f_transport_received+0x346>
c0d02940:	9b08      	ldr	r3, [sp, #32]
            goto error;
        }

        // If waiting for a continuation on a different channel, reply BUSY
        // immediately
        if (media == U2F_MEDIA_USB) {
c0d02942:	2b01      	cmp	r3, #1
c0d02944:	d116      	bne.n	c0d02974 <u2f_transport_received+0x18c>
            if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d02946:	7838      	ldrb	r0, [r7, #0]
c0d02948:	2801      	cmp	r0, #1
c0d0294a:	d11f      	bne.n	c0d0298c <u2f_transport_received+0x1a4>
                (os_memcmp(service->channel, service->transportChannel, 4) !=
c0d0294c:	1d20      	adds	r0, r4, #4
c0d0294e:	4621      	mov	r1, r4
c0d02950:	3112      	adds	r1, #18
c0d02952:	4615      	mov	r5, r2
c0d02954:	2204      	movs	r2, #4
c0d02956:	9001      	str	r0, [sp, #4]
c0d02958:	f7fe fa4a 	bl	c0d00df0 <os_memcmp>
c0d0295c:	462a      	mov	r2, r5
c0d0295e:	9b08      	ldr	r3, [sp, #32]
c0d02960:	9d05      	ldr	r5, [sp, #20]
                 0) &&
c0d02962:	2800      	cmp	r0, #0
c0d02964:	d006      	beq.n	c0d02974 <u2f_transport_received+0x18c>
                (buffer[channelHeader] != U2F_CMD_INIT)) {
c0d02966:	9802      	ldr	r0, [sp, #8]
c0d02968:	7800      	ldrb	r0, [r0, #0]
c0d0296a:	1c69      	adds	r1, r5, #1
c0d0296c:	b2c9      	uxtb	r1, r1
        }

        // If waiting for a continuation on a different channel, reply BUSY
        // immediately
        if (media == U2F_MEDIA_USB) {
            if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d0296e:	4288      	cmp	r0, r1
c0d02970:	d000      	beq.n	c0d02974 <u2f_transport_received+0x18c>
c0d02972:	e0f6      	b.n	c0d02b62 <u2f_transport_received+0x37a>
                goto error;
            }
        }
        // If a command was already sent, and we are not processing a INIT
        // command, abort
        if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d02974:	7838      	ldrb	r0, [r7, #0]
c0d02976:	2801      	cmp	r0, #1
c0d02978:	d108      	bne.n	c0d0298c <u2f_transport_received+0x1a4>
            !((media == U2F_MEDIA_USB) &&
c0d0297a:	2b01      	cmp	r3, #1
c0d0297c:	d000      	beq.n	c0d02980 <u2f_transport_received+0x198>
c0d0297e:	e082      	b.n	c0d02a86 <u2f_transport_received+0x29e>
              (buffer[channelHeader] == U2F_CMD_INIT))) {
c0d02980:	9802      	ldr	r0, [sp, #8]
c0d02982:	7800      	ldrb	r0, [r0, #0]
c0d02984:	1c69      	adds	r1, r5, #1
c0d02986:	b2c9      	uxtb	r1, r1
                goto error;
            }
        }
        // If a command was already sent, and we are not processing a INIT
        // command, abort
        if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d02988:	4288      	cmp	r0, r1
c0d0298a:	d17c      	bne.n	c0d02a86 <u2f_transport_received+0x29e>
            u2f_transport_error(service, ERROR_INVALID_SEQ);
            goto error;
        }
        // Check the length
        uint16_t commandLength =
            (buffer[channelHeader + 1] << 8) | (buffer[channelHeader + 2]);
c0d0298c:	2002      	movs	r0, #2
c0d0298e:	9906      	ldr	r1, [sp, #24]
c0d02990:	4308      	orrs	r0, r1
c0d02992:	5c30      	ldrb	r0, [r6, r0]
c0d02994:	9904      	ldr	r1, [sp, #16]
c0d02996:	5c71      	ldrb	r1, [r6, r1]
c0d02998:	0209      	lsls	r1, r1, #8
c0d0299a:	4301      	orrs	r1, r0
        if (commandLength > (service->transportReceiveBufferLength - 3)) {
c0d0299c:	8a20      	ldrh	r0, [r4, #16]
c0d0299e:	1ec0      	subs	r0, r0, #3
c0d029a0:	4281      	cmp	r1, r0
c0d029a2:	dd1e      	ble.n	c0d029e2 <u2f_transport_received+0x1fa>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d029a4:	487e      	ldr	r0, [pc, #504]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d029a6:	9903      	ldr	r1, [sp, #12]
c0d029a8:	7201      	strb	r1, [r0, #8]

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d029aa:	2104      	movs	r1, #4
c0d029ac:	e06e      	b.n	c0d02a8c <u2f_transport_received+0x2a4>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d029ae:	4628      	mov	r0, r5
c0d029b0:	3008      	adds	r0, #8
c0d029b2:	497b      	ldr	r1, [pc, #492]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d029b4:	7208      	strb	r0, [r1, #8]

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d029b6:	2004      	movs	r0, #4
c0d029b8:	7038      	strb	r0, [r7, #0]
c0d029ba:	2000      	movs	r0, #0
    service->transportPacketIndex = 0;
c0d029bc:	76a0      	strb	r0, [r4, #26]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d029be:	3108      	adds	r1, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d029c0:	61e1      	str	r1, [r4, #28]
    service->transportOffset = 0;
c0d029c2:	82e0      	strh	r0, [r4, #22]
c0d029c4:	e796      	b.n	c0d028f4 <u2f_transport_received+0x10c>
            goto error;
        }
        if (service->transportState != U2F_HANDLE_SEGMENTED) {
            // Unexpected continuation at this stage, abort
            // TODO : review the behavior is HID only
            if (media == U2F_MEDIA_USB) {
c0d029c6:	9808      	ldr	r0, [sp, #32]
c0d029c8:	2801      	cmp	r0, #1
c0d029ca:	d181      	bne.n	c0d028d0 <u2f_transport_received+0xe8>
c0d029cc:	2000      	movs	r0, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d029ce:	82e0      	strh	r0, [r4, #22]
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d029d0:	76a0      	strb	r0, [r4, #26]
    service->fakeChannelTransportState = U2F_IDLE;
    service->fakeChannelTransportOffset = 0;
    service->fakeChannelTransportPacketIndex = 0;    
    service->sending = false;
c0d029d2:	212b      	movs	r1, #43	; 0x2b
c0d029d4:	5460      	strb	r0, [r4, r1]
    service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_IDLE;
c0d029d6:	7030      	strb	r0, [r6, #0]

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
    service->transportMedia = 0;
c0d029d8:	80b8      	strh	r0, [r7, #4]
c0d029da:	6038      	str	r0, [r7, #0]
    service->fakeChannelTransportOffset = 0;
    service->fakeChannelTransportPacketIndex = 0;    
    service->sending = false;
    service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_IDLE;
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d029dc:	68e0      	ldr	r0, [r4, #12]
c0d029de:	61e0      	str	r0, [r4, #28]
c0d029e0:	e790      	b.n	c0d02904 <u2f_transport_received+0x11c>
            // Overflow in message size, abort
            u2f_transport_error(service, ERROR_INVALID_LEN);
            goto error;
        }
        // Check if the command is supported
        switch (buffer[channelHeader]) {
c0d029e2:	9802      	ldr	r0, [sp, #8]
c0d029e4:	7800      	ldrb	r0, [r0, #0]
c0d029e6:	2881      	cmp	r0, #129	; 0x81
c0d029e8:	9b07      	ldr	r3, [sp, #28]
c0d029ea:	d004      	beq.n	c0d029f6 <u2f_transport_received+0x20e>
c0d029ec:	2886      	cmp	r0, #134	; 0x86
c0d029ee:	d059      	beq.n	c0d02aa4 <u2f_transport_received+0x2bc>
c0d029f0:	2883      	cmp	r0, #131	; 0x83
c0d029f2:	d000      	beq.n	c0d029f6 <u2f_transport_received+0x20e>
c0d029f4:	e0ac      	b.n	c0d02b50 <u2f_transport_received+0x368>
c0d029f6:	9109      	str	r1, [sp, #36]	; 0x24
c0d029f8:	9203      	str	r2, [sp, #12]
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
c0d029fa:	9808      	ldr	r0, [sp, #32]
c0d029fc:	2801      	cmp	r0, #1
c0d029fe:	d15f      	bne.n	c0d02ac0 <u2f_transport_received+0x2d8>
                if (u2f_is_channel_broadcast(service->channel) ||
c0d02a00:	1d26      	adds	r6, r4, #4
error:
    return;
}

bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
c0d02a02:	4969      	ldr	r1, [pc, #420]	; (c0d02ba8 <u2f_transport_received+0x3c0>)
c0d02a04:	4479      	add	r1, pc
c0d02a06:	2504      	movs	r5, #4
c0d02a08:	4630      	mov	r0, r6
c0d02a0a:	462a      	mov	r2, r5
c0d02a0c:	f7fe f9f0 	bl	c0d00df0 <os_memcmp>
        // Check if the command is supported
        switch (buffer[channelHeader]) {
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
                if (u2f_is_channel_broadcast(service->channel) ||
c0d02a10:	2800      	cmp	r0, #0
c0d02a12:	d007      	beq.n	c0d02a24 <u2f_transport_received+0x23c>
bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
}

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
c0d02a14:	4965      	ldr	r1, [pc, #404]	; (c0d02bac <u2f_transport_received+0x3c4>)
c0d02a16:	4479      	add	r1, pc
c0d02a18:	2204      	movs	r2, #4
c0d02a1a:	4630      	mov	r0, r6
c0d02a1c:	f7fe f9e8 	bl	c0d00df0 <os_memcmp>
        // Check if the command is supported
        switch (buffer[channelHeader]) {
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
                if (u2f_is_channel_broadcast(service->channel) ||
c0d02a20:	2800      	cmp	r0, #0
c0d02a22:	d14d      	bne.n	c0d02ac0 <u2f_transport_received+0x2d8>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d02a24:	485e      	ldr	r0, [pc, #376]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d02a26:	210b      	movs	r1, #11
c0d02a28:	7201      	strb	r1, [r0, #8]

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d02a2a:	703d      	strb	r5, [r7, #0]
c0d02a2c:	e0b0      	b.n	c0d02b90 <u2f_transport_received+0x3a8>
c0d02a2e:	9806      	ldr	r0, [sp, #24]
c0d02a30:	9a09      	ldr	r2, [sp, #36]	; 0x24
                u2f_transport_error(service, ERROR_CHANNEL_BUSY);
                goto error;
            }
        }
        // also discriminate invalid command sent instead of a continuation
        if (buffer[channelHeader] != service->transportPacketIndex) {
c0d02a32:	1811      	adds	r1, r2, r0
c0d02a34:	5c10      	ldrb	r0, [r2, r0]
c0d02a36:	7ea2      	ldrb	r2, [r4, #26]
c0d02a38:	4290      	cmp	r0, r2
c0d02a3a:	d12f      	bne.n	c0d02a9c <u2f_transport_received+0x2b4>
            // Bad continuation packet, abort
            u2f_transport_error(service, ERROR_INVALID_SEQ);
            goto error;
        }
        xfer_len = MIN(size - (channelHeader + 1), service->transportLength - service->transportOffset);
c0d02a3c:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d02a3e:	9a04      	ldr	r2, [sp, #16]
c0d02a40:	1a85      	subs	r5, r0, r2
c0d02a42:	8ae0      	ldrh	r0, [r4, #22]
c0d02a44:	8b22      	ldrh	r2, [r4, #24]
c0d02a46:	1a12      	subs	r2, r2, r0
c0d02a48:	4295      	cmp	r5, r2
c0d02a4a:	db00      	blt.n	c0d02a4e <u2f_transport_received+0x266>
c0d02a4c:	4615      	mov	r5, r2
c0d02a4e:	9e03      	ldr	r6, [sp, #12]
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
c0d02a50:	402e      	ands	r6, r5
c0d02a52:	69e2      	ldr	r2, [r4, #28]
c0d02a54:	1810      	adds	r0, r2, r0
c0d02a56:	1c49      	adds	r1, r1, #1
c0d02a58:	4632      	mov	r2, r6
c0d02a5a:	f7fe f92c 	bl	c0d00cb6 <os_memmove>
        if (media == U2F_MEDIA_USB) {
c0d02a5e:	9808      	ldr	r0, [sp, #32]
c0d02a60:	2801      	cmp	r0, #1
c0d02a62:	d107      	bne.n	c0d02a74 <u2f_transport_received+0x28c>
            service->commandCrc = cx_crc16_update(service->commandCrc, service->transportBuffer + service->transportOffset, xfer_len);
c0d02a64:	8ae0      	ldrh	r0, [r4, #22]
c0d02a66:	69e1      	ldr	r1, [r4, #28]
c0d02a68:	1809      	adds	r1, r1, r0
c0d02a6a:	8ce0      	ldrh	r0, [r4, #38]	; 0x26
c0d02a6c:	4632      	mov	r2, r6
c0d02a6e:	f7ff fb27 	bl	c0d020c0 <cx_crc16_update>
c0d02a72:	84e0      	strh	r0, [r4, #38]	; 0x26
        }        
        service->transportOffset += xfer_len;
c0d02a74:	8ae0      	ldrh	r0, [r4, #22]
c0d02a76:	1940      	adds	r0, r0, r5
c0d02a78:	82e0      	strh	r0, [r4, #22]
        service->transportPacketIndex++;
c0d02a7a:	7ea0      	ldrb	r0, [r4, #26]
c0d02a7c:	1c40      	adds	r0, r0, #1
c0d02a7e:	76a0      	strb	r0, [r4, #26]
c0d02a80:	9b07      	ldr	r3, [sp, #28]
c0d02a82:	9d08      	ldr	r5, [sp, #32]
c0d02a84:	e045      	b.n	c0d02b12 <u2f_transport_received+0x32a>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d02a86:	4846      	ldr	r0, [pc, #280]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d02a88:	2104      	movs	r1, #4
c0d02a8a:	7201      	strb	r1, [r0, #8]
c0d02a8c:	7039      	strb	r1, [r7, #0]
c0d02a8e:	2100      	movs	r1, #0
c0d02a90:	76a1      	strb	r1, [r4, #26]
c0d02a92:	3008      	adds	r0, #8
c0d02a94:	61e0      	str	r0, [r4, #28]
c0d02a96:	82e1      	strh	r1, [r4, #22]
c0d02a98:	9807      	ldr	r0, [sp, #28]
c0d02a9a:	e6ca      	b.n	c0d02832 <u2f_transport_received+0x4a>
c0d02a9c:	4840      	ldr	r0, [pc, #256]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d02a9e:	2104      	movs	r1, #4
c0d02aa0:	7201      	strb	r1, [r0, #8]
c0d02aa2:	e043      	b.n	c0d02b2c <u2f_transport_received+0x344>
                }
            }
            // no channel for BLE
            break;
        case U2F_CMD_INIT:
            if (media != U2F_MEDIA_USB) {
c0d02aa4:	9808      	ldr	r0, [sp, #32]
c0d02aa6:	2801      	cmp	r0, #1
c0d02aa8:	d152      	bne.n	c0d02b50 <u2f_transport_received+0x368>
c0d02aaa:	9109      	str	r1, [sp, #36]	; 0x24
c0d02aac:	9203      	str	r2, [sp, #12]
                // Unknown command, abort
                u2f_transport_error(service, ERROR_INVALID_CMD);
                goto error;
            }

            if (u2f_is_channel_forbidden(service->channel)) {
c0d02aae:	1d20      	adds	r0, r4, #4
bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
}

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
c0d02ab0:	493f      	ldr	r1, [pc, #252]	; (c0d02bb0 <u2f_transport_received+0x3c8>)
c0d02ab2:	4479      	add	r1, pc
c0d02ab4:	2604      	movs	r6, #4
c0d02ab6:	4632      	mov	r2, r6
c0d02ab8:	f7fe f99a 	bl	c0d00df0 <os_memcmp>
                // Unknown command, abort
                u2f_transport_error(service, ERROR_INVALID_CMD);
                goto error;
            }

            if (u2f_is_channel_forbidden(service->channel)) {
c0d02abc:	2800      	cmp	r0, #0
c0d02abe:	d063      	beq.n	c0d02b88 <u2f_transport_received+0x3a0>
        }

        // Ok, initialize the buffer
        //if (buffer[channelHeader] != U2F_CMD_INIT) 
        {
            xfer_len = MIN(size - (channelHeader), U2F_COMMAND_HEADER_SIZE+commandLength);
c0d02ac0:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d02ac2:	9906      	ldr	r1, [sp, #24]
c0d02ac4:	1a46      	subs	r6, r0, r1
c0d02ac6:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d02ac8:	1cc0      	adds	r0, r0, #3
c0d02aca:	4286      	cmp	r6, r0
c0d02acc:	9d03      	ldr	r5, [sp, #12]
c0d02ace:	db00      	blt.n	c0d02ad2 <u2f_transport_received+0x2ea>
c0d02ad0:	4606      	mov	r6, r0
c0d02ad2:	900a      	str	r0, [sp, #40]	; 0x28
            os_memmove(service->transportBuffer, buffer + channelHeader, xfer_len);
c0d02ad4:	4035      	ands	r5, r6
c0d02ad6:	69e0      	ldr	r0, [r4, #28]
c0d02ad8:	9902      	ldr	r1, [sp, #8]
c0d02ada:	462a      	mov	r2, r5
c0d02adc:	f7fe f8eb 	bl	c0d00cb6 <os_memmove>
c0d02ae0:	9b08      	ldr	r3, [sp, #32]
            if (media == U2F_MEDIA_USB) {
c0d02ae2:	2b01      	cmp	r3, #1
c0d02ae4:	d106      	bne.n	c0d02af4 <u2f_transport_received+0x30c>
                service->commandCrc = cx_crc16_update(0, service->transportBuffer, xfer_len);
c0d02ae6:	69e1      	ldr	r1, [r4, #28]
c0d02ae8:	2000      	movs	r0, #0
c0d02aea:	462a      	mov	r2, r5
c0d02aec:	f7ff fae8 	bl	c0d020c0 <cx_crc16_update>
c0d02af0:	9b08      	ldr	r3, [sp, #32]
c0d02af2:	84e0      	strh	r0, [r4, #38]	; 0x26
            }
            service->transportOffset = xfer_len;
c0d02af4:	82e6      	strh	r6, [r4, #22]
            service->transportLength = U2F_COMMAND_HEADER_SIZE+commandLength;
c0d02af6:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d02af8:	8320      	strh	r0, [r4, #24]
            service->transportMedia = media;
c0d02afa:	2021      	movs	r0, #33	; 0x21
c0d02afc:	5423      	strb	r3, [r4, r0]
            // initialize the response
            service->transportPacketIndex = 0;
c0d02afe:	2000      	movs	r0, #0
c0d02b00:	76a0      	strb	r0, [r4, #26]
            os_memmove(service->transportChannel, service->channel, 4);
c0d02b02:	4620      	mov	r0, r4
c0d02b04:	3012      	adds	r0, #18
c0d02b06:	1d21      	adds	r1, r4, #4
c0d02b08:	2204      	movs	r2, #4
c0d02b0a:	461d      	mov	r5, r3
c0d02b0c:	f7fe f8d3 	bl	c0d00cb6 <os_memmove>
c0d02b10:	9b07      	ldr	r3, [sp, #28]
c0d02b12:	8ae0      	ldrh	r0, [r4, #22]
        }        
        service->transportOffset += xfer_len;
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
c0d02b14:	2d01      	cmp	r5, #1
c0d02b16:	d101      	bne.n	c0d02b1c <u2f_transport_received+0x334>
c0d02b18:	8b21      	ldrh	r1, [r4, #24]
c0d02b1a:	e013      	b.n	c0d02b44 <u2f_transport_received+0x35c>
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
c0d02b1c:	8b21      	ldrh	r1, [r4, #24]
c0d02b1e:	1cca      	adds	r2, r1, #3
        }        
        service->transportOffset += xfer_len;
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
c0d02b20:	4290      	cmp	r0, r2
c0d02b22:	d90f      	bls.n	c0d02b44 <u2f_transport_received+0x35c>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d02b24:	481e      	ldr	r0, [pc, #120]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d02b26:	2103      	movs	r1, #3
c0d02b28:	7201      	strb	r1, [r0, #8]

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d02b2a:	2104      	movs	r1, #4
c0d02b2c:	7039      	strb	r1, [r7, #0]
c0d02b2e:	2100      	movs	r1, #0
c0d02b30:	76a1      	strb	r1, [r4, #26]
c0d02b32:	3008      	adds	r0, #8
c0d02b34:	61e0      	str	r0, [r4, #28]
c0d02b36:	82e1      	strh	r1, [r4, #22]
c0d02b38:	8323      	strh	r3, [r4, #24]
c0d02b3a:	9905      	ldr	r1, [sp, #20]
c0d02b3c:	313a      	adds	r1, #58	; 0x3a
c0d02b3e:	2040      	movs	r0, #64	; 0x40
c0d02b40:	5421      	strb	r1, [r4, r0]
c0d02b42:	e6db      	b.n	c0d028fc <u2f_transport_received+0x114>
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
c0d02b44:	4288      	cmp	r0, r1
c0d02b46:	d206      	bcs.n	c0d02b56 <u2f_transport_received+0x36e>
c0d02b48:	2000      	movs	r0, #0
        service->transportState = U2F_PROCESSING_COMMAND;
        // internal notification of a complete message received
        u2f_message_complete(service);
    } else {
        // new segment received, reset the timeout for the current piece
        service->seqTimeout = 0;
c0d02b4a:	6360      	str	r0, [r4, #52]	; 0x34
        service->transportState = U2F_HANDLE_SEGMENTED;
c0d02b4c:	703b      	strb	r3, [r7, #0]
c0d02b4e:	e6d9      	b.n	c0d02904 <u2f_transport_received+0x11c>
c0d02b50:	4813      	ldr	r0, [pc, #76]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d02b52:	7203      	strb	r3, [r0, #8]
c0d02b54:	e6c7      	b.n	c0d028e6 <u2f_transport_received+0xfe>
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
        // switch before the handler gets the opportunity to change it again
        service->transportState = U2F_PROCESSING_COMMAND;
c0d02b56:	2002      	movs	r0, #2
c0d02b58:	7038      	strb	r0, [r7, #0]
        // internal notification of a complete message received
        u2f_message_complete(service);
c0d02b5a:	4620      	mov	r0, r4
c0d02b5c:	f7ff fca8 	bl	c0d024b0 <u2f_message_complete>
c0d02b60:	e6d0      	b.n	c0d02904 <u2f_transport_received+0x11c>
                // special error case, we reply but don't change the current state of the transport (ongoing message for example)
                //u2f_transport_error_no_reset(service, ERROR_CHANNEL_BUSY);
                uint16_t offset = 0;
                // Fragment
                if (media == U2F_MEDIA_USB) {
                    os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d02b62:	4c0f      	ldr	r4, [pc, #60]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d02b64:	2204      	movs	r2, #4
c0d02b66:	4620      	mov	r0, r4
c0d02b68:	9901      	ldr	r1, [sp, #4]
c0d02b6a:	f7fe f8a4 	bl	c0d00cb6 <os_memmove>
                    offset += 4;
                }
                G_io_usb_ep_buffer[offset++] = U2F_STATUS_ERROR;
c0d02b6e:	353a      	adds	r5, #58	; 0x3a
c0d02b70:	7125      	strb	r5, [r4, #4]
                G_io_usb_ep_buffer[offset++] = 0;
c0d02b72:	2000      	movs	r0, #0
c0d02b74:	7160      	strb	r0, [r4, #5]
c0d02b76:	9a07      	ldr	r2, [sp, #28]
                G_io_usb_ep_buffer[offset++] = 1;
c0d02b78:	71a2      	strb	r2, [r4, #6]
c0d02b7a:	2006      	movs	r0, #6
                G_io_usb_ep_buffer[offset++] = ERROR_CHANNEL_BUSY;
c0d02b7c:	71e0      	strb	r0, [r4, #7]
                u2f_io_send(G_io_usb_ep_buffer, offset, media);
c0d02b7e:	2108      	movs	r1, #8
c0d02b80:	4620      	mov	r0, r4
c0d02b82:	f7ff fcb3 	bl	c0d024ec <u2f_io_send>
c0d02b86:	e6bd      	b.n	c0d02904 <u2f_transport_received+0x11c>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d02b88:	4805      	ldr	r0, [pc, #20]	; (c0d02ba0 <u2f_transport_received+0x3b8>)
c0d02b8a:	210b      	movs	r1, #11
c0d02b8c:	7201      	strb	r1, [r0, #8]

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d02b8e:	703e      	strb	r6, [r7, #0]
c0d02b90:	2100      	movs	r1, #0
c0d02b92:	76a1      	strb	r1, [r4, #26]
c0d02b94:	3008      	adds	r0, #8
c0d02b96:	61e0      	str	r0, [r4, #28]
c0d02b98:	82e1      	strh	r1, [r4, #22]
c0d02b9a:	9807      	ldr	r0, [sp, #28]
c0d02b9c:	8320      	strh	r0, [r4, #24]
c0d02b9e:	e7cc      	b.n	c0d02b3a <u2f_transport_received+0x352>
c0d02ba0:	20001ac0 	.word	0x20001ac0
c0d02ba4:	0000ffff 	.word	0x0000ffff
c0d02ba8:	000019ec 	.word	0x000019ec
c0d02bac:	000019de 	.word	0x000019de
c0d02bb0:	00001942 	.word	0x00001942

c0d02bb4 <u2f_is_channel_broadcast>:
    }
error:
    return;
}

bool u2f_is_channel_broadcast(uint8_t *channel) {
c0d02bb4:	b580      	push	{r7, lr}
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
c0d02bb6:	4906      	ldr	r1, [pc, #24]	; (c0d02bd0 <u2f_is_channel_broadcast+0x1c>)
c0d02bb8:	4479      	add	r1, pc
c0d02bba:	2204      	movs	r2, #4
c0d02bbc:	f7fe f918 	bl	c0d00df0 <os_memcmp>
c0d02bc0:	4601      	mov	r1, r0
c0d02bc2:	2001      	movs	r0, #1
c0d02bc4:	2200      	movs	r2, #0
c0d02bc6:	2900      	cmp	r1, #0
c0d02bc8:	d000      	beq.n	c0d02bcc <u2f_is_channel_broadcast+0x18>
c0d02bca:	4610      	mov	r0, r2
c0d02bcc:	bd80      	pop	{r7, pc}
c0d02bce:	46c0      	nop			; (mov r8, r8)
c0d02bd0:	00001838 	.word	0x00001838

c0d02bd4 <u2f_message_set_autoreply_wait_user_presence>:
}

/**
 * Auto reply hodl until the real reply is prepared and sent
 */
void u2f_message_set_autoreply_wait_user_presence(u2f_service_t* service, bool enabled) {
c0d02bd4:	b580      	push	{r7, lr}
c0d02bd6:	222a      	movs	r2, #42	; 0x2a
c0d02bd8:	5c83      	ldrb	r3, [r0, r2]
c0d02bda:	4602      	mov	r2, r0
c0d02bdc:	322a      	adds	r2, #42	; 0x2a

    if (enabled) {
c0d02bde:	2901      	cmp	r1, #1
c0d02be0:	d106      	bne.n	c0d02bf0 <u2f_message_set_autoreply_wait_user_presence+0x1c>
        // start replying placeholder until user presence validated
        if (service->waitAsynchronousResponse == U2F_WAIT_ASYNCH_IDLE) {
c0d02be2:	2b00      	cmp	r3, #0
c0d02be4:	d108      	bne.n	c0d02bf8 <u2f_message_set_autoreply_wait_user_presence+0x24>
            service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_ON;
c0d02be6:	2101      	movs	r1, #1
c0d02be8:	7011      	strb	r1, [r2, #0]
            u2f_transport_send_usb_user_presence_required(service);
c0d02bea:	f7ff fd39 	bl	c0d02660 <u2f_transport_send_usb_user_presence_required>
    }
    // don't set to REPLY_READY when it has not been enabled beforehand
    else if (service->waitAsynchronousResponse == U2F_WAIT_ASYNCH_ON) {
        service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_REPLY_READY;
    }
}
c0d02bee:	bd80      	pop	{r7, pc}
            service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_ON;
            u2f_transport_send_usb_user_presence_required(service);
        }
    }
    // don't set to REPLY_READY when it has not been enabled beforehand
    else if (service->waitAsynchronousResponse == U2F_WAIT_ASYNCH_ON) {
c0d02bf0:	2b01      	cmp	r3, #1
c0d02bf2:	d101      	bne.n	c0d02bf8 <u2f_message_set_autoreply_wait_user_presence+0x24>
        service->waitAsynchronousResponse = U2F_WAIT_ASYNCH_REPLY_READY;
c0d02bf4:	2002      	movs	r0, #2
c0d02bf6:	7010      	strb	r0, [r2, #0]
    }
}
c0d02bf8:	bd80      	pop	{r7, pc}

c0d02bfa <u2f_message_repliable>:

bool u2f_message_repliable(u2f_service_t* service) {
c0d02bfa:	4601      	mov	r1, r0
    // no more asynch replies
    // finished receiving the command
    // and not sending a user presence required status
    return service->waitAsynchronousResponse == U2F_WAIT_ASYNCH_IDLE
c0d02bfc:	202a      	movs	r0, #42	; 0x2a
c0d02bfe:	5c0a      	ldrb	r2, [r1, r0]
c0d02c00:	2001      	movs	r0, #1
        || (service->waitAsynchronousResponse != U2F_WAIT_ASYNCH_ON 
c0d02c02:	2a00      	cmp	r2, #0
c0d02c04:	d010      	beq.n	c0d02c28 <u2f_message_repliable+0x2e>
c0d02c06:	2a01      	cmp	r2, #1
c0d02c08:	d101      	bne.n	c0d02c0e <u2f_message_repliable+0x14>
c0d02c0a:	2000      	movs	r0, #0

bool u2f_message_repliable(u2f_service_t* service) {
    // no more asynch replies
    // finished receiving the command
    // and not sending a user presence required status
    return service->waitAsynchronousResponse == U2F_WAIT_ASYNCH_IDLE
c0d02c0c:	4770      	bx	lr
        || (service->waitAsynchronousResponse != U2F_WAIT_ASYNCH_ON 
            && service->fakeChannelTransportState == U2F_FAKE_RECEIVED 
c0d02c0e:	2025      	movs	r0, #37	; 0x25
c0d02c10:	5c0a      	ldrb	r2, [r1, r0]
c0d02c12:	2000      	movs	r0, #0
            && service->sending == false)
c0d02c14:	2a06      	cmp	r2, #6
c0d02c16:	d107      	bne.n	c0d02c28 <u2f_message_repliable+0x2e>
c0d02c18:	202b      	movs	r0, #43	; 0x2b
c0d02c1a:	5c0a      	ldrb	r2, [r1, r0]
c0d02c1c:	2001      	movs	r0, #1
c0d02c1e:	2100      	movs	r1, #0
c0d02c20:	2a00      	cmp	r2, #0
c0d02c22:	d001      	beq.n	c0d02c28 <u2f_message_repliable+0x2e>
c0d02c24:	4608      	mov	r0, r1

bool u2f_message_repliable(u2f_service_t* service) {
    // no more asynch replies
    // finished receiving the command
    // and not sending a user presence required status
    return service->waitAsynchronousResponse == U2F_WAIT_ASYNCH_IDLE
c0d02c26:	4770      	bx	lr
c0d02c28:	4770      	bx	lr

c0d02c2a <u2f_message_reply>:
            && service->fakeChannelTransportState == U2F_FAKE_RECEIVED 
            && service->sending == false)
        ;
}

void u2f_message_reply(u2f_service_t *service, uint8_t cmd, uint8_t *buffer, uint16_t len) {
c0d02c2a:	b5b0      	push	{r4, r5, r7, lr}

bool u2f_message_repliable(u2f_service_t* service) {
    // no more asynch replies
    // finished receiving the command
    // and not sending a user presence required status
    return service->waitAsynchronousResponse == U2F_WAIT_ASYNCH_IDLE
c0d02c2c:	242a      	movs	r4, #42	; 0x2a
c0d02c2e:	5d04      	ldrb	r4, [r0, r4]
        || (service->waitAsynchronousResponse != U2F_WAIT_ASYNCH_ON 
c0d02c30:	2c00      	cmp	r4, #0
c0d02c32:	d009      	beq.n	c0d02c48 <u2f_message_reply+0x1e>
c0d02c34:	2c01      	cmp	r4, #1
c0d02c36:	d015      	beq.n	c0d02c64 <u2f_message_reply+0x3a>
            && service->fakeChannelTransportState == U2F_FAKE_RECEIVED 
c0d02c38:	2425      	movs	r4, #37	; 0x25
c0d02c3a:	5d04      	ldrb	r4, [r0, r4]
            && service->sending == false)
c0d02c3c:	2c06      	cmp	r4, #6
c0d02c3e:	d111      	bne.n	c0d02c64 <u2f_message_reply+0x3a>
c0d02c40:	242b      	movs	r4, #43	; 0x2b
c0d02c42:	5d04      	ldrb	r4, [r0, r4]
}

void u2f_message_reply(u2f_service_t *service, uint8_t cmd, uint8_t *buffer, uint16_t len) {

    // if U2F is not ready to reply, then gently avoid replying
    if (u2f_message_repliable(service)) 
c0d02c44:	2c00      	cmp	r4, #0
c0d02c46:	d10d      	bne.n	c0d02c64 <u2f_message_reply+0x3a>
    {
        service->transportState = U2F_SENDING_RESPONSE;
c0d02c48:	2420      	movs	r4, #32
c0d02c4a:	2503      	movs	r5, #3
c0d02c4c:	5505      	strb	r5, [r0, r4]
c0d02c4e:	2400      	movs	r4, #0
        service->transportPacketIndex = 0;
c0d02c50:	7684      	strb	r4, [r0, #26]
        service->transportBuffer = buffer;
c0d02c52:	61c2      	str	r2, [r0, #28]
        service->transportOffset = 0;
c0d02c54:	82c4      	strh	r4, [r0, #22]
        service->transportLength = len;
c0d02c56:	8303      	strh	r3, [r0, #24]
        service->sendCmd = cmd;
c0d02c58:	2240      	movs	r2, #64	; 0x40
c0d02c5a:	5481      	strb	r1, [r0, r2]
        // pump the first message
        u2f_transport_sent(service, service->transportMedia);
c0d02c5c:	2121      	movs	r1, #33	; 0x21
c0d02c5e:	5c41      	ldrb	r1, [r0, r1]
c0d02c60:	f7ff fc88 	bl	c0d02574 <u2f_transport_sent>
    }
}
c0d02c64:	bdb0      	pop	{r4, r5, r7, pc}
	...

c0d02c68 <ui_idle>:
    return 0;
}


/** show the idle screen. */
void ui_idle(void) {
c0d02c68:	b5b0      	push	{r4, r5, r7, lr}
    uiState = UI_IDLE;
c0d02c6a:	4823      	ldr	r0, [pc, #140]	; (c0d02cf8 <ui_idle+0x90>)
c0d02c6c:	2101      	movs	r1, #1
c0d02c6e:	7001      	strb	r1, [r0, #0]

#if defined(TARGET_BLUE)
        UX_DISPLAY(bagl_ui_idle_blue, NULL);
#elif defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_idle_nanos, NULL);
c0d02c70:	4c22      	ldr	r4, [pc, #136]	; (c0d02cfc <ui_idle+0x94>)
c0d02c72:	4824      	ldr	r0, [pc, #144]	; (c0d02d04 <ui_idle+0x9c>)
c0d02c74:	4478      	add	r0, pc
c0d02c76:	6020      	str	r0, [r4, #0]
c0d02c78:	2004      	movs	r0, #4
c0d02c7a:	6060      	str	r0, [r4, #4]
c0d02c7c:	4822      	ldr	r0, [pc, #136]	; (c0d02d08 <ui_idle+0xa0>)
c0d02c7e:	4478      	add	r0, pc
c0d02c80:	6120      	str	r0, [r4, #16]
c0d02c82:	2500      	movs	r5, #0
c0d02c84:	60e5      	str	r5, [r4, #12]
c0d02c86:	2003      	movs	r0, #3
c0d02c88:	7620      	strb	r0, [r4, #24]
c0d02c8a:	61e5      	str	r5, [r4, #28]
c0d02c8c:	4620      	mov	r0, r4
c0d02c8e:	3018      	adds	r0, #24
c0d02c90:	f7ff fa5c 	bl	c0d0214c <os_ux>
c0d02c94:	61e0      	str	r0, [r4, #28]
c0d02c96:	f7fe fd52 	bl	c0d0173e <ux_check_status_default>
c0d02c9a:	f7fe fa1d 	bl	c0d010d8 <io_seproxyhal_init_ux>
c0d02c9e:	f7fe fa21 	bl	c0d010e4 <io_seproxyhal_init_button>
c0d02ca2:	60a5      	str	r5, [r4, #8]
c0d02ca4:	6820      	ldr	r0, [r4, #0]
c0d02ca6:	2800      	cmp	r0, #0
c0d02ca8:	d024      	beq.n	c0d02cf4 <ui_idle+0x8c>
c0d02caa:	69e0      	ldr	r0, [r4, #28]
c0d02cac:	4914      	ldr	r1, [pc, #80]	; (c0d02d00 <ui_idle+0x98>)
c0d02cae:	4288      	cmp	r0, r1
c0d02cb0:	d11e      	bne.n	c0d02cf0 <ui_idle+0x88>
c0d02cb2:	e01f      	b.n	c0d02cf4 <ui_idle+0x8c>
c0d02cb4:	6860      	ldr	r0, [r4, #4]
c0d02cb6:	4285      	cmp	r5, r0
c0d02cb8:	d21c      	bcs.n	c0d02cf4 <ui_idle+0x8c>
c0d02cba:	f7ff faa1 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d02cbe:	2800      	cmp	r0, #0
c0d02cc0:	d118      	bne.n	c0d02cf4 <ui_idle+0x8c>
c0d02cc2:	68a0      	ldr	r0, [r4, #8]
c0d02cc4:	68e1      	ldr	r1, [r4, #12]
c0d02cc6:	2538      	movs	r5, #56	; 0x38
c0d02cc8:	4368      	muls	r0, r5
c0d02cca:	6822      	ldr	r2, [r4, #0]
c0d02ccc:	1810      	adds	r0, r2, r0
c0d02cce:	2900      	cmp	r1, #0
c0d02cd0:	d002      	beq.n	c0d02cd8 <ui_idle+0x70>
c0d02cd2:	4788      	blx	r1
c0d02cd4:	2800      	cmp	r0, #0
c0d02cd6:	d007      	beq.n	c0d02ce8 <ui_idle+0x80>
c0d02cd8:	2801      	cmp	r0, #1
c0d02cda:	d103      	bne.n	c0d02ce4 <ui_idle+0x7c>
c0d02cdc:	68a0      	ldr	r0, [r4, #8]
c0d02cde:	4345      	muls	r5, r0
c0d02ce0:	6820      	ldr	r0, [r4, #0]
c0d02ce2:	1940      	adds	r0, r0, r5
c0d02ce4:	f7fd fa18 	bl	c0d00118 <io_seproxyhal_display>
c0d02ce8:	68a0      	ldr	r0, [r4, #8]
c0d02cea:	1c45      	adds	r5, r0, #1
c0d02cec:	60a5      	str	r5, [r4, #8]
c0d02cee:	6820      	ldr	r0, [r4, #0]
c0d02cf0:	2800      	cmp	r0, #0
c0d02cf2:	d1df      	bne.n	c0d02cb4 <ui_idle+0x4c>
    if(G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_idle_flow, NULL);
#endif // #if TARGET_ID
}
c0d02cf4:	bdb0      	pop	{r4, r5, r7, pc}
c0d02cf6:	46c0      	nop			; (mov r8, r8)
c0d02cf8:	20001b84 	.word	0x20001b84
c0d02cfc:	20001b88 	.word	0x20001b88
c0d02d00:	b0105044 	.word	0xb0105044
c0d02d04:	000018a4 	.word	0x000018a4
c0d02d08:	0000020b 	.word	0x0000020b

c0d02d0c <sign_touch_ok>:
    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

unsigned int sign_touch_ok(const bagl_element_t *e) {
c0d02d0c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02d0e:	b0d5      	sub	sp, #340	; 0x154
c0d02d10:	2000      	movs	r0, #0
    
    volatile unsigned int tx = 0;
c0d02d12:	9054      	str	r0, [sp, #336]	; 0x150
c0d02d14:	4d48      	ldr	r5, [pc, #288]	; (c0d02e38 <sign_touch_ok+0x12c>)
    // 首先获取BIP44路径
    unsigned char *bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;
    unsigned int bip44_path[BIP44_PATH_LEN];
    uint8_t i;
    for (i = 0; i < BIP44_PATH_LEN; i++) {
            bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
c0d02d16:	0081      	lsls	r1, r0, #2
c0d02d18:	186a      	adds	r2, r5, r1
c0d02d1a:	7953      	ldrb	r3, [r2, #5]
c0d02d1c:	061b      	lsls	r3, r3, #24
c0d02d1e:	7994      	ldrb	r4, [r2, #6]
c0d02d20:	0424      	lsls	r4, r4, #16
c0d02d22:	431c      	orrs	r4, r3
c0d02d24:	79d3      	ldrb	r3, [r2, #7]
c0d02d26:	021b      	lsls	r3, r3, #8
c0d02d28:	4323      	orrs	r3, r4
c0d02d2a:	7a12      	ldrb	r2, [r2, #8]
c0d02d2c:	431a      	orrs	r2, r3
c0d02d2e:	ab4f      	add	r3, sp, #316	; 0x13c
c0d02d30:	505a      	str	r2, [r3, r1]

    // 首先获取BIP44路径
    unsigned char *bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;
    unsigned int bip44_path[BIP44_PATH_LEN];
    uint8_t i;
    for (i = 0; i < BIP44_PATH_LEN; i++) {
c0d02d32:	1c40      	adds	r0, r0, #1
c0d02d34:	2805      	cmp	r0, #5
c0d02d36:	d1ee      	bne.n	c0d02d16 <sign_touch_ok+0xa>
    }
    // 获取待签名的hash值
    unsigned char hash[32];
    unsigned char* hash_ptr = G_io_apdu_buffer + APDU_HEADER_LENGTH + BIP44_PATH_LEN*4;
    for (i = 0; i < sizeof(hash); i++){
        hash[i] = *(hash_ptr + i);
c0d02d38:	4629      	mov	r1, r5
c0d02d3a:	3119      	adds	r1, #25
c0d02d3c:	a847      	add	r0, sp, #284	; 0x11c
c0d02d3e:	9005      	str	r0, [sp, #20]
c0d02d40:	2220      	movs	r2, #32
c0d02d42:	9207      	str	r2, [sp, #28]
c0d02d44:	f001 fa32 	bl	c0d041ac <__aeabi_memcpy>
c0d02d48:	2700      	movs	r7, #0
    }

    cx_ecfp_private_key_t privateKey;
    unsigned char privateKeyData[32];
    os_perso_derive_node_bip32(CX_CURVE_256K1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);
c0d02d4a:	4668      	mov	r0, sp
c0d02d4c:	6007      	str	r7, [r0, #0]
c0d02d4e:	2621      	movs	r6, #33	; 0x21
c0d02d50:	9604      	str	r6, [sp, #16]
c0d02d52:	a94f      	add	r1, sp, #316	; 0x13c
c0d02d54:	2205      	movs	r2, #5
c0d02d56:	ac35      	add	r4, sp, #212	; 0xd4
c0d02d58:	4630      	mov	r0, r6
c0d02d5a:	4623      	mov	r3, r4
c0d02d5c:	f7ff f9c8 	bl	c0d020f0 <os_perso_derive_node_bip32>
c0d02d60:	ab3d      	add	r3, sp, #244	; 0xf4
    cx_ecdsa_init_private_key(CX_CURVE_256K1, privateKeyData, 32, &privateKey);
c0d02d62:	9306      	str	r3, [sp, #24]
c0d02d64:	4630      	mov	r0, r6
c0d02d66:	4621      	mov	r1, r4
c0d02d68:	9e07      	ldr	r6, [sp, #28]
c0d02d6a:	4632      	mov	r2, r6
c0d02d6c:	f7ff f958 	bl	c0d02020 <cx_ecfp_init_private_key>
    os_memset(privateKeyData, 0, sizeof(privateKeyData));
c0d02d70:	4620      	mov	r0, r4
c0d02d72:	4639      	mov	r1, r7
c0d02d74:	4632      	mov	r2, r6
c0d02d76:	f7fd ff95 	bl	c0d00ca4 <os_memset>
c0d02d7a:	ac22      	add	r4, sp, #136	; 0x88
c0d02d7c:	9e04      	ldr	r6, [sp, #16]

    // generate the public key.
    cx_ecfp_public_key_t publicKey;
    cx_ecdsa_init_public_key(CX_CURVE_256K1, NULL, 0, &publicKey);
c0d02d7e:	4630      	mov	r0, r6
c0d02d80:	4639      	mov	r1, r7
c0d02d82:	463a      	mov	r2, r7
c0d02d84:	4623      	mov	r3, r4
c0d02d86:	f7ff f933 	bl	c0d01ff0 <cx_ecfp_init_public_key>
c0d02d8a:	2301      	movs	r3, #1
    cx_ecfp_generate_pair(CX_CURVE_256K1, &publicKey, &privateKey, 1);
c0d02d8c:	4630      	mov	r0, r6
c0d02d8e:	4621      	mov	r1, r4
c0d02d90:	9a06      	ldr	r2, [sp, #24]
c0d02d92:	f7ff f95d 	bl	c0d02050 <cx_ecfp_generate_pair>
    
    // 进行签名
    uint8_t signature[100];
    unsigned int info = 0;
c0d02d96:	9708      	str	r7, [sp, #32]
c0d02d98:	ae09      	add	r6, sp, #36	; 0x24
    os_memset(signature, 0, sizeof(signature));
c0d02d9a:	2464      	movs	r4, #100	; 0x64
c0d02d9c:	4630      	mov	r0, r6
c0d02d9e:	4639      	mov	r1, r7
c0d02da0:	4622      	mov	r2, r4
c0d02da2:	f7fd ff7f 	bl	c0d00ca4 <os_memset>
c0d02da6:	a808      	add	r0, sp, #32
    uint8_t signatureLength;
    signatureLength =
        cx_ecdsa_sign(&privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256,
c0d02da8:	4669      	mov	r1, sp
c0d02daa:	9a07      	ldr	r2, [sp, #28]
c0d02dac:	c144      	stmia	r1!, {r2, r6}
c0d02dae:	600c      	str	r4, [r1, #0]
c0d02db0:	6048      	str	r0, [r1, #4]
c0d02db2:	4922      	ldr	r1, [pc, #136]	; (c0d02e3c <sign_touch_ok+0x130>)
c0d02db4:	2203      	movs	r2, #3
c0d02db6:	9204      	str	r2, [sp, #16]
c0d02db8:	9c06      	ldr	r4, [sp, #24]
c0d02dba:	4620      	mov	r0, r4
c0d02dbc:	9b05      	ldr	r3, [sp, #20]
c0d02dbe:	f7ff f95f 	bl	c0d02080 <cx_ecdsa_sign>
c0d02dc2:	9005      	str	r0, [sp, #20]
                    hash,
                    sizeof(hash), signature, sizeof(signature),  &info);
    os_memset(&privateKey, 0, sizeof(privateKey));
c0d02dc4:	2228      	movs	r2, #40	; 0x28
c0d02dc6:	4620      	mov	r0, r4
c0d02dc8:	9706      	str	r7, [sp, #24]
c0d02dca:	4639      	mov	r1, r7
c0d02dcc:	f7fd ff6a 	bl	c0d00ca4 <os_memset>
    G_io_apdu_buffer[0] = 27;
    if (info & CX_ECCINFO_PARITY_ODD) {
c0d02dd0:	9808      	ldr	r0, [sp, #32]
c0d02dd2:	9904      	ldr	r1, [sp, #16]
c0d02dd4:	4008      	ands	r0, r1
    G_io_apdu_buffer[0]++;
    }
    if (info & CX_ECCINFO_xGTn) {
c0d02dd6:	301b      	adds	r0, #27
                    hash,
                    sizeof(hash), signature, sizeof(signature),  &info);
    os_memset(&privateKey, 0, sizeof(privateKey));
    G_io_apdu_buffer[0] = 27;
    if (info & CX_ECCINFO_PARITY_ODD) {
    G_io_apdu_buffer[0]++;
c0d02dd8:	7028      	strb	r0, [r5, #0]
    }
    uint8_t rLength = signature[3];
    uint8_t sLength = signature[4 + rLength + 1];
    uint8_t rOffset = (rLength == 33 ? 1 : 0);
    uint8_t sOffset = (sLength == 33 ? 1 : 0);
    os_memmove(G_io_apdu_buffer + 1, signature + 4 + rOffset, 32);
c0d02dda:	1d71      	adds	r1, r6, #5
c0d02ddc:	1d34      	adds	r4, r6, #4
    G_io_apdu_buffer[0]++;
    }
    if (info & CX_ECCINFO_xGTn) {
    G_io_apdu_buffer[0] += 2;
    }
    uint8_t rLength = signature[3];
c0d02dde:	78f7      	ldrb	r7, [r6, #3]
    uint8_t sLength = signature[4 + rLength + 1];
    uint8_t rOffset = (rLength == 33 ? 1 : 0);
    uint8_t sOffset = (sLength == 33 ? 1 : 0);
    os_memmove(G_io_apdu_buffer + 1, signature + 4 + rOffset, 32);
c0d02de0:	2f21      	cmp	r7, #33	; 0x21
c0d02de2:	d000      	beq.n	c0d02de6 <sign_touch_ok+0xda>
c0d02de4:	4621      	mov	r1, r4
c0d02de6:	19f0      	adds	r0, r6, r7
    }
    if (info & CX_ECCINFO_xGTn) {
    G_io_apdu_buffer[0] += 2;
    }
    uint8_t rLength = signature[3];
    uint8_t sLength = signature[4 + rLength + 1];
c0d02de8:	7946      	ldrb	r6, [r0, #5]
    uint8_t rOffset = (rLength == 33 ? 1 : 0);
    uint8_t sOffset = (sLength == 33 ? 1 : 0);
    os_memmove(G_io_apdu_buffer + 1, signature + 4 + rOffset, 32);
c0d02dea:	1c68      	adds	r0, r5, #1
c0d02dec:	9a07      	ldr	r2, [sp, #28]
c0d02dee:	f7fd ff62 	bl	c0d00cb6 <os_memmove>
    os_memmove(G_io_apdu_buffer + 1 + 32, signature + 4 + rLength + 2 + sOffset, 32);
c0d02df2:	19e1      	adds	r1, r4, r7
c0d02df4:	1c48      	adds	r0, r1, #1
c0d02df6:	2e21      	cmp	r6, #33	; 0x21
c0d02df8:	d000      	beq.n	c0d02dfc <sign_touch_ok+0xf0>
c0d02dfa:	4608      	mov	r0, r1
c0d02dfc:	1c81      	adds	r1, r0, #2
c0d02dfe:	4628      	mov	r0, r5
c0d02e00:	3021      	adds	r0, #33	; 0x21
c0d02e02:	9c07      	ldr	r4, [sp, #28]
c0d02e04:	4622      	mov	r2, r4
c0d02e06:	f7fd ff56 	bl	c0d00cb6 <os_memmove>
    
    // os_memmove(G_io_apdu_buffer+1+32+32, publicKey.W, 65);
    // os_memmove(G_io_apdu_buffer+1+32+32+65, hash, 32);
    tx = signatureLength;
c0d02e0a:	9805      	ldr	r0, [sp, #20]
c0d02e0c:	b2c0      	uxtb	r0, r0
c0d02e0e:	9054      	str	r0, [sp, #336]	; 0x150

    G_io_apdu_buffer[tx++] = 0x90;
c0d02e10:	9854      	ldr	r0, [sp, #336]	; 0x150
c0d02e12:	1c41      	adds	r1, r0, #1
c0d02e14:	9154      	str	r1, [sp, #336]	; 0x150
c0d02e16:	2190      	movs	r1, #144	; 0x90
c0d02e18:	5429      	strb	r1, [r5, r0]
    G_io_apdu_buffer[tx++] = 0x00;
c0d02e1a:	9854      	ldr	r0, [sp, #336]	; 0x150
c0d02e1c:	1c41      	adds	r1, r0, #1
c0d02e1e:	9154      	str	r1, [sp, #336]	; 0x150
c0d02e20:	9e06      	ldr	r6, [sp, #24]
c0d02e22:	542e      	strb	r6, [r5, r0]
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, tx);
c0d02e24:	9854      	ldr	r0, [sp, #336]	; 0x150
c0d02e26:	b281      	uxth	r1, r0
c0d02e28:	4620      	mov	r0, r4
c0d02e2a:	f7fe fb49 	bl	c0d014c0 <io_exchange>

    // Display back the original UX
    ui_idle();
c0d02e2e:	f7ff ff1b 	bl	c0d02c68 <ui_idle>
    return 0; // do not redraw the widget
c0d02e32:	4630      	mov	r0, r6
c0d02e34:	b055      	add	sp, #340	; 0x154
c0d02e36:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02e38:	200018f8 	.word	0x200018f8
c0d02e3c:	00000601 	.word	0x00000601

c0d02e40 <update_sign_hash>:
}

void update_sign_hash() {
c0d02e40:	b570      	push	{r4, r5, r6, lr}
c0d02e42:	b088      	sub	sp, #32
        // 获取待签名的hash值
    unsigned char hash[32];
    unsigned char* hash_ptr = G_io_apdu_buffer + APDU_HEADER_LENGTH + BIP44_PATH_LEN*4;
    for (uint8_t i = 0; i < sizeof(hash); i++){
        hash[i] = *(hash_ptr + i);
c0d02e44:	490f      	ldr	r1, [pc, #60]	; (c0d02e84 <update_sign_hash+0x44>)
c0d02e46:	3119      	adds	r1, #25
c0d02e48:	466c      	mov	r4, sp
c0d02e4a:	2220      	movs	r2, #32
c0d02e4c:	4620      	mov	r0, r4
c0d02e4e:	f001 f9ad 	bl	c0d041ac <__aeabi_memcpy>
    }
    os_memset(sign_hash, 0, sizeof(sign_hash));
c0d02e52:	4d0d      	ldr	r5, [pc, #52]	; (c0d02e88 <update_sign_hash+0x48>)
c0d02e54:	2100      	movs	r1, #0
c0d02e56:	220c      	movs	r2, #12
c0d02e58:	4628      	mov	r0, r5
c0d02e5a:	f7fd ff23 	bl	c0d00ca4 <os_memset>
    hex_to_str(hash, sign_hash, 2);
c0d02e5e:	2602      	movs	r6, #2
c0d02e60:	4620      	mov	r0, r4
c0d02e62:	4629      	mov	r1, r5
c0d02e64:	4632      	mov	r2, r6
c0d02e66:	f001 f8ed 	bl	c0d04044 <hex_to_str>
    sign_hash[4] = '*';
c0d02e6a:	202a      	movs	r0, #42	; 0x2a
c0d02e6c:	7128      	strb	r0, [r5, #4]
    sign_hash[5] = '*';
c0d02e6e:	7168      	strb	r0, [r5, #5]
    sign_hash[6] = '*';
c0d02e70:	71a8      	strb	r0, [r5, #6]
    hex_to_str(hash+30, sign_hash+7, 2);
c0d02e72:	341e      	adds	r4, #30
c0d02e74:	1de9      	adds	r1, r5, #7
c0d02e76:	4620      	mov	r0, r4
c0d02e78:	4632      	mov	r2, r6
c0d02e7a:	f001 f8e3 	bl	c0d04044 <hex_to_str>
}
c0d02e7e:	b008      	add	sp, #32
c0d02e80:	bd70      	pop	{r4, r5, r6, pc}
c0d02e82:	46c0      	nop			; (mov r8, r8)
c0d02e84:	200018f8 	.word	0x200018f8
c0d02e88:	20001b00 	.word	0x20001b00

c0d02e8c <bagl_ui_idle_nanos_button>:
/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_idle_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d02e8c:	b580      	push	{r7, lr}
    switch (button_mask) {
c0d02e8e:	4904      	ldr	r1, [pc, #16]	; (c0d02ea0 <bagl_ui_idle_nanos_button+0x14>)
c0d02e90:	4288      	cmp	r0, r1
c0d02e92:	d102      	bne.n	c0d02e9a <bagl_ui_idle_nanos_button+0xe>


/** if the user wants to exit go back to the app dashboard. */
static const bagl_element_t *io_seproxyhal_touch_exit(const bagl_element_t *e) {
    // Go back to the dashboard
    os_sched_exit(0);
c0d02e94:	2000      	movs	r0, #0
c0d02e96:	f7ff f943 	bl	c0d02120 <os_sched_exit>
        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            io_seproxyhal_touch_exit(NULL);
            break;
    }

    return 0;
c0d02e9a:	2000      	movs	r0, #0
c0d02e9c:	bd80      	pop	{r7, pc}
c0d02e9e:	46c0      	nop			; (mov r8, r8)
c0d02ea0:	80000001 	.word	0x80000001

c0d02ea4 <ui_test>:
    ux_flow_init(0, ux_idle_flow, NULL);
#endif // #if TARGET_ID
}

/**ui 显示. */
void ui_test(void) {
c0d02ea4:	b5b0      	push	{r4, r5, r7, lr}

#if defined(TARGET_BLUE)
        UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
#elif defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_test_nanos, NULL);
c0d02ea6:	4c21      	ldr	r4, [pc, #132]	; (c0d02f2c <ui_test+0x88>)
c0d02ea8:	4822      	ldr	r0, [pc, #136]	; (c0d02f34 <ui_test+0x90>)
c0d02eaa:	4478      	add	r0, pc
c0d02eac:	6020      	str	r0, [r4, #0]
c0d02eae:	2004      	movs	r0, #4
c0d02eb0:	6060      	str	r0, [r4, #4]
c0d02eb2:	4821      	ldr	r0, [pc, #132]	; (c0d02f38 <ui_test+0x94>)
c0d02eb4:	4478      	add	r0, pc
c0d02eb6:	6120      	str	r0, [r4, #16]
c0d02eb8:	2500      	movs	r5, #0
c0d02eba:	60e5      	str	r5, [r4, #12]
c0d02ebc:	2003      	movs	r0, #3
c0d02ebe:	7620      	strb	r0, [r4, #24]
c0d02ec0:	61e5      	str	r5, [r4, #28]
c0d02ec2:	4620      	mov	r0, r4
c0d02ec4:	3018      	adds	r0, #24
c0d02ec6:	f7ff f941 	bl	c0d0214c <os_ux>
c0d02eca:	61e0      	str	r0, [r4, #28]
c0d02ecc:	f7fe fc37 	bl	c0d0173e <ux_check_status_default>
c0d02ed0:	f7fe f902 	bl	c0d010d8 <io_seproxyhal_init_ux>
c0d02ed4:	f7fe f906 	bl	c0d010e4 <io_seproxyhal_init_button>
c0d02ed8:	60a5      	str	r5, [r4, #8]
c0d02eda:	6820      	ldr	r0, [r4, #0]
c0d02edc:	2800      	cmp	r0, #0
c0d02ede:	d024      	beq.n	c0d02f2a <ui_test+0x86>
c0d02ee0:	69e0      	ldr	r0, [r4, #28]
c0d02ee2:	4913      	ldr	r1, [pc, #76]	; (c0d02f30 <ui_test+0x8c>)
c0d02ee4:	4288      	cmp	r0, r1
c0d02ee6:	d11e      	bne.n	c0d02f26 <ui_test+0x82>
c0d02ee8:	e01f      	b.n	c0d02f2a <ui_test+0x86>
c0d02eea:	6860      	ldr	r0, [r4, #4]
c0d02eec:	4285      	cmp	r5, r0
c0d02eee:	d21c      	bcs.n	c0d02f2a <ui_test+0x86>
c0d02ef0:	f7ff f986 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d02ef4:	2800      	cmp	r0, #0
c0d02ef6:	d118      	bne.n	c0d02f2a <ui_test+0x86>
c0d02ef8:	68a0      	ldr	r0, [r4, #8]
c0d02efa:	68e1      	ldr	r1, [r4, #12]
c0d02efc:	2538      	movs	r5, #56	; 0x38
c0d02efe:	4368      	muls	r0, r5
c0d02f00:	6822      	ldr	r2, [r4, #0]
c0d02f02:	1810      	adds	r0, r2, r0
c0d02f04:	2900      	cmp	r1, #0
c0d02f06:	d002      	beq.n	c0d02f0e <ui_test+0x6a>
c0d02f08:	4788      	blx	r1
c0d02f0a:	2800      	cmp	r0, #0
c0d02f0c:	d007      	beq.n	c0d02f1e <ui_test+0x7a>
c0d02f0e:	2801      	cmp	r0, #1
c0d02f10:	d103      	bne.n	c0d02f1a <ui_test+0x76>
c0d02f12:	68a0      	ldr	r0, [r4, #8]
c0d02f14:	4345      	muls	r5, r0
c0d02f16:	6820      	ldr	r0, [r4, #0]
c0d02f18:	1940      	adds	r0, r0, r5
c0d02f1a:	f7fd f8fd 	bl	c0d00118 <io_seproxyhal_display>
c0d02f1e:	68a0      	ldr	r0, [r4, #8]
c0d02f20:	1c45      	adds	r5, r0, #1
c0d02f22:	60a5      	str	r5, [r4, #8]
c0d02f24:	6820      	ldr	r0, [r4, #0]
c0d02f26:	2800      	cmp	r0, #0
c0d02f28:	d1df      	bne.n	c0d02eea <ui_test+0x46>
    if(G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_confirm_single_flow, NULL);
#endif // #if TARGET_ID
}
c0d02f2a:	bdb0      	pop	{r4, r5, r7, pc}
c0d02f2c:	20001b88 	.word	0x20001b88
c0d02f30:	b0105044 	.word	0xb0105044
c0d02f34:	0000158e 	.word	0x0000158e
c0d02f38:	00000085 	.word	0x00000085

c0d02f3c <bagl_ui_test_nanos_button>:
    ui_idle();
    return 0; // do not redraw the widget
}


static unsigned int bagl_ui_test_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d02f3c:	b580      	push	{r7, lr}
    switch (button_mask) {
c0d02f3e:	4910      	ldr	r1, [pc, #64]	; (c0d02f80 <bagl_ui_test_nanos_button+0x44>)
c0d02f40:	4288      	cmp	r0, r1
c0d02f42:	d010      	beq.n	c0d02f66 <bagl_ui_test_nanos_button+0x2a>
c0d02f44:	490f      	ldr	r1, [pc, #60]	; (c0d02f84 <bagl_ui_test_nanos_button+0x48>)
c0d02f46:	4288      	cmp	r0, r1
c0d02f48:	d118      	bne.n	c0d02f7c <bagl_ui_test_nanos_button+0x40>
    ui_idle();
    return 0; // do not redraw the widget
}

unsigned int test_touch_ok(const bagl_element_t *e) {
    G_io_apdu_buffer[0] = 0x69;
c0d02f4a:	480f      	ldr	r0, [pc, #60]	; (c0d02f88 <bagl_ui_test_nanos_button+0x4c>)
c0d02f4c:	2169      	movs	r1, #105	; 0x69
c0d02f4e:	7001      	strb	r1, [r0, #0]
    G_io_apdu_buffer[1] = 0x98;
c0d02f50:	216f      	movs	r1, #111	; 0x6f
c0d02f52:	43c9      	mvns	r1, r1
c0d02f54:	3108      	adds	r1, #8
c0d02f56:	7041      	strb	r1, [r0, #1]
c0d02f58:	2190      	movs	r1, #144	; 0x90
    G_io_apdu_buffer[2] = 0x90;
c0d02f5a:	7081      	strb	r1, [r0, #2]
    G_io_apdu_buffer[3] = 0x00;
c0d02f5c:	2100      	movs	r1, #0
c0d02f5e:	70c1      	strb	r1, [r0, #3]
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 4);
c0d02f60:	2020      	movs	r0, #32
c0d02f62:	2104      	movs	r1, #4
c0d02f64:	e006      	b.n	c0d02f74 <bagl_ui_test_nanos_button+0x38>
  //{{BAGL_ICON                           , 0x01,  31,   9,  14,  14, 0, 0, 0        , 0xFFFFFF, 0x000000, 0, BAGL_GLYPH_ICON_EYE_BADGE  }, NULL, 0, 0, 0, NULL, NULL, NULL },
  {{BAGL_LABELINE                       , 0x01,   0,  12, 128,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, "Are you sure?", 0, 0, 0, NULL, NULL, NULL },
 };

unsigned int test_touch_cancle(const bagl_element_t *e) {
    G_io_apdu_buffer[0] = 0x69;
c0d02f66:	4808      	ldr	r0, [pc, #32]	; (c0d02f88 <bagl_ui_test_nanos_button+0x4c>)
c0d02f68:	2169      	movs	r1, #105	; 0x69
c0d02f6a:	7001      	strb	r1, [r0, #0]
    G_io_apdu_buffer[1] = 0x01;
c0d02f6c:	2101      	movs	r1, #1
c0d02f6e:	7041      	strb	r1, [r0, #1]
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
c0d02f70:	2020      	movs	r0, #32
c0d02f72:	2102      	movs	r1, #2
c0d02f74:	f7fe faa4 	bl	c0d014c0 <io_exchange>
c0d02f78:	f7ff fe76 	bl	c0d02c68 <ui_idle>

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            test_touch_cancle(NULL);
            break;
    }
    return 0;
c0d02f7c:	2000      	movs	r0, #0
c0d02f7e:	bd80      	pop	{r7, pc}
c0d02f80:	80000001 	.word	0x80000001
c0d02f84:	80000002 	.word	0x80000002
c0d02f88:	200018f8 	.word	0x200018f8

c0d02f8c <ui_confirm_sign>:
    ux_flow_init(0, ux_confirm_single_flow, NULL);
#endif // #if TARGET_ID
}

/**ui 显示. */
void ui_confirm_sign(void) {
c0d02f8c:	b5b0      	push	{r4, r5, r7, lr}
#if defined(TARGET_BLUE)
        UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
#elif defined(TARGET_NANOS)
        UX_DISPLAY(bagl_ui_sign_hash_nanos, NULL);
c0d02f8e:	4c21      	ldr	r4, [pc, #132]	; (c0d03014 <ui_confirm_sign+0x88>)
c0d02f90:	4822      	ldr	r0, [pc, #136]	; (c0d0301c <ui_confirm_sign+0x90>)
c0d02f92:	4478      	add	r0, pc
c0d02f94:	6020      	str	r0, [r4, #0]
c0d02f96:	2005      	movs	r0, #5
c0d02f98:	6060      	str	r0, [r4, #4]
c0d02f9a:	4821      	ldr	r0, [pc, #132]	; (c0d03020 <ui_confirm_sign+0x94>)
c0d02f9c:	4478      	add	r0, pc
c0d02f9e:	6120      	str	r0, [r4, #16]
c0d02fa0:	2500      	movs	r5, #0
c0d02fa2:	60e5      	str	r5, [r4, #12]
c0d02fa4:	2003      	movs	r0, #3
c0d02fa6:	7620      	strb	r0, [r4, #24]
c0d02fa8:	61e5      	str	r5, [r4, #28]
c0d02faa:	4620      	mov	r0, r4
c0d02fac:	3018      	adds	r0, #24
c0d02fae:	f7ff f8cd 	bl	c0d0214c <os_ux>
c0d02fb2:	61e0      	str	r0, [r4, #28]
c0d02fb4:	f7fe fbc3 	bl	c0d0173e <ux_check_status_default>
c0d02fb8:	f7fe f88e 	bl	c0d010d8 <io_seproxyhal_init_ux>
c0d02fbc:	f7fe f892 	bl	c0d010e4 <io_seproxyhal_init_button>
c0d02fc0:	60a5      	str	r5, [r4, #8]
c0d02fc2:	6820      	ldr	r0, [r4, #0]
c0d02fc4:	2800      	cmp	r0, #0
c0d02fc6:	d024      	beq.n	c0d03012 <ui_confirm_sign+0x86>
c0d02fc8:	69e0      	ldr	r0, [r4, #28]
c0d02fca:	4913      	ldr	r1, [pc, #76]	; (c0d03018 <ui_confirm_sign+0x8c>)
c0d02fcc:	4288      	cmp	r0, r1
c0d02fce:	d11e      	bne.n	c0d0300e <ui_confirm_sign+0x82>
c0d02fd0:	e01f      	b.n	c0d03012 <ui_confirm_sign+0x86>
c0d02fd2:	6860      	ldr	r0, [r4, #4]
c0d02fd4:	4285      	cmp	r5, r0
c0d02fd6:	d21c      	bcs.n	c0d03012 <ui_confirm_sign+0x86>
c0d02fd8:	f7ff f912 	bl	c0d02200 <io_seproxyhal_spi_is_status_sent>
c0d02fdc:	2800      	cmp	r0, #0
c0d02fde:	d118      	bne.n	c0d03012 <ui_confirm_sign+0x86>
c0d02fe0:	68a0      	ldr	r0, [r4, #8]
c0d02fe2:	68e1      	ldr	r1, [r4, #12]
c0d02fe4:	2538      	movs	r5, #56	; 0x38
c0d02fe6:	4368      	muls	r0, r5
c0d02fe8:	6822      	ldr	r2, [r4, #0]
c0d02fea:	1810      	adds	r0, r2, r0
c0d02fec:	2900      	cmp	r1, #0
c0d02fee:	d002      	beq.n	c0d02ff6 <ui_confirm_sign+0x6a>
c0d02ff0:	4788      	blx	r1
c0d02ff2:	2800      	cmp	r0, #0
c0d02ff4:	d007      	beq.n	c0d03006 <ui_confirm_sign+0x7a>
c0d02ff6:	2801      	cmp	r0, #1
c0d02ff8:	d103      	bne.n	c0d03002 <ui_confirm_sign+0x76>
c0d02ffa:	68a0      	ldr	r0, [r4, #8]
c0d02ffc:	4345      	muls	r5, r0
c0d02ffe:	6820      	ldr	r0, [r4, #0]
c0d03000:	1940      	adds	r0, r0, r5
c0d03002:	f7fd f889 	bl	c0d00118 <io_seproxyhal_display>
c0d03006:	68a0      	ldr	r0, [r4, #8]
c0d03008:	1c45      	adds	r5, r0, #1
c0d0300a:	60a5      	str	r5, [r4, #8]
c0d0300c:	6820      	ldr	r0, [r4, #0]
c0d0300e:	2800      	cmp	r0, #0
c0d03010:	d1df      	bne.n	c0d02fd2 <ui_confirm_sign+0x46>
    if(G_ux.stack_count == 0) {
        ux_stack_push();
    }
    ux_flow_init(0, ux_confirm_single_flow, NULL);
#endif // #if TARGET_ID
}
c0d03012:	bdb0      	pop	{r4, r5, r7, pc}
c0d03014:	20001b88 	.word	0x20001b88
c0d03018:	b0105044 	.word	0xb0105044
c0d0301c:	00001666 	.word	0x00001666
c0d03020:	00000085 	.word	0x00000085

c0d03024 <bagl_ui_sign_hash_nanos_button>:
    sign_hash[5] = '*';
    sign_hash[6] = '*';
    hex_to_str(hash+30, sign_hash+7, 2);
}

static unsigned int bagl_ui_sign_hash_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d03024:	b580      	push	{r7, lr}
    switch (button_mask) {
c0d03026:	490b      	ldr	r1, [pc, #44]	; (c0d03054 <bagl_ui_sign_hash_nanos_button+0x30>)
c0d03028:	4288      	cmp	r0, r1
c0d0302a:	d005      	beq.n	c0d03038 <bagl_ui_sign_hash_nanos_button+0x14>
c0d0302c:	490a      	ldr	r1, [pc, #40]	; (c0d03058 <bagl_ui_sign_hash_nanos_button+0x34>)
c0d0302e:	4288      	cmp	r0, r1
c0d03030:	d10d      	bne.n	c0d0304e <bagl_ui_sign_hash_nanos_button+0x2a>
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            sign_touch_ok(NULL);
c0d03032:	f7ff fe6b 	bl	c0d02d0c <sign_touch_ok>
c0d03036:	e00a      	b.n	c0d0304e <bagl_ui_sign_hash_nanos_button+0x2a>

/* */
};

unsigned int sign_touch_cancle(const bagl_element_t *e) {
    G_io_apdu_buffer[0] = 0x69;
c0d03038:	4808      	ldr	r0, [pc, #32]	; (c0d0305c <bagl_ui_sign_hash_nanos_button+0x38>)
c0d0303a:	2169      	movs	r1, #105	; 0x69
c0d0303c:	7001      	strb	r1, [r0, #0]
    G_io_apdu_buffer[1] = 0x01;
c0d0303e:	2101      	movs	r1, #1
c0d03040:	7041      	strb	r1, [r0, #1]
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
c0d03042:	2020      	movs	r0, #32
c0d03044:	2102      	movs	r1, #2
c0d03046:	f7fe fa3b 	bl	c0d014c0 <io_exchange>
    // Display back the original UX
    ui_idle();
c0d0304a:	f7ff fe0d 	bl	c0d02c68 <ui_idle>

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            sign_touch_cancle(NULL);
            break;
    }
    return 0;
c0d0304e:	2000      	movs	r0, #0
c0d03050:	bd80      	pop	{r7, pc}
c0d03052:	46c0      	nop			; (mov r8, r8)
c0d03054:	80000001 	.word	0x80000001
c0d03058:	80000002 	.word	0x80000002
c0d0305c:	200018f8 	.word	0x200018f8

c0d03060 <get_apdu_buffer_length>:
#endif // #if TARGET_ID
}

/** returns the length of the transaction in the buffer. */
unsigned int get_apdu_buffer_length() {
    unsigned int len0 = G_io_apdu_buffer[APDU_BODY_LENGTH_OFFSET];
c0d03060:	4801      	ldr	r0, [pc, #4]	; (c0d03068 <get_apdu_buffer_length+0x8>)
c0d03062:	7900      	ldrb	r0, [r0, #4]
    return len0;
c0d03064:	4770      	bx	lr
c0d03066:	46c0      	nop			; (mov r8, r8)
c0d03068:	200018f8 	.word	0x200018f8

c0d0306c <ui_set_menu_bar_colour>:
void ui_set_menu_bar_colour(void) {
#if defined(TARGET_BLUE)
    UX_SET_STATUS_BAR_COLOR(COLOUR_WHITE, COLOUR_ONT_GREEN);
    clear_tx_desc();
#endif // #if TARGET_ID
}
c0d0306c:	4770      	bx	lr
	...

c0d03070 <USBD_LL_Init>:
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Init (USBD_HandleTypeDef *pdev)
{ 
  UNUSED(pdev);
  ep_in_stall = 0;
c0d03070:	4902      	ldr	r1, [pc, #8]	; (c0d0307c <USBD_LL_Init+0xc>)
c0d03072:	2000      	movs	r0, #0
c0d03074:	6008      	str	r0, [r1, #0]
  ep_out_stall = 0;
c0d03076:	4902      	ldr	r1, [pc, #8]	; (c0d03080 <USBD_LL_Init+0x10>)
c0d03078:	6008      	str	r0, [r1, #0]
  return USBD_OK;
c0d0307a:	4770      	bx	lr
c0d0307c:	20001c84 	.word	0x20001c84
c0d03080:	20001c88 	.word	0x20001c88

c0d03084 <USBD_LL_DeInit>:
  * @brief  De-Initializes the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_DeInit (USBD_HandleTypeDef *pdev)
{
c0d03084:	b510      	push	{r4, lr}
  UNUSED(pdev);
  // usb off
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03086:	4807      	ldr	r0, [pc, #28]	; (c0d030a4 <USBD_LL_DeInit+0x20>)
c0d03088:	214f      	movs	r1, #79	; 0x4f
c0d0308a:	7001      	strb	r1, [r0, #0]
c0d0308c:	2400      	movs	r4, #0
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d0308e:	7044      	strb	r4, [r0, #1]
c0d03090:	2101      	movs	r1, #1
  G_io_seproxyhal_spi_buffer[2] = 1;
c0d03092:	7081      	strb	r1, [r0, #2]
c0d03094:	2102      	movs	r1, #2
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d03096:	70c1      	strb	r1, [r0, #3]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 4);
c0d03098:	2104      	movs	r1, #4
c0d0309a:	f7ff f89b 	bl	c0d021d4 <io_seproxyhal_spi_send>

  return USBD_OK; 
c0d0309e:	4620      	mov	r0, r4
c0d030a0:	bd10      	pop	{r4, pc}
c0d030a2:	46c0      	nop			; (mov r8, r8)
c0d030a4:	20001800 	.word	0x20001800

c0d030a8 <USBD_LL_Start>:
  * @brief  Starts the Low Level portion of the Device driver. 
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Start(USBD_HandleTypeDef *pdev)
{
c0d030a8:	b570      	push	{r4, r5, r6, lr}
c0d030aa:	b082      	sub	sp, #8
c0d030ac:	466d      	mov	r5, sp
  uint8_t buffer[5];
  UNUSED(pdev);

  // reset address
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d030ae:	264f      	movs	r6, #79	; 0x4f
c0d030b0:	702e      	strb	r6, [r5, #0]
c0d030b2:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d030b4:	706c      	strb	r4, [r5, #1]
c0d030b6:	2002      	movs	r0, #2
  buffer[2] = 2;
c0d030b8:	70a8      	strb	r0, [r5, #2]
c0d030ba:	2003      	movs	r0, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d030bc:	70e8      	strb	r0, [r5, #3]
  buffer[4] = 0;
c0d030be:	712c      	strb	r4, [r5, #4]
  io_seproxyhal_spi_send(buffer, 5);
c0d030c0:	2105      	movs	r1, #5
c0d030c2:	4628      	mov	r0, r5
c0d030c4:	f7ff f886 	bl	c0d021d4 <io_seproxyhal_spi_send>
  
  // start usb operation
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d030c8:	702e      	strb	r6, [r5, #0]
  buffer[1] = 0;
c0d030ca:	706c      	strb	r4, [r5, #1]
c0d030cc:	2001      	movs	r0, #1
  buffer[2] = 1;
c0d030ce:	70a8      	strb	r0, [r5, #2]
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_CONNECT;
c0d030d0:	70e8      	strb	r0, [r5, #3]
c0d030d2:	2104      	movs	r1, #4
  io_seproxyhal_spi_send(buffer, 4);
c0d030d4:	4628      	mov	r0, r5
c0d030d6:	f7ff f87d 	bl	c0d021d4 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d030da:	4620      	mov	r0, r4
c0d030dc:	b002      	add	sp, #8
c0d030de:	bd70      	pop	{r4, r5, r6, pc}

c0d030e0 <USBD_LL_Stop>:
  * @brief  Stops the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Stop (USBD_HandleTypeDef *pdev)
{
c0d030e0:	b510      	push	{r4, lr}
c0d030e2:	b082      	sub	sp, #8
c0d030e4:	a801      	add	r0, sp, #4
  UNUSED(pdev);
  uint8_t buffer[4];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d030e6:	214f      	movs	r1, #79	; 0x4f
c0d030e8:	7001      	strb	r1, [r0, #0]
c0d030ea:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d030ec:	7044      	strb	r4, [r0, #1]
c0d030ee:	2101      	movs	r1, #1
  buffer[2] = 1;
c0d030f0:	7081      	strb	r1, [r0, #2]
c0d030f2:	2102      	movs	r1, #2
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d030f4:	70c1      	strb	r1, [r0, #3]
  io_seproxyhal_spi_send(buffer, 4);
c0d030f6:	2104      	movs	r1, #4
c0d030f8:	f7ff f86c 	bl	c0d021d4 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d030fc:	4620      	mov	r0, r4
c0d030fe:	b002      	add	sp, #8
c0d03100:	bd10      	pop	{r4, pc}
	...

c0d03104 <USBD_LL_OpenEP>:
  */
USBD_StatusTypeDef  USBD_LL_OpenEP  (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  ep_type,
                                      uint16_t ep_mps)
{
c0d03104:	b5b0      	push	{r4, r5, r7, lr}
c0d03106:	b082      	sub	sp, #8
  uint8_t buffer[8];
  UNUSED(pdev);

  ep_in_stall = 0;
c0d03108:	480e      	ldr	r0, [pc, #56]	; (c0d03144 <USBD_LL_OpenEP+0x40>)
c0d0310a:	2400      	movs	r4, #0
c0d0310c:	6004      	str	r4, [r0, #0]
  ep_out_stall = 0;
c0d0310e:	480e      	ldr	r0, [pc, #56]	; (c0d03148 <USBD_LL_OpenEP+0x44>)
c0d03110:	6004      	str	r4, [r0, #0]
c0d03112:	4668      	mov	r0, sp

  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03114:	254f      	movs	r5, #79	; 0x4f
c0d03116:	7005      	strb	r5, [r0, #0]
  buffer[1] = 0;
c0d03118:	7044      	strb	r4, [r0, #1]
c0d0311a:	2505      	movs	r5, #5
  buffer[2] = 5;
c0d0311c:	7085      	strb	r5, [r0, #2]
c0d0311e:	2504      	movs	r5, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d03120:	70c5      	strb	r5, [r0, #3]
c0d03122:	2501      	movs	r5, #1
  buffer[4] = 1;
c0d03124:	7105      	strb	r5, [r0, #4]
  buffer[5] = ep_addr;
c0d03126:	7141      	strb	r1, [r0, #5]
  buffer[6] = 0;
  switch(ep_type) {
c0d03128:	2a03      	cmp	r2, #3
c0d0312a:	d802      	bhi.n	c0d03132 <USBD_LL_OpenEP+0x2e>
c0d0312c:	00d0      	lsls	r0, r2, #3
c0d0312e:	4c07      	ldr	r4, [pc, #28]	; (c0d0314c <USBD_LL_OpenEP+0x48>)
c0d03130:	40c4      	lsrs	r4, r0
c0d03132:	4668      	mov	r0, sp
  buffer[1] = 0;
  buffer[2] = 5;
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
  buffer[4] = 1;
  buffer[5] = ep_addr;
  buffer[6] = 0;
c0d03134:	7184      	strb	r4, [r0, #6]
      break;
    case USBD_EP_TYPE_INTR:
      buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_INTERRUPT;
      break;
  }
  buffer[7] = ep_mps;
c0d03136:	71c3      	strb	r3, [r0, #7]
  io_seproxyhal_spi_send(buffer, 8);
c0d03138:	2108      	movs	r1, #8
c0d0313a:	f7ff f84b 	bl	c0d021d4 <io_seproxyhal_spi_send>
c0d0313e:	2000      	movs	r0, #0
  return USBD_OK; 
c0d03140:	b002      	add	sp, #8
c0d03142:	bdb0      	pop	{r4, r5, r7, pc}
c0d03144:	20001c84 	.word	0x20001c84
c0d03148:	20001c88 	.word	0x20001c88
c0d0314c:	02030401 	.word	0x02030401

c0d03150 <USBD_LL_CloseEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_CloseEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d03150:	b510      	push	{r4, lr}
c0d03152:	b082      	sub	sp, #8
c0d03154:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[8];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03156:	224f      	movs	r2, #79	; 0x4f
c0d03158:	7002      	strb	r2, [r0, #0]
c0d0315a:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d0315c:	7044      	strb	r4, [r0, #1]
c0d0315e:	2205      	movs	r2, #5
  buffer[2] = 5;
c0d03160:	7082      	strb	r2, [r0, #2]
c0d03162:	2204      	movs	r2, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d03164:	70c2      	strb	r2, [r0, #3]
c0d03166:	2201      	movs	r2, #1
  buffer[4] = 1;
c0d03168:	7102      	strb	r2, [r0, #4]
  buffer[5] = ep_addr;
c0d0316a:	7141      	strb	r1, [r0, #5]
  buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_DISABLED;
c0d0316c:	7184      	strb	r4, [r0, #6]
  buffer[7] = 0;
c0d0316e:	71c4      	strb	r4, [r0, #7]
  io_seproxyhal_spi_send(buffer, 8);
c0d03170:	2108      	movs	r1, #8
c0d03172:	f7ff f82f 	bl	c0d021d4 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d03176:	4620      	mov	r0, r4
c0d03178:	b002      	add	sp, #8
c0d0317a:	bd10      	pop	{r4, pc}

c0d0317c <USBD_LL_StallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_StallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{ 
c0d0317c:	b5b0      	push	{r4, r5, r7, lr}
c0d0317e:	b082      	sub	sp, #8
c0d03180:	460d      	mov	r5, r1
c0d03182:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d03184:	2150      	movs	r1, #80	; 0x50
c0d03186:	7001      	strb	r1, [r0, #0]
c0d03188:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d0318a:	7044      	strb	r4, [r0, #1]
c0d0318c:	2103      	movs	r1, #3
  buffer[2] = 3;
c0d0318e:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d03190:	70c5      	strb	r5, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_STALL;
c0d03192:	2140      	movs	r1, #64	; 0x40
c0d03194:	7101      	strb	r1, [r0, #4]
  buffer[5] = 0;
c0d03196:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03198:	2106      	movs	r1, #6
c0d0319a:	f7ff f81b 	bl	c0d021d4 <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d0319e:	2080      	movs	r0, #128	; 0x80
c0d031a0:	4205      	tst	r5, r0
c0d031a2:	d101      	bne.n	c0d031a8 <USBD_LL_StallEP+0x2c>
c0d031a4:	4807      	ldr	r0, [pc, #28]	; (c0d031c4 <USBD_LL_StallEP+0x48>)
c0d031a6:	e000      	b.n	c0d031aa <USBD_LL_StallEP+0x2e>
c0d031a8:	4805      	ldr	r0, [pc, #20]	; (c0d031c0 <USBD_LL_StallEP+0x44>)
c0d031aa:	6801      	ldr	r1, [r0, #0]
c0d031ac:	227f      	movs	r2, #127	; 0x7f
c0d031ae:	4015      	ands	r5, r2
c0d031b0:	2201      	movs	r2, #1
c0d031b2:	40aa      	lsls	r2, r5
c0d031b4:	430a      	orrs	r2, r1
c0d031b6:	6002      	str	r2, [r0, #0]
    ep_in_stall |= (1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall |= (1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d031b8:	4620      	mov	r0, r4
c0d031ba:	b002      	add	sp, #8
c0d031bc:	bdb0      	pop	{r4, r5, r7, pc}
c0d031be:	46c0      	nop			; (mov r8, r8)
c0d031c0:	20001c84 	.word	0x20001c84
c0d031c4:	20001c88 	.word	0x20001c88

c0d031c8 <USBD_LL_ClearStallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_ClearStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d031c8:	b570      	push	{r4, r5, r6, lr}
c0d031ca:	b082      	sub	sp, #8
c0d031cc:	460d      	mov	r5, r1
c0d031ce:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d031d0:	2150      	movs	r1, #80	; 0x50
c0d031d2:	7001      	strb	r1, [r0, #0]
c0d031d4:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d031d6:	7044      	strb	r4, [r0, #1]
c0d031d8:	2103      	movs	r1, #3
  buffer[2] = 3;
c0d031da:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d031dc:	70c5      	strb	r5, [r0, #3]
c0d031de:	2680      	movs	r6, #128	; 0x80
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_UNSTALL;
c0d031e0:	7106      	strb	r6, [r0, #4]
  buffer[5] = 0;
c0d031e2:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d031e4:	2106      	movs	r1, #6
c0d031e6:	f7fe fff5 	bl	c0d021d4 <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d031ea:	4235      	tst	r5, r6
c0d031ec:	d101      	bne.n	c0d031f2 <USBD_LL_ClearStallEP+0x2a>
c0d031ee:	4807      	ldr	r0, [pc, #28]	; (c0d0320c <USBD_LL_ClearStallEP+0x44>)
c0d031f0:	e000      	b.n	c0d031f4 <USBD_LL_ClearStallEP+0x2c>
c0d031f2:	4805      	ldr	r0, [pc, #20]	; (c0d03208 <USBD_LL_ClearStallEP+0x40>)
c0d031f4:	6801      	ldr	r1, [r0, #0]
c0d031f6:	227f      	movs	r2, #127	; 0x7f
c0d031f8:	4015      	ands	r5, r2
c0d031fa:	2201      	movs	r2, #1
c0d031fc:	40aa      	lsls	r2, r5
c0d031fe:	4391      	bics	r1, r2
c0d03200:	6001      	str	r1, [r0, #0]
    ep_in_stall &= ~(1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall &= ~(1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d03202:	4620      	mov	r0, r4
c0d03204:	b002      	add	sp, #8
c0d03206:	bd70      	pop	{r4, r5, r6, pc}
c0d03208:	20001c84 	.word	0x20001c84
c0d0320c:	20001c88 	.word	0x20001c88

c0d03210 <USBD_LL_IsStallEP>:
  * @retval Stall (1: Yes, 0: No)
  */
uint8_t USBD_LL_IsStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  UNUSED(pdev);
  if((ep_addr & 0x80) == 0x80)
c0d03210:	2080      	movs	r0, #128	; 0x80
c0d03212:	4201      	tst	r1, r0
c0d03214:	d001      	beq.n	c0d0321a <USBD_LL_IsStallEP+0xa>
c0d03216:	4806      	ldr	r0, [pc, #24]	; (c0d03230 <USBD_LL_IsStallEP+0x20>)
c0d03218:	e000      	b.n	c0d0321c <USBD_LL_IsStallEP+0xc>
c0d0321a:	4804      	ldr	r0, [pc, #16]	; (c0d0322c <USBD_LL_IsStallEP+0x1c>)
c0d0321c:	6800      	ldr	r0, [r0, #0]
c0d0321e:	227f      	movs	r2, #127	; 0x7f
c0d03220:	4011      	ands	r1, r2
c0d03222:	2201      	movs	r2, #1
c0d03224:	408a      	lsls	r2, r1
c0d03226:	4002      	ands	r2, r0
  }
  else
  {
    return ep_out_stall & (1<<(ep_addr&0x7F));
  }
}
c0d03228:	b2d0      	uxtb	r0, r2
c0d0322a:	4770      	bx	lr
c0d0322c:	20001c88 	.word	0x20001c88
c0d03230:	20001c84 	.word	0x20001c84

c0d03234 <USBD_LL_SetUSBAddress>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_SetUSBAddress (USBD_HandleTypeDef *pdev, uint8_t dev_addr)   
{
c0d03234:	b510      	push	{r4, lr}
c0d03236:	b082      	sub	sp, #8
c0d03238:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[5];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d0323a:	224f      	movs	r2, #79	; 0x4f
c0d0323c:	7002      	strb	r2, [r0, #0]
c0d0323e:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03240:	7044      	strb	r4, [r0, #1]
c0d03242:	2202      	movs	r2, #2
  buffer[2] = 2;
c0d03244:	7082      	strb	r2, [r0, #2]
c0d03246:	2203      	movs	r2, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d03248:	70c2      	strb	r2, [r0, #3]
  buffer[4] = dev_addr;
c0d0324a:	7101      	strb	r1, [r0, #4]
  io_seproxyhal_spi_send(buffer, 5);
c0d0324c:	2105      	movs	r1, #5
c0d0324e:	f7fe ffc1 	bl	c0d021d4 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d03252:	4620      	mov	r0, r4
c0d03254:	b002      	add	sp, #8
c0d03256:	bd10      	pop	{r4, pc}

c0d03258 <USBD_LL_Transmit>:
  */
USBD_StatusTypeDef  USBD_LL_Transmit (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  *pbuf,
                                      uint16_t  size)
{
c0d03258:	b5b0      	push	{r4, r5, r7, lr}
c0d0325a:	b082      	sub	sp, #8
c0d0325c:	461c      	mov	r4, r3
c0d0325e:	4615      	mov	r5, r2
c0d03260:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d03262:	2250      	movs	r2, #80	; 0x50
c0d03264:	7002      	strb	r2, [r0, #0]
  buffer[1] = (3+size)>>8;
c0d03266:	1ce2      	adds	r2, r4, #3
c0d03268:	0a13      	lsrs	r3, r2, #8
c0d0326a:	7043      	strb	r3, [r0, #1]
  buffer[2] = (3+size);
c0d0326c:	7082      	strb	r2, [r0, #2]
  buffer[3] = ep_addr;
c0d0326e:	70c1      	strb	r1, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d03270:	2120      	movs	r1, #32
c0d03272:	7101      	strb	r1, [r0, #4]
  buffer[5] = size;
c0d03274:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03276:	2106      	movs	r1, #6
c0d03278:	f7fe ffac 	bl	c0d021d4 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(pbuf, size);
c0d0327c:	4628      	mov	r0, r5
c0d0327e:	4621      	mov	r1, r4
c0d03280:	f7fe ffa8 	bl	c0d021d4 <io_seproxyhal_spi_send>
c0d03284:	2000      	movs	r0, #0
  return USBD_OK;   
c0d03286:	b002      	add	sp, #8
c0d03288:	bdb0      	pop	{r4, r5, r7, pc}

c0d0328a <USBD_LL_PrepareReceive>:
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_PrepareReceive(USBD_HandleTypeDef *pdev, 
                                           uint8_t  ep_addr,
                                           uint16_t  size)
{
c0d0328a:	b510      	push	{r4, lr}
c0d0328c:	b082      	sub	sp, #8
c0d0328e:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d03290:	2350      	movs	r3, #80	; 0x50
c0d03292:	7003      	strb	r3, [r0, #0]
c0d03294:	2400      	movs	r4, #0
  buffer[1] = (3/*+size*/)>>8;
c0d03296:	7044      	strb	r4, [r0, #1]
c0d03298:	2303      	movs	r3, #3
  buffer[2] = (3/*+size*/);
c0d0329a:	7083      	strb	r3, [r0, #2]
  buffer[3] = ep_addr;
c0d0329c:	70c1      	strb	r1, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_OUT;
c0d0329e:	2130      	movs	r1, #48	; 0x30
c0d032a0:	7101      	strb	r1, [r0, #4]
  buffer[5] = size; // expected size, not transmitted here !
c0d032a2:	7142      	strb	r2, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d032a4:	2106      	movs	r1, #6
c0d032a6:	f7fe ff95 	bl	c0d021d4 <io_seproxyhal_spi_send>
  return USBD_OK;   
c0d032aa:	4620      	mov	r0, r4
c0d032ac:	b002      	add	sp, #8
c0d032ae:	bd10      	pop	{r4, pc}

c0d032b0 <USBD_Init>:
* @param  pdesc: Descriptor structure address
* @param  id: Low level core index
* @retval None
*/
USBD_StatusTypeDef USBD_Init(USBD_HandleTypeDef *pdev, USBD_DescriptorsTypeDef *pdesc, uint8_t id)
{
c0d032b0:	b570      	push	{r4, r5, r6, lr}
c0d032b2:	4615      	mov	r5, r2
c0d032b4:	460e      	mov	r6, r1
c0d032b6:	4604      	mov	r4, r0
c0d032b8:	2002      	movs	r0, #2
  /* Check whether the USB Host handle is valid */
  if(pdev == NULL)
c0d032ba:	2c00      	cmp	r4, #0
c0d032bc:	d011      	beq.n	c0d032e2 <USBD_Init+0x32>
  {
    USBD_ErrLog("Invalid Device handle");
    return USBD_FAIL; 
  }

  memset(pdev, 0, sizeof(USBD_HandleTypeDef));
c0d032be:	204d      	movs	r0, #77	; 0x4d
c0d032c0:	0081      	lsls	r1, r0, #2
c0d032c2:	4620      	mov	r0, r4
c0d032c4:	f000 ff6c 	bl	c0d041a0 <__aeabi_memclr>
  
  /* Assign USBD Descriptors */
  if(pdesc != NULL)
c0d032c8:	2e00      	cmp	r6, #0
c0d032ca:	d002      	beq.n	c0d032d2 <USBD_Init+0x22>
  {
    pdev->pDesc = pdesc;
c0d032cc:	2011      	movs	r0, #17
c0d032ce:	0100      	lsls	r0, r0, #4
c0d032d0:	5026      	str	r6, [r4, r0]
  }
  
  /* Set Device initial State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d032d2:	20fc      	movs	r0, #252	; 0xfc
c0d032d4:	2101      	movs	r1, #1
c0d032d6:	5421      	strb	r1, [r4, r0]
  pdev->id = id;
c0d032d8:	7025      	strb	r5, [r4, #0]
  /* Initialize low level driver */
  USBD_LL_Init(pdev);
c0d032da:	4620      	mov	r0, r4
c0d032dc:	f7ff fec8 	bl	c0d03070 <USBD_LL_Init>
c0d032e0:	2000      	movs	r0, #0
  
  return USBD_OK; 
}
c0d032e2:	b2c0      	uxtb	r0, r0
c0d032e4:	bd70      	pop	{r4, r5, r6, pc}

c0d032e6 <USBD_DeInit>:
*         Re-Initialize th device library
* @param  pdev: device instance
* @retval status: status
*/
USBD_StatusTypeDef USBD_DeInit(USBD_HandleTypeDef *pdev)
{
c0d032e6:	b570      	push	{r4, r5, r6, lr}
c0d032e8:	4604      	mov	r4, r0
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d032ea:	20fc      	movs	r0, #252	; 0xfc
c0d032ec:	2101      	movs	r1, #1
c0d032ee:	5421      	strb	r1, [r4, r0]
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d032f0:	2045      	movs	r0, #69	; 0x45
c0d032f2:	0080      	lsls	r0, r0, #2
c0d032f4:	1825      	adds	r5, r4, r0
c0d032f6:	2600      	movs	r6, #0
    if(pdev->interfacesClass[intf].pClass != NULL) {
c0d032f8:	00f0      	lsls	r0, r6, #3
c0d032fa:	5828      	ldr	r0, [r5, r0]
c0d032fc:	2800      	cmp	r0, #0
c0d032fe:	d006      	beq.n	c0d0330e <USBD_DeInit+0x28>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
c0d03300:	6840      	ldr	r0, [r0, #4]
c0d03302:	f7fe fdd3 	bl	c0d01eac <pic>
c0d03306:	4602      	mov	r2, r0
c0d03308:	7921      	ldrb	r1, [r4, #4]
c0d0330a:	4620      	mov	r0, r4
c0d0330c:	4790      	blx	r2
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0330e:	1c76      	adds	r6, r6, #1
c0d03310:	2e03      	cmp	r6, #3
c0d03312:	d1f1      	bne.n	c0d032f8 <USBD_DeInit+0x12>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
    }
  }
  
    /* Stop the low level driver  */
  USBD_LL_Stop(pdev); 
c0d03314:	4620      	mov	r0, r4
c0d03316:	f7ff fee3 	bl	c0d030e0 <USBD_LL_Stop>
  
  /* Initialize low level driver */
  USBD_LL_DeInit(pdev);
c0d0331a:	4620      	mov	r0, r4
c0d0331c:	f7ff feb2 	bl	c0d03084 <USBD_LL_DeInit>
  
  return USBD_OK;
c0d03320:	2000      	movs	r0, #0
c0d03322:	bd70      	pop	{r4, r5, r6, pc}

c0d03324 <USBD_RegisterClassForInterface>:
  * @param  pDevice : Device Handle
  * @param  pclass: Class handle
  * @retval USBD Status
  */
USBD_StatusTypeDef USBD_RegisterClassForInterface(uint8_t interfaceidx, USBD_HandleTypeDef *pdev, USBD_ClassTypeDef *pclass)
{
c0d03324:	2302      	movs	r3, #2
  USBD_StatusTypeDef   status = USBD_OK;
  if(pclass != 0)
c0d03326:	2a00      	cmp	r2, #0
c0d03328:	d007      	beq.n	c0d0333a <USBD_RegisterClassForInterface+0x16>
c0d0332a:	2300      	movs	r3, #0
  {
    if (interfaceidx < USBD_MAX_NUM_INTERFACES) {
c0d0332c:	2802      	cmp	r0, #2
c0d0332e:	d804      	bhi.n	c0d0333a <USBD_RegisterClassForInterface+0x16>
      /* link the class to the USB Device handle */
      pdev->interfacesClass[interfaceidx].pClass = pclass;
c0d03330:	00c0      	lsls	r0, r0, #3
c0d03332:	1808      	adds	r0, r1, r0
c0d03334:	2145      	movs	r1, #69	; 0x45
c0d03336:	0089      	lsls	r1, r1, #2
c0d03338:	5042      	str	r2, [r0, r1]
  {
    USBD_ErrLog("Invalid Class handle");
    status = USBD_FAIL; 
  }
  
  return status;
c0d0333a:	b2d8      	uxtb	r0, r3
c0d0333c:	4770      	bx	lr

c0d0333e <USBD_Start>:
  *         Start the USB Device Core.
  * @param  pdev: Device Handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_Start  (USBD_HandleTypeDef *pdev)
{
c0d0333e:	b580      	push	{r7, lr}
  
  /* Start the low level driver  */
  USBD_LL_Start(pdev); 
c0d03340:	f7ff feb2 	bl	c0d030a8 <USBD_LL_Start>
  
  return USBD_OK;  
c0d03344:	2000      	movs	r0, #0
c0d03346:	bd80      	pop	{r7, pc}

c0d03348 <USBD_SetClassConfig>:
* @param  cfgidx: configuration index
* @retval status
*/

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d03348:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0334a:	b081      	sub	sp, #4
c0d0334c:	460c      	mov	r4, r1
c0d0334e:	4605      	mov	r5, r0
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03350:	2045      	movs	r0, #69	; 0x45
c0d03352:	0080      	lsls	r0, r0, #2
c0d03354:	182f      	adds	r7, r5, r0
c0d03356:	2600      	movs	r6, #0
    if(usbd_is_valid_intf(pdev, intf)) {
c0d03358:	4628      	mov	r0, r5
c0d0335a:	4631      	mov	r1, r6
c0d0335c:	f000 f97c 	bl	c0d03658 <usbd_is_valid_intf>
c0d03360:	2800      	cmp	r0, #0
c0d03362:	d008      	beq.n	c0d03376 <USBD_SetClassConfig+0x2e>
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
c0d03364:	00f0      	lsls	r0, r6, #3
c0d03366:	5838      	ldr	r0, [r7, r0]
c0d03368:	6800      	ldr	r0, [r0, #0]
c0d0336a:	f7fe fd9f 	bl	c0d01eac <pic>
c0d0336e:	4602      	mov	r2, r0
c0d03370:	4628      	mov	r0, r5
c0d03372:	4621      	mov	r1, r4
c0d03374:	4790      	blx	r2

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03376:	1c76      	adds	r6, r6, #1
c0d03378:	2e03      	cmp	r6, #3
c0d0337a:	d1ed      	bne.n	c0d03358 <USBD_SetClassConfig+0x10>
    if(usbd_is_valid_intf(pdev, intf)) {
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
    }
  }

  return USBD_OK; 
c0d0337c:	2000      	movs	r0, #0
c0d0337e:	b001      	add	sp, #4
c0d03380:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03382 <USBD_ClrClassConfig>:
* @param  pdev: device instance
* @param  cfgidx: configuration index
* @retval status: USBD_StatusTypeDef
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d03382:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03384:	b081      	sub	sp, #4
c0d03386:	460c      	mov	r4, r1
c0d03388:	4605      	mov	r5, r0
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0338a:	2045      	movs	r0, #69	; 0x45
c0d0338c:	0080      	lsls	r0, r0, #2
c0d0338e:	182f      	adds	r7, r5, r0
c0d03390:	2600      	movs	r6, #0
    if(usbd_is_valid_intf(pdev, intf)) {
c0d03392:	4628      	mov	r0, r5
c0d03394:	4631      	mov	r1, r6
c0d03396:	f000 f95f 	bl	c0d03658 <usbd_is_valid_intf>
c0d0339a:	2800      	cmp	r0, #0
c0d0339c:	d008      	beq.n	c0d033b0 <USBD_ClrClassConfig+0x2e>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
c0d0339e:	00f0      	lsls	r0, r6, #3
c0d033a0:	5838      	ldr	r0, [r7, r0]
c0d033a2:	6840      	ldr	r0, [r0, #4]
c0d033a4:	f7fe fd82 	bl	c0d01eac <pic>
c0d033a8:	4602      	mov	r2, r0
c0d033aa:	4628      	mov	r0, r5
c0d033ac:	4621      	mov	r1, r4
c0d033ae:	4790      	blx	r2
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d033b0:	1c76      	adds	r6, r6, #1
c0d033b2:	2e03      	cmp	r6, #3
c0d033b4:	d1ed      	bne.n	c0d03392 <USBD_ClrClassConfig+0x10>
    if(usbd_is_valid_intf(pdev, intf)) {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
    }
  }
  return USBD_OK;
c0d033b6:	2000      	movs	r0, #0
c0d033b8:	b001      	add	sp, #4
c0d033ba:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d033bc <USBD_LL_SetupStage>:
*         Handle the setup stage
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetupStage(USBD_HandleTypeDef *pdev, uint8_t *psetup)
{
c0d033bc:	b570      	push	{r4, r5, r6, lr}
c0d033be:	4604      	mov	r4, r0
c0d033c0:	2021      	movs	r0, #33	; 0x21
c0d033c2:	00c6      	lsls	r6, r0, #3
  USBD_ParseSetupRequest(&pdev->request, psetup);
c0d033c4:	19a5      	adds	r5, r4, r6
c0d033c6:	4628      	mov	r0, r5
c0d033c8:	f000 fb9d 	bl	c0d03b06 <USBD_ParseSetupRequest>
  
  pdev->ep0_state = USBD_EP0_SETUP;
c0d033cc:	20f4      	movs	r0, #244	; 0xf4
c0d033ce:	2101      	movs	r1, #1
c0d033d0:	5021      	str	r1, [r4, r0]
  pdev->ep0_data_len = pdev->request.wLength;
c0d033d2:	2087      	movs	r0, #135	; 0x87
c0d033d4:	0040      	lsls	r0, r0, #1
c0d033d6:	5a20      	ldrh	r0, [r4, r0]
c0d033d8:	21f8      	movs	r1, #248	; 0xf8
c0d033da:	5060      	str	r0, [r4, r1]
  
  switch (pdev->request.bmRequest & 0x1F) 
c0d033dc:	5da1      	ldrb	r1, [r4, r6]
c0d033de:	201f      	movs	r0, #31
c0d033e0:	4008      	ands	r0, r1
c0d033e2:	2802      	cmp	r0, #2
c0d033e4:	d008      	beq.n	c0d033f8 <USBD_LL_SetupStage+0x3c>
c0d033e6:	2801      	cmp	r0, #1
c0d033e8:	d00b      	beq.n	c0d03402 <USBD_LL_SetupStage+0x46>
c0d033ea:	2800      	cmp	r0, #0
c0d033ec:	d10e      	bne.n	c0d0340c <USBD_LL_SetupStage+0x50>
  {
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
c0d033ee:	4620      	mov	r0, r4
c0d033f0:	4629      	mov	r1, r5
c0d033f2:	f000 f93f 	bl	c0d03674 <USBD_StdDevReq>
c0d033f6:	e00e      	b.n	c0d03416 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
c0d033f8:	4620      	mov	r0, r4
c0d033fa:	4629      	mov	r1, r5
c0d033fc:	f000 faf8 	bl	c0d039f0 <USBD_StdEPReq>
c0d03400:	e009      	b.n	c0d03416 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
c0d03402:	4620      	mov	r0, r4
c0d03404:	4629      	mov	r1, r5
c0d03406:	f000 face 	bl	c0d039a6 <USBD_StdItfReq>
c0d0340a:	e004      	b.n	c0d03416 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
    break;
    
  default:           
    USBD_LL_StallEP(pdev , pdev->request.bmRequest & 0x80);
c0d0340c:	2080      	movs	r0, #128	; 0x80
c0d0340e:	4001      	ands	r1, r0
c0d03410:	4620      	mov	r0, r4
c0d03412:	f7ff feb3 	bl	c0d0317c <USBD_LL_StallEP>
    break;
  }  
  return USBD_OK;  
c0d03416:	2000      	movs	r0, #0
c0d03418:	bd70      	pop	{r4, r5, r6, pc}

c0d0341a <USBD_LL_DataOutStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataOutStage(USBD_HandleTypeDef *pdev , uint8_t epnum, uint8_t *pdata)
{
c0d0341a:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0341c:	b083      	sub	sp, #12
c0d0341e:	9202      	str	r2, [sp, #8]
c0d03420:	4604      	mov	r4, r0
c0d03422:	9101      	str	r1, [sp, #4]
  USBD_EndpointTypeDef    *pep;
  
  if(epnum == 0) 
c0d03424:	2900      	cmp	r1, #0
c0d03426:	d01e      	beq.n	c0d03466 <USBD_LL_DataOutStage+0x4c>
    }
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03428:	2045      	movs	r0, #69	; 0x45
c0d0342a:	0080      	lsls	r0, r0, #2
c0d0342c:	1825      	adds	r5, r4, r0
c0d0342e:	4626      	mov	r6, r4
c0d03430:	36fc      	adds	r6, #252	; 0xfc
c0d03432:	2700      	movs	r7, #0
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d03434:	4620      	mov	r0, r4
c0d03436:	4639      	mov	r1, r7
c0d03438:	f000 f90e 	bl	c0d03658 <usbd_is_valid_intf>
c0d0343c:	2800      	cmp	r0, #0
c0d0343e:	d00e      	beq.n	c0d0345e <USBD_LL_DataOutStage+0x44>
c0d03440:	00f8      	lsls	r0, r7, #3
c0d03442:	5828      	ldr	r0, [r5, r0]
c0d03444:	6980      	ldr	r0, [r0, #24]
c0d03446:	2800      	cmp	r0, #0
c0d03448:	d009      	beq.n	c0d0345e <USBD_LL_DataOutStage+0x44>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d0344a:	7831      	ldrb	r1, [r6, #0]
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d0344c:	2903      	cmp	r1, #3
c0d0344e:	d106      	bne.n	c0d0345e <USBD_LL_DataOutStage+0x44>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
c0d03450:	f7fe fd2c 	bl	c0d01eac <pic>
c0d03454:	4603      	mov	r3, r0
c0d03456:	4620      	mov	r0, r4
c0d03458:	9901      	ldr	r1, [sp, #4]
c0d0345a:	9a02      	ldr	r2, [sp, #8]
c0d0345c:	4798      	blx	r3
    }
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0345e:	1c7f      	adds	r7, r7, #1
c0d03460:	2f03      	cmp	r7, #3
c0d03462:	d1e7      	bne.n	c0d03434 <USBD_LL_DataOutStage+0x1a>
c0d03464:	e035      	b.n	c0d034d2 <USBD_LL_DataOutStage+0xb8>
  
  if(epnum == 0) 
  {
    pep = &pdev->ep_out[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_OUT)
c0d03466:	20f4      	movs	r0, #244	; 0xf4
c0d03468:	5820      	ldr	r0, [r4, r0]
c0d0346a:	2803      	cmp	r0, #3
c0d0346c:	d131      	bne.n	c0d034d2 <USBD_LL_DataOutStage+0xb8>
    {
      if(pep->rem_length > pep->maxpacket)
c0d0346e:	2090      	movs	r0, #144	; 0x90
c0d03470:	5820      	ldr	r0, [r4, r0]
c0d03472:	218c      	movs	r1, #140	; 0x8c
c0d03474:	5861      	ldr	r1, [r4, r1]
c0d03476:	4622      	mov	r2, r4
c0d03478:	328c      	adds	r2, #140	; 0x8c
c0d0347a:	4281      	cmp	r1, r0
c0d0347c:	d90a      	bls.n	c0d03494 <USBD_LL_DataOutStage+0x7a>
      {
        pep->rem_length -=  pep->maxpacket;
c0d0347e:	1a09      	subs	r1, r1, r0
c0d03480:	6011      	str	r1, [r2, #0]
c0d03482:	4281      	cmp	r1, r0
c0d03484:	d300      	bcc.n	c0d03488 <USBD_LL_DataOutStage+0x6e>
c0d03486:	4601      	mov	r1, r0
       
        USBD_CtlContinueRx (pdev, 
c0d03488:	b28a      	uxth	r2, r1
c0d0348a:	4620      	mov	r0, r4
c0d0348c:	9902      	ldr	r1, [sp, #8]
c0d0348e:	f000 fdbb 	bl	c0d04008 <USBD_CtlContinueRx>
c0d03492:	e01e      	b.n	c0d034d2 <USBD_LL_DataOutStage+0xb8>
                            MIN(pep->rem_length ,pep->maxpacket));
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03494:	2045      	movs	r0, #69	; 0x45
c0d03496:	0080      	lsls	r0, r0, #2
c0d03498:	1826      	adds	r6, r4, r0
c0d0349a:	4627      	mov	r7, r4
c0d0349c:	37fc      	adds	r7, #252	; 0xfc
c0d0349e:	2500      	movs	r5, #0
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d034a0:	4620      	mov	r0, r4
c0d034a2:	4629      	mov	r1, r5
c0d034a4:	f000 f8d8 	bl	c0d03658 <usbd_is_valid_intf>
c0d034a8:	2800      	cmp	r0, #0
c0d034aa:	d00c      	beq.n	c0d034c6 <USBD_LL_DataOutStage+0xac>
c0d034ac:	00e8      	lsls	r0, r5, #3
c0d034ae:	5830      	ldr	r0, [r6, r0]
c0d034b0:	6900      	ldr	r0, [r0, #16]
c0d034b2:	2800      	cmp	r0, #0
c0d034b4:	d007      	beq.n	c0d034c6 <USBD_LL_DataOutStage+0xac>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d034b6:	7839      	ldrb	r1, [r7, #0]
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d034b8:	2903      	cmp	r1, #3
c0d034ba:	d104      	bne.n	c0d034c6 <USBD_LL_DataOutStage+0xac>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
c0d034bc:	f7fe fcf6 	bl	c0d01eac <pic>
c0d034c0:	4601      	mov	r1, r0
c0d034c2:	4620      	mov	r0, r4
c0d034c4:	4788      	blx	r1
                            MIN(pep->rem_length ,pep->maxpacket));
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d034c6:	1c6d      	adds	r5, r5, #1
c0d034c8:	2d03      	cmp	r5, #3
c0d034ca:	d1e9      	bne.n	c0d034a0 <USBD_LL_DataOutStage+0x86>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
          }
        }
        USBD_CtlSendStatus(pdev);
c0d034cc:	4620      	mov	r0, r4
c0d034ce:	f000 fda2 	bl	c0d04016 <USBD_CtlSendStatus>
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
      }
    }
  }  
  return USBD_OK;
c0d034d2:	2000      	movs	r0, #0
c0d034d4:	b003      	add	sp, #12
c0d034d6:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d034d8 <USBD_LL_DataInStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataInStage(USBD_HandleTypeDef *pdev ,uint8_t epnum, uint8_t *pdata)
{
c0d034d8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d034da:	b081      	sub	sp, #4
c0d034dc:	4604      	mov	r4, r0
c0d034de:	9100      	str	r1, [sp, #0]
  USBD_EndpointTypeDef    *pep;
  UNUSED(pdata);
    
  if(epnum == 0) 
c0d034e0:	2900      	cmp	r1, #0
c0d034e2:	d01d      	beq.n	c0d03520 <USBD_LL_DataInStage+0x48>
      pdev->dev_test_mode = 0;
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d034e4:	2045      	movs	r0, #69	; 0x45
c0d034e6:	0080      	lsls	r0, r0, #2
c0d034e8:	1827      	adds	r7, r4, r0
c0d034ea:	4625      	mov	r5, r4
c0d034ec:	35fc      	adds	r5, #252	; 0xfc
c0d034ee:	2600      	movs	r6, #0
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d034f0:	4620      	mov	r0, r4
c0d034f2:	4631      	mov	r1, r6
c0d034f4:	f000 f8b0 	bl	c0d03658 <usbd_is_valid_intf>
c0d034f8:	2800      	cmp	r0, #0
c0d034fa:	d00d      	beq.n	c0d03518 <USBD_LL_DataInStage+0x40>
c0d034fc:	00f0      	lsls	r0, r6, #3
c0d034fe:	5838      	ldr	r0, [r7, r0]
c0d03500:	6940      	ldr	r0, [r0, #20]
c0d03502:	2800      	cmp	r0, #0
c0d03504:	d008      	beq.n	c0d03518 <USBD_LL_DataInStage+0x40>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d03506:	7829      	ldrb	r1, [r5, #0]
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d03508:	2903      	cmp	r1, #3
c0d0350a:	d105      	bne.n	c0d03518 <USBD_LL_DataInStage+0x40>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
c0d0350c:	f7fe fcce 	bl	c0d01eac <pic>
c0d03510:	4602      	mov	r2, r0
c0d03512:	4620      	mov	r0, r4
c0d03514:	9900      	ldr	r1, [sp, #0]
c0d03516:	4790      	blx	r2
      pdev->dev_test_mode = 0;
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03518:	1c76      	adds	r6, r6, #1
c0d0351a:	2e03      	cmp	r6, #3
c0d0351c:	d1e8      	bne.n	c0d034f0 <USBD_LL_DataInStage+0x18>
c0d0351e:	e051      	b.n	c0d035c4 <USBD_LL_DataInStage+0xec>
    
  if(epnum == 0) 
  {
    pep = &pdev->ep_in[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_IN)
c0d03520:	20f4      	movs	r0, #244	; 0xf4
c0d03522:	5820      	ldr	r0, [r4, r0]
c0d03524:	2802      	cmp	r0, #2
c0d03526:	d145      	bne.n	c0d035b4 <USBD_LL_DataInStage+0xdc>
    {
      if(pep->rem_length > pep->maxpacket)
c0d03528:	69e0      	ldr	r0, [r4, #28]
c0d0352a:	6a25      	ldr	r5, [r4, #32]
c0d0352c:	42a8      	cmp	r0, r5
c0d0352e:	d90b      	bls.n	c0d03548 <USBD_LL_DataInStage+0x70>
      {
        pep->rem_length -=  pep->maxpacket;
c0d03530:	1b40      	subs	r0, r0, r5
c0d03532:	61e0      	str	r0, [r4, #28]
        pdev->pData += pep->maxpacket;
c0d03534:	2113      	movs	r1, #19
c0d03536:	010a      	lsls	r2, r1, #4
c0d03538:	58a1      	ldr	r1, [r4, r2]
c0d0353a:	1949      	adds	r1, r1, r5
c0d0353c:	50a1      	str	r1, [r4, r2]
        USBD_LL_PrepareReceive (pdev,
                                0,
                                0);  
        */
        
        USBD_CtlContinueSendData (pdev, 
c0d0353e:	b282      	uxth	r2, r0
c0d03540:	4620      	mov	r0, r4
c0d03542:	f000 fd53 	bl	c0d03fec <USBD_CtlContinueSendData>
c0d03546:	e035      	b.n	c0d035b4 <USBD_LL_DataInStage+0xdc>
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d03548:	69a6      	ldr	r6, [r4, #24]
c0d0354a:	4630      	mov	r0, r6
c0d0354c:	4629      	mov	r1, r5
c0d0354e:	f000 fe21 	bl	c0d04194 <__aeabi_uidivmod>
c0d03552:	42ae      	cmp	r6, r5
c0d03554:	d30f      	bcc.n	c0d03576 <USBD_LL_DataInStage+0x9e>
c0d03556:	2900      	cmp	r1, #0
c0d03558:	d10d      	bne.n	c0d03576 <USBD_LL_DataInStage+0x9e>
           (pep->total_length >= pep->maxpacket) &&
             (pep->total_length < pdev->ep0_data_len ))
c0d0355a:	20f8      	movs	r0, #248	; 0xf8
c0d0355c:	5820      	ldr	r0, [r4, r0]
c0d0355e:	4627      	mov	r7, r4
c0d03560:	37f8      	adds	r7, #248	; 0xf8
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d03562:	4286      	cmp	r6, r0
c0d03564:	d207      	bcs.n	c0d03576 <USBD_LL_DataInStage+0x9e>
c0d03566:	2500      	movs	r5, #0
          USBD_LL_PrepareReceive (pdev,
                                  0,
                                  0);
          */

          USBD_CtlContinueSendData(pdev , NULL, 0);
c0d03568:	4620      	mov	r0, r4
c0d0356a:	4629      	mov	r1, r5
c0d0356c:	462a      	mov	r2, r5
c0d0356e:	f000 fd3d 	bl	c0d03fec <USBD_CtlContinueSendData>
          pdev->ep0_data_len = 0;
c0d03572:	603d      	str	r5, [r7, #0]
c0d03574:	e01e      	b.n	c0d035b4 <USBD_LL_DataInStage+0xdc>
          
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03576:	2045      	movs	r0, #69	; 0x45
c0d03578:	0080      	lsls	r0, r0, #2
c0d0357a:	1826      	adds	r6, r4, r0
c0d0357c:	4627      	mov	r7, r4
c0d0357e:	37fc      	adds	r7, #252	; 0xfc
c0d03580:	2500      	movs	r5, #0
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d03582:	4620      	mov	r0, r4
c0d03584:	4629      	mov	r1, r5
c0d03586:	f000 f867 	bl	c0d03658 <usbd_is_valid_intf>
c0d0358a:	2800      	cmp	r0, #0
c0d0358c:	d00c      	beq.n	c0d035a8 <USBD_LL_DataInStage+0xd0>
c0d0358e:	00e8      	lsls	r0, r5, #3
c0d03590:	5830      	ldr	r0, [r6, r0]
c0d03592:	68c0      	ldr	r0, [r0, #12]
c0d03594:	2800      	cmp	r0, #0
c0d03596:	d007      	beq.n	c0d035a8 <USBD_LL_DataInStage+0xd0>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d03598:	7839      	ldrb	r1, [r7, #0]
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d0359a:	2903      	cmp	r1, #3
c0d0359c:	d104      	bne.n	c0d035a8 <USBD_LL_DataInStage+0xd0>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
c0d0359e:	f7fe fc85 	bl	c0d01eac <pic>
c0d035a2:	4601      	mov	r1, r0
c0d035a4:	4620      	mov	r0, r4
c0d035a6:	4788      	blx	r1
          
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d035a8:	1c6d      	adds	r5, r5, #1
c0d035aa:	2d03      	cmp	r5, #3
c0d035ac:	d1e9      	bne.n	c0d03582 <USBD_LL_DataInStage+0xaa>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
            }
          }
          USBD_CtlReceiveStatus(pdev);
c0d035ae:	4620      	mov	r0, r4
c0d035b0:	f000 fd3d 	bl	c0d0402e <USBD_CtlReceiveStatus>
        }
      }
    }
    if (pdev->dev_test_mode == 1)
c0d035b4:	2001      	movs	r0, #1
c0d035b6:	0201      	lsls	r1, r0, #8
c0d035b8:	1860      	adds	r0, r4, r1
c0d035ba:	5c61      	ldrb	r1, [r4, r1]
c0d035bc:	2901      	cmp	r1, #1
c0d035be:	d101      	bne.n	c0d035c4 <USBD_LL_DataInStage+0xec>
    {
      USBD_RunTestMode(pdev); 
      pdev->dev_test_mode = 0;
c0d035c0:	2100      	movs	r1, #0
c0d035c2:	7001      	strb	r1, [r0, #0]
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
      }
    }
  }
  return USBD_OK;
c0d035c4:	2000      	movs	r0, #0
c0d035c6:	b001      	add	sp, #4
c0d035c8:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d035ca <USBD_LL_Reset>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_Reset(USBD_HandleTypeDef  *pdev)
{
c0d035ca:	b570      	push	{r4, r5, r6, lr}
c0d035cc:	4604      	mov	r4, r0
  pdev->ep_out[0].maxpacket = USB_MAX_EP0_SIZE;
c0d035ce:	2090      	movs	r0, #144	; 0x90
c0d035d0:	2140      	movs	r1, #64	; 0x40
c0d035d2:	5021      	str	r1, [r4, r0]
  

  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
c0d035d4:	6221      	str	r1, [r4, #32]
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
c0d035d6:	20fc      	movs	r0, #252	; 0xfc
c0d035d8:	2101      	movs	r1, #1
c0d035da:	5421      	strb	r1, [r4, r0]
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d035dc:	2045      	movs	r0, #69	; 0x45
c0d035de:	0080      	lsls	r0, r0, #2
c0d035e0:	1826      	adds	r6, r4, r0
c0d035e2:	2500      	movs	r5, #0
    if( usbd_is_valid_intf(pdev, intf))
c0d035e4:	4620      	mov	r0, r4
c0d035e6:	4629      	mov	r1, r5
c0d035e8:	f000 f836 	bl	c0d03658 <usbd_is_valid_intf>
c0d035ec:	2800      	cmp	r0, #0
c0d035ee:	d008      	beq.n	c0d03602 <USBD_LL_Reset+0x38>
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
c0d035f0:	00e8      	lsls	r0, r5, #3
c0d035f2:	5830      	ldr	r0, [r6, r0]
c0d035f4:	6840      	ldr	r0, [r0, #4]
c0d035f6:	f7fe fc59 	bl	c0d01eac <pic>
c0d035fa:	4602      	mov	r2, r0
c0d035fc:	7921      	ldrb	r1, [r4, #4]
c0d035fe:	4620      	mov	r0, r4
c0d03600:	4790      	blx	r2
  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03602:	1c6d      	adds	r5, r5, #1
c0d03604:	2d03      	cmp	r5, #3
c0d03606:	d1ed      	bne.n	c0d035e4 <USBD_LL_Reset+0x1a>
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
    }
  }
  
  return USBD_OK;
c0d03608:	2000      	movs	r0, #0
c0d0360a:	bd70      	pop	{r4, r5, r6, pc}

c0d0360c <USBD_LL_SetSpeed>:
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetSpeed(USBD_HandleTypeDef  *pdev, USBD_SpeedTypeDef speed)
{
  pdev->dev_speed = speed;
c0d0360c:	7401      	strb	r1, [r0, #16]
c0d0360e:	2000      	movs	r0, #0
  return USBD_OK;
c0d03610:	4770      	bx	lr

c0d03612 <USBD_LL_Suspend>:
{
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_old_state =  pdev->dev_state;
  //pdev->dev_state  = USBD_STATE_SUSPENDED;
  return USBD_OK;
c0d03612:	2000      	movs	r0, #0
c0d03614:	4770      	bx	lr

c0d03616 <USBD_LL_Resume>:
USBD_StatusTypeDef USBD_LL_Resume(USBD_HandleTypeDef  *pdev)
{
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_state = pdev->dev_old_state;  
  return USBD_OK;
c0d03616:	2000      	movs	r0, #0
c0d03618:	4770      	bx	lr

c0d0361a <USBD_LL_SOF>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
c0d0361a:	b570      	push	{r4, r5, r6, lr}
c0d0361c:	4604      	mov	r4, r0
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
c0d0361e:	20fc      	movs	r0, #252	; 0xfc
c0d03620:	5c20      	ldrb	r0, [r4, r0]
c0d03622:	2803      	cmp	r0, #3
c0d03624:	d116      	bne.n	c0d03654 <USBD_LL_SOF+0x3a>
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && pdev->interfacesClass[intf].pClass->SOF != NULL)
c0d03626:	2045      	movs	r0, #69	; 0x45
c0d03628:	0080      	lsls	r0, r0, #2
c0d0362a:	1826      	adds	r6, r4, r0
c0d0362c:	2500      	movs	r5, #0
c0d0362e:	4620      	mov	r0, r4
c0d03630:	4629      	mov	r1, r5
c0d03632:	f000 f811 	bl	c0d03658 <usbd_is_valid_intf>
c0d03636:	2800      	cmp	r0, #0
c0d03638:	d009      	beq.n	c0d0364e <USBD_LL_SOF+0x34>
c0d0363a:	00e8      	lsls	r0, r5, #3
c0d0363c:	5830      	ldr	r0, [r6, r0]
c0d0363e:	69c0      	ldr	r0, [r0, #28]
c0d03640:	2800      	cmp	r0, #0
c0d03642:	d004      	beq.n	c0d0364e <USBD_LL_SOF+0x34>
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
c0d03644:	f7fe fc32 	bl	c0d01eac <pic>
c0d03648:	4601      	mov	r1, r0
c0d0364a:	4620      	mov	r0, r4
c0d0364c:	4788      	blx	r1
USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0364e:	1c6d      	adds	r5, r5, #1
c0d03650:	2d03      	cmp	r5, #3
c0d03652:	d1ec      	bne.n	c0d0362e <USBD_LL_SOF+0x14>
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
      }
    }
  }
  return USBD_OK;
c0d03654:	2000      	movs	r0, #0
c0d03656:	bd70      	pop	{r4, r5, r6, pc}

c0d03658 <usbd_is_valid_intf>:

/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
c0d03658:	4602      	mov	r2, r0
c0d0365a:	2000      	movs	r0, #0
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d0365c:	2902      	cmp	r1, #2
c0d0365e:	d808      	bhi.n	c0d03672 <usbd_is_valid_intf+0x1a>
c0d03660:	00c8      	lsls	r0, r1, #3
c0d03662:	1810      	adds	r0, r2, r0
c0d03664:	2145      	movs	r1, #69	; 0x45
c0d03666:	0089      	lsls	r1, r1, #2
c0d03668:	5841      	ldr	r1, [r0, r1]
c0d0366a:	2001      	movs	r0, #1
c0d0366c:	2900      	cmp	r1, #0
c0d0366e:	d100      	bne.n	c0d03672 <usbd_is_valid_intf+0x1a>
c0d03670:	4608      	mov	r0, r1
c0d03672:	4770      	bx	lr

c0d03674 <USBD_StdDevReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdDevReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d03674:	b580      	push	{r7, lr}
c0d03676:	784a      	ldrb	r2, [r1, #1]
  USBD_StatusTypeDef ret = USBD_OK;  
  
  switch (req->bRequest) 
c0d03678:	2a04      	cmp	r2, #4
c0d0367a:	dd08      	ble.n	c0d0368e <USBD_StdDevReq+0x1a>
c0d0367c:	2a07      	cmp	r2, #7
c0d0367e:	dc0f      	bgt.n	c0d036a0 <USBD_StdDevReq+0x2c>
c0d03680:	2a05      	cmp	r2, #5
c0d03682:	d014      	beq.n	c0d036ae <USBD_StdDevReq+0x3a>
c0d03684:	2a06      	cmp	r2, #6
c0d03686:	d11b      	bne.n	c0d036c0 <USBD_StdDevReq+0x4c>
  {
  case USB_REQ_GET_DESCRIPTOR: 
    
    USBD_GetDescriptor (pdev, req) ;
c0d03688:	f000 f821 	bl	c0d036ce <USBD_GetDescriptor>
c0d0368c:	e01d      	b.n	c0d036ca <USBD_StdDevReq+0x56>
c0d0368e:	2a00      	cmp	r2, #0
c0d03690:	d010      	beq.n	c0d036b4 <USBD_StdDevReq+0x40>
c0d03692:	2a01      	cmp	r2, #1
c0d03694:	d017      	beq.n	c0d036c6 <USBD_StdDevReq+0x52>
c0d03696:	2a03      	cmp	r2, #3
c0d03698:	d112      	bne.n	c0d036c0 <USBD_StdDevReq+0x4c>
    USBD_GetStatus (pdev , req);
    break;
    
    
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
c0d0369a:	f000 f93b 	bl	c0d03914 <USBD_SetFeature>
c0d0369e:	e014      	b.n	c0d036ca <USBD_StdDevReq+0x56>
c0d036a0:	2a08      	cmp	r2, #8
c0d036a2:	d00a      	beq.n	c0d036ba <USBD_StdDevReq+0x46>
c0d036a4:	2a09      	cmp	r2, #9
c0d036a6:	d10b      	bne.n	c0d036c0 <USBD_StdDevReq+0x4c>
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
    break;
    
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
c0d036a8:	f000 f8c3 	bl	c0d03832 <USBD_SetConfig>
c0d036ac:	e00d      	b.n	c0d036ca <USBD_StdDevReq+0x56>
    
    USBD_GetDescriptor (pdev, req) ;
    break;
    
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
c0d036ae:	f000 f89b 	bl	c0d037e8 <USBD_SetAddress>
c0d036b2:	e00a      	b.n	c0d036ca <USBD_StdDevReq+0x56>
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_STATUS:                                  
    USBD_GetStatus (pdev , req);
c0d036b4:	f000 f90b 	bl	c0d038ce <USBD_GetStatus>
c0d036b8:	e007      	b.n	c0d036ca <USBD_StdDevReq+0x56>
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
c0d036ba:	f000 f8f1 	bl	c0d038a0 <USBD_GetConfig>
c0d036be:	e004      	b.n	c0d036ca <USBD_StdDevReq+0x56>
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
    break;
    
  default:  
    USBD_CtlError(pdev , req);
c0d036c0:	f000 fbfc 	bl	c0d03ebc <USBD_CtlError>
c0d036c4:	e001      	b.n	c0d036ca <USBD_StdDevReq+0x56>
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
    break;
    
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
c0d036c6:	f000 f944 	bl	c0d03952 <USBD_ClrFeature>
  default:  
    USBD_CtlError(pdev , req);
    break;
  }
  
  return ret;
c0d036ca:	2000      	movs	r0, #0
c0d036cc:	bd80      	pop	{r7, pc}

c0d036ce <USBD_GetDescriptor>:
* @param  req: usb request
* @retval status
*/
void USBD_GetDescriptor(USBD_HandleTypeDef *pdev , 
                               USBD_SetupReqTypedef *req)
{
c0d036ce:	b5b0      	push	{r4, r5, r7, lr}
c0d036d0:	b082      	sub	sp, #8
c0d036d2:	460d      	mov	r5, r1
c0d036d4:	4604      	mov	r4, r0
  uint16_t len;
  uint8_t *pbuf = NULL;
  
    
  switch (req->wValue >> 8)
c0d036d6:	8869      	ldrh	r1, [r5, #2]
c0d036d8:	0a08      	lsrs	r0, r1, #8
c0d036da:	2805      	cmp	r0, #5
c0d036dc:	dc13      	bgt.n	c0d03706 <USBD_GetDescriptor+0x38>
c0d036de:	2801      	cmp	r0, #1
c0d036e0:	d01c      	beq.n	c0d0371c <USBD_GetDescriptor+0x4e>
c0d036e2:	2802      	cmp	r0, #2
c0d036e4:	d025      	beq.n	c0d03732 <USBD_GetDescriptor+0x64>
c0d036e6:	2803      	cmp	r0, #3
c0d036e8:	d13b      	bne.n	c0d03762 <USBD_GetDescriptor+0x94>
c0d036ea:	b2c8      	uxtb	r0, r1
      }
    }
    break;
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
c0d036ec:	2802      	cmp	r0, #2
c0d036ee:	dc3d      	bgt.n	c0d0376c <USBD_GetDescriptor+0x9e>
c0d036f0:	2800      	cmp	r0, #0
c0d036f2:	d065      	beq.n	c0d037c0 <USBD_GetDescriptor+0xf2>
c0d036f4:	2801      	cmp	r0, #1
c0d036f6:	d06d      	beq.n	c0d037d4 <USBD_GetDescriptor+0x106>
c0d036f8:	2802      	cmp	r0, #2
c0d036fa:	d132      	bne.n	c0d03762 <USBD_GetDescriptor+0x94>
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
c0d036fc:	2011      	movs	r0, #17
c0d036fe:	0100      	lsls	r0, r0, #4
c0d03700:	5820      	ldr	r0, [r4, r0]
c0d03702:	68c0      	ldr	r0, [r0, #12]
c0d03704:	e00e      	b.n	c0d03724 <USBD_GetDescriptor+0x56>
c0d03706:	2806      	cmp	r0, #6
c0d03708:	d01e      	beq.n	c0d03748 <USBD_GetDescriptor+0x7a>
c0d0370a:	2807      	cmp	r0, #7
c0d0370c:	d026      	beq.n	c0d0375c <USBD_GetDescriptor+0x8e>
c0d0370e:	280f      	cmp	r0, #15
c0d03710:	d127      	bne.n	c0d03762 <USBD_GetDescriptor+0x94>
    
  switch (req->wValue >> 8)
  { 
#if (USBD_LPM_ENABLED == 1)
  case USB_DESC_TYPE_BOS:
    pbuf = ((GetBOSDescriptor_t)PIC(pdev->pDesc->GetBOSDescriptor))(pdev->dev_speed, &len);
c0d03712:	2011      	movs	r0, #17
c0d03714:	0100      	lsls	r0, r0, #4
c0d03716:	5820      	ldr	r0, [r4, r0]
c0d03718:	69c0      	ldr	r0, [r0, #28]
c0d0371a:	e003      	b.n	c0d03724 <USBD_GetDescriptor+0x56>
    break;
#endif    
  case USB_DESC_TYPE_DEVICE:
    pbuf = ((GetDeviceDescriptor_t)PIC(pdev->pDesc->GetDeviceDescriptor))(pdev->dev_speed, &len);
c0d0371c:	2011      	movs	r0, #17
c0d0371e:	0100      	lsls	r0, r0, #4
c0d03720:	5820      	ldr	r0, [r4, r0]
c0d03722:	6800      	ldr	r0, [r0, #0]
c0d03724:	f7fe fbc2 	bl	c0d01eac <pic>
c0d03728:	4602      	mov	r2, r0
c0d0372a:	7c20      	ldrb	r0, [r4, #16]
c0d0372c:	a901      	add	r1, sp, #4
c0d0372e:	4790      	blx	r2
c0d03730:	e034      	b.n	c0d0379c <USBD_GetDescriptor+0xce>
    break;
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
c0d03732:	2045      	movs	r0, #69	; 0x45
c0d03734:	0080      	lsls	r0, r0, #2
c0d03736:	5820      	ldr	r0, [r4, r0]
c0d03738:	2100      	movs	r1, #0
c0d0373a:	2800      	cmp	r0, #0
c0d0373c:	d02f      	beq.n	c0d0379e <USBD_GetDescriptor+0xd0>
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
c0d0373e:	7c21      	ldrb	r1, [r4, #16]
c0d03740:	2900      	cmp	r1, #0
c0d03742:	d025      	beq.n	c0d03790 <USBD_GetDescriptor+0xc2>
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
        //pbuf[1] = USB_DESC_TYPE_CONFIGURATION; CONST BUFFER KTHX
      }
      else
      {
        pbuf   = (uint8_t *)((GetFSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetFSConfigDescriptor))(&len);
c0d03744:	6ac0      	ldr	r0, [r0, #44]	; 0x2c
c0d03746:	e024      	b.n	c0d03792 <USBD_GetDescriptor+0xc4>
#endif   
    }
    break;
  case USB_DESC_TYPE_DEVICE_QUALIFIER:                   

    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL )   
c0d03748:	7c20      	ldrb	r0, [r4, #16]
c0d0374a:	2800      	cmp	r0, #0
c0d0374c:	d109      	bne.n	c0d03762 <USBD_GetDescriptor+0x94>
c0d0374e:	2045      	movs	r0, #69	; 0x45
c0d03750:	0080      	lsls	r0, r0, #2
c0d03752:	5820      	ldr	r0, [r4, r0]
c0d03754:	2800      	cmp	r0, #0
c0d03756:	d004      	beq.n	c0d03762 <USBD_GetDescriptor+0x94>
    {
      pbuf   = (uint8_t *)((GetDeviceQualifierDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetDeviceQualifierDescriptor))(&len);
c0d03758:	6b40      	ldr	r0, [r0, #52]	; 0x34
c0d0375a:	e01a      	b.n	c0d03792 <USBD_GetDescriptor+0xc4>
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d0375c:	7c20      	ldrb	r0, [r4, #16]
c0d0375e:	2800      	cmp	r0, #0
c0d03760:	d00f      	beq.n	c0d03782 <USBD_GetDescriptor+0xb4>
c0d03762:	4620      	mov	r0, r4
c0d03764:	4629      	mov	r1, r5
c0d03766:	f000 fba9 	bl	c0d03ebc <USBD_CtlError>
c0d0376a:	e027      	b.n	c0d037bc <USBD_GetDescriptor+0xee>
c0d0376c:	2803      	cmp	r0, #3
c0d0376e:	d02c      	beq.n	c0d037ca <USBD_GetDescriptor+0xfc>
c0d03770:	2804      	cmp	r0, #4
c0d03772:	d034      	beq.n	c0d037de <USBD_GetDescriptor+0x110>
c0d03774:	2805      	cmp	r0, #5
c0d03776:	d1f4      	bne.n	c0d03762 <USBD_GetDescriptor+0x94>
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_INTERFACE_STR:
      pbuf = ((GetInterfaceStrDescriptor_t)PIC(pdev->pDesc->GetInterfaceStrDescriptor))(pdev->dev_speed, &len);
c0d03778:	2011      	movs	r0, #17
c0d0377a:	0100      	lsls	r0, r0, #4
c0d0377c:	5820      	ldr	r0, [r4, r0]
c0d0377e:	6980      	ldr	r0, [r0, #24]
c0d03780:	e7d0      	b.n	c0d03724 <USBD_GetDescriptor+0x56>
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d03782:	2045      	movs	r0, #69	; 0x45
c0d03784:	0080      	lsls	r0, r0, #2
c0d03786:	5820      	ldr	r0, [r4, r0]
c0d03788:	2800      	cmp	r0, #0
c0d0378a:	d0ea      	beq.n	c0d03762 <USBD_GetDescriptor+0x94>
    {
      pbuf   = (uint8_t *)((GetOtherSpeedConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetOtherSpeedConfigDescriptor))(&len);
c0d0378c:	6b00      	ldr	r0, [r0, #48]	; 0x30
c0d0378e:	e000      	b.n	c0d03792 <USBD_GetDescriptor+0xc4>
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
      {
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
c0d03790:	6a80      	ldr	r0, [r0, #40]	; 0x28
c0d03792:	f7fe fb8b 	bl	c0d01eac <pic>
c0d03796:	4601      	mov	r1, r0
c0d03798:	a801      	add	r0, sp, #4
c0d0379a:	4788      	blx	r1
c0d0379c:	4601      	mov	r1, r0
c0d0379e:	a801      	add	r0, sp, #4
  default: 
     USBD_CtlError(pdev , req);
    return;
  }
  
  if((len != 0)&& (req->wLength != 0))
c0d037a0:	8802      	ldrh	r2, [r0, #0]
c0d037a2:	2a00      	cmp	r2, #0
c0d037a4:	d00a      	beq.n	c0d037bc <USBD_GetDescriptor+0xee>
c0d037a6:	88e8      	ldrh	r0, [r5, #6]
c0d037a8:	2800      	cmp	r0, #0
c0d037aa:	d007      	beq.n	c0d037bc <USBD_GetDescriptor+0xee>
  {
    
    len = MIN(len , req->wLength);
c0d037ac:	4282      	cmp	r2, r0
c0d037ae:	d300      	bcc.n	c0d037b2 <USBD_GetDescriptor+0xe4>
c0d037b0:	4602      	mov	r2, r0
c0d037b2:	a801      	add	r0, sp, #4
c0d037b4:	8002      	strh	r2, [r0, #0]
    
    // prepare abort if host does not read the whole data
    //USBD_CtlReceiveStatus(pdev);

    // start transfer
    USBD_CtlSendData (pdev, 
c0d037b6:	4620      	mov	r0, r4
c0d037b8:	f000 fc02 	bl	c0d03fc0 <USBD_CtlSendData>
                      pbuf,
                      len);
  }
  
}
c0d037bc:	b002      	add	sp, #8
c0d037be:	bdb0      	pop	{r4, r5, r7, pc}
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
    {
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
c0d037c0:	2011      	movs	r0, #17
c0d037c2:	0100      	lsls	r0, r0, #4
c0d037c4:	5820      	ldr	r0, [r4, r0]
c0d037c6:	6840      	ldr	r0, [r0, #4]
c0d037c8:	e7ac      	b.n	c0d03724 <USBD_GetDescriptor+0x56>
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
c0d037ca:	2011      	movs	r0, #17
c0d037cc:	0100      	lsls	r0, r0, #4
c0d037ce:	5820      	ldr	r0, [r4, r0]
c0d037d0:	6900      	ldr	r0, [r0, #16]
c0d037d2:	e7a7      	b.n	c0d03724 <USBD_GetDescriptor+0x56>
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
      break;
      
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
c0d037d4:	2011      	movs	r0, #17
c0d037d6:	0100      	lsls	r0, r0, #4
c0d037d8:	5820      	ldr	r0, [r4, r0]
c0d037da:	6880      	ldr	r0, [r0, #8]
c0d037dc:	e7a2      	b.n	c0d03724 <USBD_GetDescriptor+0x56>
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
c0d037de:	2011      	movs	r0, #17
c0d037e0:	0100      	lsls	r0, r0, #4
c0d037e2:	5820      	ldr	r0, [r4, r0]
c0d037e4:	6940      	ldr	r0, [r0, #20]
c0d037e6:	e79d      	b.n	c0d03724 <USBD_GetDescriptor+0x56>

c0d037e8 <USBD_SetAddress>:
* @param  req: usb request
* @retval status
*/
void USBD_SetAddress(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d037e8:	b570      	push	{r4, r5, r6, lr}
c0d037ea:	4604      	mov	r4, r0
  uint8_t  dev_addr; 
  
  if ((req->wIndex == 0) && (req->wLength == 0)) 
c0d037ec:	8888      	ldrh	r0, [r1, #4]
c0d037ee:	2800      	cmp	r0, #0
c0d037f0:	d10b      	bne.n	c0d0380a <USBD_SetAddress+0x22>
c0d037f2:	88c8      	ldrh	r0, [r1, #6]
c0d037f4:	2800      	cmp	r0, #0
c0d037f6:	d108      	bne.n	c0d0380a <USBD_SetAddress+0x22>
  {
    dev_addr = (uint8_t)(req->wValue) & 0x7F;     
c0d037f8:	8848      	ldrh	r0, [r1, #2]
c0d037fa:	267f      	movs	r6, #127	; 0x7f
c0d037fc:	4006      	ands	r6, r0
    
    if (pdev->dev_state == USBD_STATE_CONFIGURED) 
c0d037fe:	20fc      	movs	r0, #252	; 0xfc
c0d03800:	5c20      	ldrb	r0, [r4, r0]
c0d03802:	4625      	mov	r5, r4
c0d03804:	35fc      	adds	r5, #252	; 0xfc
c0d03806:	2803      	cmp	r0, #3
c0d03808:	d103      	bne.n	c0d03812 <USBD_SetAddress+0x2a>
c0d0380a:	4620      	mov	r0, r4
c0d0380c:	f000 fb56 	bl	c0d03ebc <USBD_CtlError>
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d03810:	bd70      	pop	{r4, r5, r6, pc}
    {
      USBD_CtlError(pdev , req);
    } 
    else 
    {
      pdev->dev_address = dev_addr;
c0d03812:	20fe      	movs	r0, #254	; 0xfe
c0d03814:	5426      	strb	r6, [r4, r0]
      USBD_LL_SetUSBAddress(pdev, dev_addr);               
c0d03816:	b2f1      	uxtb	r1, r6
c0d03818:	4620      	mov	r0, r4
c0d0381a:	f7ff fd0b 	bl	c0d03234 <USBD_LL_SetUSBAddress>
      USBD_CtlSendStatus(pdev);                         
c0d0381e:	4620      	mov	r0, r4
c0d03820:	f000 fbf9 	bl	c0d04016 <USBD_CtlSendStatus>
      
      if (dev_addr != 0) 
c0d03824:	2002      	movs	r0, #2
c0d03826:	2101      	movs	r1, #1
c0d03828:	2e00      	cmp	r6, #0
c0d0382a:	d100      	bne.n	c0d0382e <USBD_SetAddress+0x46>
c0d0382c:	4608      	mov	r0, r1
c0d0382e:	7028      	strb	r0, [r5, #0]
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d03830:	bd70      	pop	{r4, r5, r6, pc}

c0d03832 <USBD_SetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_SetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d03832:	b570      	push	{r4, r5, r6, lr}
c0d03834:	460d      	mov	r5, r1
c0d03836:	4604      	mov	r4, r0
  
  uint8_t  cfgidx;
  
  cfgidx = (uint8_t)(req->wValue);                 
c0d03838:	78ae      	ldrb	r6, [r5, #2]
  
  if (cfgidx > USBD_MAX_NUM_CONFIGURATION ) 
c0d0383a:	2e02      	cmp	r6, #2
c0d0383c:	d21d      	bcs.n	c0d0387a <USBD_SetConfig+0x48>
  {            
     USBD_CtlError(pdev , req);                              
  } 
  else 
  {
    switch (pdev->dev_state) 
c0d0383e:	20fc      	movs	r0, #252	; 0xfc
c0d03840:	5c21      	ldrb	r1, [r4, r0]
c0d03842:	4620      	mov	r0, r4
c0d03844:	30fc      	adds	r0, #252	; 0xfc
c0d03846:	2903      	cmp	r1, #3
c0d03848:	d007      	beq.n	c0d0385a <USBD_SetConfig+0x28>
c0d0384a:	2902      	cmp	r1, #2
c0d0384c:	d115      	bne.n	c0d0387a <USBD_SetConfig+0x48>
    {
    case USBD_STATE_ADDRESSED:
      if (cfgidx) 
c0d0384e:	2e00      	cmp	r6, #0
c0d03850:	d022      	beq.n	c0d03898 <USBD_SetConfig+0x66>
      {                                			   							   							   				
        pdev->dev_config = cfgidx;
c0d03852:	6066      	str	r6, [r4, #4]
        pdev->dev_state = USBD_STATE_CONFIGURED;
c0d03854:	2103      	movs	r1, #3
c0d03856:	7001      	strb	r1, [r0, #0]
c0d03858:	e009      	b.n	c0d0386e <USBD_SetConfig+0x3c>
      }
      USBD_CtlSendStatus(pdev);
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
c0d0385a:	2e00      	cmp	r6, #0
c0d0385c:	d012      	beq.n	c0d03884 <USBD_SetConfig+0x52>
        pdev->dev_state = USBD_STATE_ADDRESSED;
        pdev->dev_config = cfgidx;          
        USBD_ClrClassConfig(pdev , cfgidx);
        USBD_CtlSendStatus(pdev);
      } 
      else  if (cfgidx != pdev->dev_config) 
c0d0385e:	6860      	ldr	r0, [r4, #4]
c0d03860:	4286      	cmp	r6, r0
c0d03862:	d019      	beq.n	c0d03898 <USBD_SetConfig+0x66>
      {
        /* Clear old configuration */
        USBD_ClrClassConfig(pdev , pdev->dev_config);
c0d03864:	b2c1      	uxtb	r1, r0
c0d03866:	4620      	mov	r0, r4
c0d03868:	f7ff fd8b 	bl	c0d03382 <USBD_ClrClassConfig>
        
        /* set new configuration */
        pdev->dev_config = cfgidx;
c0d0386c:	6066      	str	r6, [r4, #4]
c0d0386e:	4620      	mov	r0, r4
c0d03870:	4631      	mov	r1, r6
c0d03872:	f7ff fd69 	bl	c0d03348 <USBD_SetClassConfig>
c0d03876:	2802      	cmp	r0, #2
c0d03878:	d10e      	bne.n	c0d03898 <USBD_SetConfig+0x66>
c0d0387a:	4620      	mov	r0, r4
c0d0387c:	4629      	mov	r1, r5
c0d0387e:	f000 fb1d 	bl	c0d03ebc <USBD_CtlError>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d03882:	bd70      	pop	{r4, r5, r6, pc}
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
      {                           
        pdev->dev_state = USBD_STATE_ADDRESSED;
c0d03884:	2102      	movs	r1, #2
c0d03886:	7001      	strb	r1, [r0, #0]
        pdev->dev_config = cfgidx;          
c0d03888:	6066      	str	r6, [r4, #4]
        USBD_ClrClassConfig(pdev , cfgidx);
c0d0388a:	4620      	mov	r0, r4
c0d0388c:	4631      	mov	r1, r6
c0d0388e:	f7ff fd78 	bl	c0d03382 <USBD_ClrClassConfig>
        USBD_CtlSendStatus(pdev);
c0d03892:	4620      	mov	r0, r4
c0d03894:	f000 fbbf 	bl	c0d04016 <USBD_CtlSendStatus>
c0d03898:	4620      	mov	r0, r4
c0d0389a:	f000 fbbc 	bl	c0d04016 <USBD_CtlSendStatus>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d0389e:	bd70      	pop	{r4, r5, r6, pc}

c0d038a0 <USBD_GetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_GetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d038a0:	b580      	push	{r7, lr}

  if (req->wLength != 1) 
c0d038a2:	88ca      	ldrh	r2, [r1, #6]
c0d038a4:	2a01      	cmp	r2, #1
c0d038a6:	d10a      	bne.n	c0d038be <USBD_GetConfig+0x1e>
  {                   
     USBD_CtlError(pdev , req);
  }
  else 
  {
    switch (pdev->dev_state )  
c0d038a8:	22fc      	movs	r2, #252	; 0xfc
c0d038aa:	5c82      	ldrb	r2, [r0, r2]
c0d038ac:	2a03      	cmp	r2, #3
c0d038ae:	d009      	beq.n	c0d038c4 <USBD_GetConfig+0x24>
c0d038b0:	2a02      	cmp	r2, #2
c0d038b2:	d104      	bne.n	c0d038be <USBD_GetConfig+0x1e>
    {
    case USBD_STATE_ADDRESSED:                     
      pdev->dev_default_config = 0;
c0d038b4:	2100      	movs	r1, #0
c0d038b6:	6081      	str	r1, [r0, #8]
c0d038b8:	4601      	mov	r1, r0
c0d038ba:	3108      	adds	r1, #8
c0d038bc:	e003      	b.n	c0d038c6 <USBD_GetConfig+0x26>
c0d038be:	f000 fafd 	bl	c0d03ebc <USBD_CtlError>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d038c2:	bd80      	pop	{r7, pc}
                        1);
      break;
      
    case USBD_STATE_CONFIGURED:   
      USBD_CtlSendData (pdev, 
                        (uint8_t *)&pdev->dev_config,
c0d038c4:	1d01      	adds	r1, r0, #4
c0d038c6:	2201      	movs	r2, #1
c0d038c8:	f000 fb7a 	bl	c0d03fc0 <USBD_CtlSendData>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d038cc:	bd80      	pop	{r7, pc}

c0d038ce <USBD_GetStatus>:
* @param  req: usb request
* @retval status
*/
void USBD_GetStatus(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d038ce:	b5b0      	push	{r4, r5, r7, lr}
c0d038d0:	4604      	mov	r4, r0
  
    
  switch (pdev->dev_state) 
c0d038d2:	20fc      	movs	r0, #252	; 0xfc
c0d038d4:	5c20      	ldrb	r0, [r4, r0]
c0d038d6:	22fe      	movs	r2, #254	; 0xfe
c0d038d8:	4002      	ands	r2, r0
c0d038da:	2a02      	cmp	r2, #2
c0d038dc:	d116      	bne.n	c0d0390c <USBD_GetStatus+0x3e>
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d038de:	2001      	movs	r0, #1
c0d038e0:	60e0      	str	r0, [r4, #12]
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d038e2:	2041      	movs	r0, #65	; 0x41
c0d038e4:	0080      	lsls	r0, r0, #2
c0d038e6:	5821      	ldr	r1, [r4, r0]
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d038e8:	4625      	mov	r5, r4
c0d038ea:	350c      	adds	r5, #12
c0d038ec:	2003      	movs	r0, #3
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d038ee:	2900      	cmp	r1, #0
c0d038f0:	d005      	beq.n	c0d038fe <USBD_GetStatus+0x30>
c0d038f2:	4620      	mov	r0, r4
c0d038f4:	f000 fb9b 	bl	c0d0402e <USBD_CtlReceiveStatus>
c0d038f8:	68e1      	ldr	r1, [r4, #12]
c0d038fa:	2002      	movs	r0, #2
c0d038fc:	4308      	orrs	r0, r1
    {
       pdev->dev_config_status |= USB_CONFIG_REMOTE_WAKEUP;                                
c0d038fe:	60e0      	str	r0, [r4, #12]
    }
    
    USBD_CtlSendData (pdev, 
c0d03900:	2202      	movs	r2, #2
c0d03902:	4620      	mov	r0, r4
c0d03904:	4629      	mov	r1, r5
c0d03906:	f000 fb5b 	bl	c0d03fc0 <USBD_CtlSendData>
    
  default :
    USBD_CtlError(pdev , req);                        
    break;
  }
}
c0d0390a:	bdb0      	pop	{r4, r5, r7, pc}
                      (uint8_t *)& pdev->dev_config_status,
                      2);
    break;
    
  default :
    USBD_CtlError(pdev , req);                        
c0d0390c:	4620      	mov	r0, r4
c0d0390e:	f000 fad5 	bl	c0d03ebc <USBD_CtlError>
    break;
  }
}
c0d03912:	bdb0      	pop	{r4, r5, r7, pc}

c0d03914 <USBD_SetFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_SetFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d03914:	b5b0      	push	{r4, r5, r7, lr}
c0d03916:	460d      	mov	r5, r1
c0d03918:	4604      	mov	r4, r0

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
c0d0391a:	8868      	ldrh	r0, [r5, #2]
c0d0391c:	2801      	cmp	r0, #1
c0d0391e:	d117      	bne.n	c0d03950 <USBD_SetFeature+0x3c>
  {
    pdev->dev_remote_wakeup = 1;  
c0d03920:	2041      	movs	r0, #65	; 0x41
c0d03922:	0080      	lsls	r0, r0, #2
c0d03924:	2101      	movs	r1, #1
c0d03926:	5021      	str	r1, [r4, r0]
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03928:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d0392a:	2802      	cmp	r0, #2
c0d0392c:	d80d      	bhi.n	c0d0394a <USBD_SetFeature+0x36>
c0d0392e:	00c0      	lsls	r0, r0, #3
c0d03930:	1820      	adds	r0, r4, r0
c0d03932:	2145      	movs	r1, #69	; 0x45
c0d03934:	0089      	lsls	r1, r1, #2
c0d03936:	5840      	ldr	r0, [r0, r1]
{

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
  {
    pdev->dev_remote_wakeup = 1;  
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03938:	2800      	cmp	r0, #0
c0d0393a:	d006      	beq.n	c0d0394a <USBD_SetFeature+0x36>
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d0393c:	6880      	ldr	r0, [r0, #8]
c0d0393e:	f7fe fab5 	bl	c0d01eac <pic>
c0d03942:	4602      	mov	r2, r0
c0d03944:	4620      	mov	r0, r4
c0d03946:	4629      	mov	r1, r5
c0d03948:	4790      	blx	r2
    }
    USBD_CtlSendStatus(pdev);
c0d0394a:	4620      	mov	r0, r4
c0d0394c:	f000 fb63 	bl	c0d04016 <USBD_CtlSendStatus>
  }

}
c0d03950:	bdb0      	pop	{r4, r5, r7, pc}

c0d03952 <USBD_ClrFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_ClrFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d03952:	b5b0      	push	{r4, r5, r7, lr}
c0d03954:	460d      	mov	r5, r1
c0d03956:	4604      	mov	r4, r0
  switch (pdev->dev_state)
c0d03958:	20fc      	movs	r0, #252	; 0xfc
c0d0395a:	5c20      	ldrb	r0, [r4, r0]
c0d0395c:	21fe      	movs	r1, #254	; 0xfe
c0d0395e:	4001      	ands	r1, r0
c0d03960:	2902      	cmp	r1, #2
c0d03962:	d11b      	bne.n	c0d0399c <USBD_ClrFeature+0x4a>
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
c0d03964:	8868      	ldrh	r0, [r5, #2]
c0d03966:	2801      	cmp	r0, #1
c0d03968:	d11c      	bne.n	c0d039a4 <USBD_ClrFeature+0x52>
    {
      pdev->dev_remote_wakeup = 0; 
c0d0396a:	2041      	movs	r0, #65	; 0x41
c0d0396c:	0080      	lsls	r0, r0, #2
c0d0396e:	2100      	movs	r1, #0
c0d03970:	5021      	str	r1, [r4, r0]
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03972:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03974:	2802      	cmp	r0, #2
c0d03976:	d80d      	bhi.n	c0d03994 <USBD_ClrFeature+0x42>
c0d03978:	00c0      	lsls	r0, r0, #3
c0d0397a:	1820      	adds	r0, r4, r0
c0d0397c:	2145      	movs	r1, #69	; 0x45
c0d0397e:	0089      	lsls	r1, r1, #2
c0d03980:	5840      	ldr	r0, [r0, r1]
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
    {
      pdev->dev_remote_wakeup = 0; 
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03982:	2800      	cmp	r0, #0
c0d03984:	d006      	beq.n	c0d03994 <USBD_ClrFeature+0x42>
        ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d03986:	6880      	ldr	r0, [r0, #8]
c0d03988:	f7fe fa90 	bl	c0d01eac <pic>
c0d0398c:	4602      	mov	r2, r0
c0d0398e:	4620      	mov	r0, r4
c0d03990:	4629      	mov	r1, r5
c0d03992:	4790      	blx	r2
      }
      USBD_CtlSendStatus(pdev);
c0d03994:	4620      	mov	r0, r4
c0d03996:	f000 fb3e 	bl	c0d04016 <USBD_CtlSendStatus>
    
  default :
     USBD_CtlError(pdev , req);
    break;
  }
}
c0d0399a:	bdb0      	pop	{r4, r5, r7, pc}
      USBD_CtlSendStatus(pdev);
    }
    break;
    
  default :
     USBD_CtlError(pdev , req);
c0d0399c:	4620      	mov	r0, r4
c0d0399e:	4629      	mov	r1, r5
c0d039a0:	f000 fa8c 	bl	c0d03ebc <USBD_CtlError>
    break;
  }
}
c0d039a4:	bdb0      	pop	{r4, r5, r7, pc}

c0d039a6 <USBD_StdItfReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdItfReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d039a6:	b5b0      	push	{r4, r5, r7, lr}
c0d039a8:	460d      	mov	r5, r1
c0d039aa:	4604      	mov	r4, r0
  USBD_StatusTypeDef ret = USBD_OK; 
  
  switch (pdev->dev_state) 
c0d039ac:	20fc      	movs	r0, #252	; 0xfc
c0d039ae:	5c20      	ldrb	r0, [r4, r0]
c0d039b0:	2803      	cmp	r0, #3
c0d039b2:	d117      	bne.n	c0d039e4 <USBD_StdItfReq+0x3e>
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d039b4:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d039b6:	2802      	cmp	r0, #2
c0d039b8:	d814      	bhi.n	c0d039e4 <USBD_StdItfReq+0x3e>
c0d039ba:	00c0      	lsls	r0, r0, #3
c0d039bc:	1820      	adds	r0, r4, r0
c0d039be:	2145      	movs	r1, #69	; 0x45
c0d039c0:	0089      	lsls	r1, r1, #2
c0d039c2:	5840      	ldr	r0, [r0, r1]
  
  switch (pdev->dev_state) 
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d039c4:	2800      	cmp	r0, #0
c0d039c6:	d00d      	beq.n	c0d039e4 <USBD_StdItfReq+0x3e>
    {
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d039c8:	6880      	ldr	r0, [r0, #8]
c0d039ca:	f7fe fa6f 	bl	c0d01eac <pic>
c0d039ce:	4602      	mov	r2, r0
c0d039d0:	4620      	mov	r0, r4
c0d039d2:	4629      	mov	r1, r5
c0d039d4:	4790      	blx	r2
      
      if((req->wLength == 0)&& (ret == USBD_OK))
c0d039d6:	88e8      	ldrh	r0, [r5, #6]
c0d039d8:	2800      	cmp	r0, #0
c0d039da:	d107      	bne.n	c0d039ec <USBD_StdItfReq+0x46>
      {
         USBD_CtlSendStatus(pdev);
c0d039dc:	4620      	mov	r0, r4
c0d039de:	f000 fb1a 	bl	c0d04016 <USBD_CtlSendStatus>
c0d039e2:	e003      	b.n	c0d039ec <USBD_StdItfReq+0x46>
c0d039e4:	4620      	mov	r0, r4
c0d039e6:	4629      	mov	r1, r5
c0d039e8:	f000 fa68 	bl	c0d03ebc <USBD_CtlError>
    
  default:
     USBD_CtlError(pdev , req);
    break;
  }
  return USBD_OK;
c0d039ec:	2000      	movs	r0, #0
c0d039ee:	bdb0      	pop	{r4, r5, r7, pc}

c0d039f0 <USBD_StdEPReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdEPReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d039f0:	b570      	push	{r4, r5, r6, lr}
c0d039f2:	460d      	mov	r5, r1
c0d039f4:	4604      	mov	r4, r0
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d039f6:	7828      	ldrb	r0, [r5, #0]
c0d039f8:	2160      	movs	r1, #96	; 0x60
c0d039fa:	4001      	ands	r1, r0
{
  
  uint8_t   ep_addr;
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
c0d039fc:	792e      	ldrb	r6, [r5, #4]
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d039fe:	2920      	cmp	r1, #32
c0d03a00:	d110      	bne.n	c0d03a24 <USBD_StdEPReq+0x34>
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03a02:	2e02      	cmp	r6, #2
c0d03a04:	d80e      	bhi.n	c0d03a24 <USBD_StdEPReq+0x34>
c0d03a06:	00f0      	lsls	r0, r6, #3
c0d03a08:	1820      	adds	r0, r4, r0
c0d03a0a:	2145      	movs	r1, #69	; 0x45
c0d03a0c:	0089      	lsls	r1, r1, #2
c0d03a0e:	5840      	ldr	r0, [r0, r1]
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d03a10:	2800      	cmp	r0, #0
c0d03a12:	d007      	beq.n	c0d03a24 <USBD_StdEPReq+0x34>
  {
    ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d03a14:	6880      	ldr	r0, [r0, #8]
c0d03a16:	f7fe fa49 	bl	c0d01eac <pic>
c0d03a1a:	4602      	mov	r2, r0
c0d03a1c:	4620      	mov	r0, r4
c0d03a1e:	4629      	mov	r1, r5
c0d03a20:	4790      	blx	r2
c0d03a22:	e06e      	b.n	c0d03b02 <USBD_StdEPReq+0x112>
    
    return USBD_OK;
  }
  
  switch (req->bRequest) 
c0d03a24:	7868      	ldrb	r0, [r5, #1]
c0d03a26:	2800      	cmp	r0, #0
c0d03a28:	d017      	beq.n	c0d03a5a <USBD_StdEPReq+0x6a>
c0d03a2a:	2801      	cmp	r0, #1
c0d03a2c:	d01e      	beq.n	c0d03a6c <USBD_StdEPReq+0x7c>
c0d03a2e:	2803      	cmp	r0, #3
c0d03a30:	d167      	bne.n	c0d03b02 <USBD_StdEPReq+0x112>
  {
    
  case USB_REQ_SET_FEATURE :
    
    switch (pdev->dev_state) 
c0d03a32:	20fc      	movs	r0, #252	; 0xfc
c0d03a34:	5c20      	ldrb	r0, [r4, r0]
c0d03a36:	2803      	cmp	r0, #3
c0d03a38:	d11c      	bne.n	c0d03a74 <USBD_StdEPReq+0x84>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d03a3a:	8868      	ldrh	r0, [r5, #2]
c0d03a3c:	2800      	cmp	r0, #0
c0d03a3e:	d108      	bne.n	c0d03a52 <USBD_StdEPReq+0x62>
      {
        if ((ep_addr != 0x00) && (ep_addr != 0x80)) 
c0d03a40:	2080      	movs	r0, #128	; 0x80
c0d03a42:	4330      	orrs	r0, r6
c0d03a44:	2880      	cmp	r0, #128	; 0x80
c0d03a46:	d004      	beq.n	c0d03a52 <USBD_StdEPReq+0x62>
        { 
          USBD_LL_StallEP(pdev , ep_addr);
c0d03a48:	4620      	mov	r0, r4
c0d03a4a:	4631      	mov	r1, r6
c0d03a4c:	f7ff fb96 	bl	c0d0317c <USBD_LL_StallEP>
          
        }
c0d03a50:	792e      	ldrb	r6, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03a52:	2e02      	cmp	r6, #2
c0d03a54:	d852      	bhi.n	c0d03afc <USBD_StdEPReq+0x10c>
c0d03a56:	00f0      	lsls	r0, r6, #3
c0d03a58:	e043      	b.n	c0d03ae2 <USBD_StdEPReq+0xf2>
      break;    
    }
    break;
    
  case USB_REQ_GET_STATUS:                  
    switch (pdev->dev_state) 
c0d03a5a:	20fc      	movs	r0, #252	; 0xfc
c0d03a5c:	5c20      	ldrb	r0, [r4, r0]
c0d03a5e:	2803      	cmp	r0, #3
c0d03a60:	d018      	beq.n	c0d03a94 <USBD_StdEPReq+0xa4>
c0d03a62:	2802      	cmp	r0, #2
c0d03a64:	d111      	bne.n	c0d03a8a <USBD_StdEPReq+0x9a>
    {
    case USBD_STATE_ADDRESSED:          
      if ((ep_addr & 0x7F) != 0x00) 
c0d03a66:	0670      	lsls	r0, r6, #25
c0d03a68:	d10a      	bne.n	c0d03a80 <USBD_StdEPReq+0x90>
c0d03a6a:	e04a      	b.n	c0d03b02 <USBD_StdEPReq+0x112>
    }
    break;
    
  case USB_REQ_CLEAR_FEATURE :
    
    switch (pdev->dev_state) 
c0d03a6c:	20fc      	movs	r0, #252	; 0xfc
c0d03a6e:	5c20      	ldrb	r0, [r4, r0]
c0d03a70:	2803      	cmp	r0, #3
c0d03a72:	d029      	beq.n	c0d03ac8 <USBD_StdEPReq+0xd8>
c0d03a74:	2802      	cmp	r0, #2
c0d03a76:	d108      	bne.n	c0d03a8a <USBD_StdEPReq+0x9a>
c0d03a78:	2080      	movs	r0, #128	; 0x80
c0d03a7a:	4330      	orrs	r0, r6
c0d03a7c:	2880      	cmp	r0, #128	; 0x80
c0d03a7e:	d040      	beq.n	c0d03b02 <USBD_StdEPReq+0x112>
c0d03a80:	4620      	mov	r0, r4
c0d03a82:	4631      	mov	r1, r6
c0d03a84:	f7ff fb7a 	bl	c0d0317c <USBD_LL_StallEP>
c0d03a88:	e03b      	b.n	c0d03b02 <USBD_StdEPReq+0x112>
c0d03a8a:	4620      	mov	r0, r4
c0d03a8c:	4629      	mov	r1, r5
c0d03a8e:	f000 fa15 	bl	c0d03ebc <USBD_CtlError>
c0d03a92:	e036      	b.n	c0d03b02 <USBD_StdEPReq+0x112>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d03a94:	4625      	mov	r5, r4
c0d03a96:	3514      	adds	r5, #20
                                         &pdev->ep_out[ep_addr & 0x7F];
c0d03a98:	4620      	mov	r0, r4
c0d03a9a:	3084      	adds	r0, #132	; 0x84
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d03a9c:	2180      	movs	r1, #128	; 0x80
c0d03a9e:	420e      	tst	r6, r1
c0d03aa0:	d100      	bne.n	c0d03aa4 <USBD_StdEPReq+0xb4>
c0d03aa2:	4605      	mov	r5, r0
                                         &pdev->ep_out[ep_addr & 0x7F];
      if(USBD_LL_IsStallEP(pdev, ep_addr))
c0d03aa4:	4620      	mov	r0, r4
c0d03aa6:	4631      	mov	r1, r6
c0d03aa8:	f7ff fbb2 	bl	c0d03210 <USBD_LL_IsStallEP>
c0d03aac:	2101      	movs	r1, #1
c0d03aae:	2800      	cmp	r0, #0
c0d03ab0:	d100      	bne.n	c0d03ab4 <USBD_StdEPReq+0xc4>
c0d03ab2:	4601      	mov	r1, r0
c0d03ab4:	207f      	movs	r0, #127	; 0x7f
c0d03ab6:	4006      	ands	r6, r0
c0d03ab8:	0130      	lsls	r0, r6, #4
c0d03aba:	5029      	str	r1, [r5, r0]
c0d03abc:	1829      	adds	r1, r5, r0
      else
      {
        pep->status = 0x0000;  
      }
      
      USBD_CtlSendData (pdev,
c0d03abe:	2202      	movs	r2, #2
c0d03ac0:	4620      	mov	r0, r4
c0d03ac2:	f000 fa7d 	bl	c0d03fc0 <USBD_CtlSendData>
c0d03ac6:	e01c      	b.n	c0d03b02 <USBD_StdEPReq+0x112>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d03ac8:	8868      	ldrh	r0, [r5, #2]
c0d03aca:	2800      	cmp	r0, #0
c0d03acc:	d119      	bne.n	c0d03b02 <USBD_StdEPReq+0x112>
      {
        if ((ep_addr & 0x7F) != 0x00) 
c0d03ace:	0670      	lsls	r0, r6, #25
c0d03ad0:	d014      	beq.n	c0d03afc <USBD_StdEPReq+0x10c>
        {        
          USBD_LL_ClearStallEP(pdev , ep_addr);
c0d03ad2:	4620      	mov	r0, r4
c0d03ad4:	4631      	mov	r1, r6
c0d03ad6:	f7ff fb77 	bl	c0d031c8 <USBD_LL_ClearStallEP>
          if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03ada:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03adc:	2802      	cmp	r0, #2
c0d03ade:	d80d      	bhi.n	c0d03afc <USBD_StdEPReq+0x10c>
c0d03ae0:	00c0      	lsls	r0, r0, #3
c0d03ae2:	1820      	adds	r0, r4, r0
c0d03ae4:	2145      	movs	r1, #69	; 0x45
c0d03ae6:	0089      	lsls	r1, r1, #2
c0d03ae8:	5840      	ldr	r0, [r0, r1]
c0d03aea:	2800      	cmp	r0, #0
c0d03aec:	d006      	beq.n	c0d03afc <USBD_StdEPReq+0x10c>
c0d03aee:	6880      	ldr	r0, [r0, #8]
c0d03af0:	f7fe f9dc 	bl	c0d01eac <pic>
c0d03af4:	4602      	mov	r2, r0
c0d03af6:	4620      	mov	r0, r4
c0d03af8:	4629      	mov	r1, r5
c0d03afa:	4790      	blx	r2
c0d03afc:	4620      	mov	r0, r4
c0d03afe:	f000 fa8a 	bl	c0d04016 <USBD_CtlSendStatus>
    
  default:
    break;
  }
  return ret;
}
c0d03b02:	2000      	movs	r0, #0
c0d03b04:	bd70      	pop	{r4, r5, r6, pc}

c0d03b06 <USBD_ParseSetupRequest>:
* @retval None
*/

void USBD_ParseSetupRequest(USBD_SetupReqTypedef *req, uint8_t *pdata)
{
  req->bmRequest     = *(uint8_t *)  (pdata);
c0d03b06:	780a      	ldrb	r2, [r1, #0]
c0d03b08:	7002      	strb	r2, [r0, #0]
  req->bRequest      = *(uint8_t *)  (pdata +  1);
c0d03b0a:	784a      	ldrb	r2, [r1, #1]
c0d03b0c:	7042      	strb	r2, [r0, #1]
  req->wValue        = SWAPBYTE      (pdata +  2);
c0d03b0e:	788a      	ldrb	r2, [r1, #2]
c0d03b10:	78cb      	ldrb	r3, [r1, #3]
c0d03b12:	021b      	lsls	r3, r3, #8
c0d03b14:	4313      	orrs	r3, r2
c0d03b16:	8043      	strh	r3, [r0, #2]
  req->wIndex        = SWAPBYTE      (pdata +  4);
c0d03b18:	790a      	ldrb	r2, [r1, #4]
c0d03b1a:	794b      	ldrb	r3, [r1, #5]
c0d03b1c:	021b      	lsls	r3, r3, #8
c0d03b1e:	4313      	orrs	r3, r2
c0d03b20:	8083      	strh	r3, [r0, #4]
  req->wLength       = SWAPBYTE      (pdata +  6);
c0d03b22:	798a      	ldrb	r2, [r1, #6]
c0d03b24:	79c9      	ldrb	r1, [r1, #7]
c0d03b26:	0209      	lsls	r1, r1, #8
c0d03b28:	4311      	orrs	r1, r2
c0d03b2a:	80c1      	strh	r1, [r0, #6]

}
c0d03b2c:	4770      	bx	lr

c0d03b2e <USBD_CtlStall>:
* @param  pdev: device instance
* @param  req: usb request
* @retval None
*/
void USBD_CtlStall( USBD_HandleTypeDef *pdev)
{
c0d03b2e:	b510      	push	{r4, lr}
c0d03b30:	4604      	mov	r4, r0
  USBD_LL_StallEP(pdev , 0x80);
c0d03b32:	2180      	movs	r1, #128	; 0x80
c0d03b34:	f7ff fb22 	bl	c0d0317c <USBD_LL_StallEP>
  USBD_LL_StallEP(pdev , 0);
c0d03b38:	2100      	movs	r1, #0
c0d03b3a:	4620      	mov	r0, r4
c0d03b3c:	f7ff fb1e 	bl	c0d0317c <USBD_LL_StallEP>
}
c0d03b40:	bd10      	pop	{r4, pc}

c0d03b42 <USBD_HID_Setup>:
  * @param  req: usb requests
  * @retval status
  */
uint8_t  USBD_HID_Setup (USBD_HandleTypeDef *pdev, 
                                USBD_SetupReqTypedef *req)
{
c0d03b42:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03b44:	b083      	sub	sp, #12
c0d03b46:	460d      	mov	r5, r1
c0d03b48:	4604      	mov	r4, r0
c0d03b4a:	a802      	add	r0, sp, #8
c0d03b4c:	2700      	movs	r7, #0
  uint16_t len = 0;
c0d03b4e:	8007      	strh	r7, [r0, #0]
c0d03b50:	a801      	add	r0, sp, #4
  uint8_t  *pbuf = NULL;

  uint8_t val = 0;
c0d03b52:	7007      	strb	r7, [r0, #0]

  switch (req->bmRequest & USB_REQ_TYPE_MASK)
c0d03b54:	7829      	ldrb	r1, [r5, #0]
c0d03b56:	2060      	movs	r0, #96	; 0x60
c0d03b58:	4008      	ands	r0, r1
c0d03b5a:	2800      	cmp	r0, #0
c0d03b5c:	d010      	beq.n	c0d03b80 <USBD_HID_Setup+0x3e>
c0d03b5e:	2820      	cmp	r0, #32
c0d03b60:	d138      	bne.n	c0d03bd4 <USBD_HID_Setup+0x92>
c0d03b62:	7868      	ldrb	r0, [r5, #1]
  {
  case USB_REQ_TYPE_CLASS :  
    switch (req->bRequest)
c0d03b64:	4601      	mov	r1, r0
c0d03b66:	390a      	subs	r1, #10
c0d03b68:	2902      	cmp	r1, #2
c0d03b6a:	d333      	bcc.n	c0d03bd4 <USBD_HID_Setup+0x92>
c0d03b6c:	2802      	cmp	r0, #2
c0d03b6e:	d01c      	beq.n	c0d03baa <USBD_HID_Setup+0x68>
c0d03b70:	2803      	cmp	r0, #3
c0d03b72:	d01a      	beq.n	c0d03baa <USBD_HID_Setup+0x68>
                        (uint8_t *)&val,
                        1);      
      break;      
      
    default:
      USBD_CtlError (pdev, req);
c0d03b74:	4620      	mov	r0, r4
c0d03b76:	4629      	mov	r1, r5
c0d03b78:	f000 f9a0 	bl	c0d03ebc <USBD_CtlError>
c0d03b7c:	2702      	movs	r7, #2
c0d03b7e:	e029      	b.n	c0d03bd4 <USBD_HID_Setup+0x92>
      return USBD_FAIL; 
    }
    break;
    
  case USB_REQ_TYPE_STANDARD:
    switch (req->bRequest)
c0d03b80:	7868      	ldrb	r0, [r5, #1]
c0d03b82:	280b      	cmp	r0, #11
c0d03b84:	d014      	beq.n	c0d03bb0 <USBD_HID_Setup+0x6e>
c0d03b86:	280a      	cmp	r0, #10
c0d03b88:	d00f      	beq.n	c0d03baa <USBD_HID_Setup+0x68>
c0d03b8a:	2806      	cmp	r0, #6
c0d03b8c:	d122      	bne.n	c0d03bd4 <USBD_HID_Setup+0x92>
    {
    case USB_REQ_GET_DESCRIPTOR: 
      // 0x22
      if( req->wValue >> 8 == HID_REPORT_DESC)
c0d03b8e:	8868      	ldrh	r0, [r5, #2]
c0d03b90:	0a00      	lsrs	r0, r0, #8
c0d03b92:	2700      	movs	r7, #0
c0d03b94:	2821      	cmp	r0, #33	; 0x21
c0d03b96:	d00f      	beq.n	c0d03bb8 <USBD_HID_Setup+0x76>
c0d03b98:	2822      	cmp	r0, #34	; 0x22
      
      //USBD_CtlReceiveStatus(pdev);
      
      USBD_CtlSendData (pdev, 
                        pbuf,
                        len);
c0d03b9a:	463a      	mov	r2, r7
c0d03b9c:	4639      	mov	r1, r7
c0d03b9e:	d116      	bne.n	c0d03bce <USBD_HID_Setup+0x8c>
c0d03ba0:	ae02      	add	r6, sp, #8
    {
    case USB_REQ_GET_DESCRIPTOR: 
      // 0x22
      if( req->wValue >> 8 == HID_REPORT_DESC)
      {
        pbuf =  USBD_HID_GetReportDescriptor_impl(&len);
c0d03ba2:	4630      	mov	r0, r6
c0d03ba4:	f000 f858 	bl	c0d03c58 <USBD_HID_GetReportDescriptor_impl>
c0d03ba8:	e00a      	b.n	c0d03bc0 <USBD_HID_Setup+0x7e>
c0d03baa:	a901      	add	r1, sp, #4
c0d03bac:	2201      	movs	r2, #1
c0d03bae:	e00e      	b.n	c0d03bce <USBD_HID_Setup+0x8c>
                        len);
      break;

    case USB_REQ_SET_INTERFACE :
      //hhid->AltSetting = (uint8_t)(req->wValue);
      USBD_CtlSendStatus(pdev);
c0d03bb0:	4620      	mov	r0, r4
c0d03bb2:	f000 fa30 	bl	c0d04016 <USBD_CtlSendStatus>
c0d03bb6:	e00d      	b.n	c0d03bd4 <USBD_HID_Setup+0x92>
c0d03bb8:	ae02      	add	r6, sp, #8
        len = MIN(len , req->wLength);
      }
      // 0x21
      else if( req->wValue >> 8 == HID_DESCRIPTOR_TYPE)
      {
        pbuf = USBD_HID_GetHidDescriptor_impl(&len);
c0d03bba:	4630      	mov	r0, r6
c0d03bbc:	f000 f832 	bl	c0d03c24 <USBD_HID_GetHidDescriptor_impl>
c0d03bc0:	4601      	mov	r1, r0
c0d03bc2:	8832      	ldrh	r2, [r6, #0]
c0d03bc4:	88e8      	ldrh	r0, [r5, #6]
c0d03bc6:	4282      	cmp	r2, r0
c0d03bc8:	d300      	bcc.n	c0d03bcc <USBD_HID_Setup+0x8a>
c0d03bca:	4602      	mov	r2, r0
c0d03bcc:	8032      	strh	r2, [r6, #0]
c0d03bce:	4620      	mov	r0, r4
c0d03bd0:	f000 f9f6 	bl	c0d03fc0 <USBD_CtlSendData>
      
    }
  }

  return USBD_OK;
}
c0d03bd4:	b2f8      	uxtb	r0, r7
c0d03bd6:	b003      	add	sp, #12
c0d03bd8:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03bda <USBD_HID_Init>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_Init (USBD_HandleTypeDef *pdev, 
                               uint8_t cfgidx)
{
c0d03bda:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03bdc:	b081      	sub	sp, #4
c0d03bde:	4604      	mov	r4, r0
  UNUSED(cfgidx);

  /* Open EP IN */
  USBD_LL_OpenEP(pdev,
c0d03be0:	2182      	movs	r1, #130	; 0x82
c0d03be2:	2603      	movs	r6, #3
c0d03be4:	2540      	movs	r5, #64	; 0x40
c0d03be6:	4632      	mov	r2, r6
c0d03be8:	462b      	mov	r3, r5
c0d03bea:	f7ff fa8b 	bl	c0d03104 <USBD_LL_OpenEP>
c0d03bee:	2702      	movs	r7, #2
                 HID_EPIN_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPIN_SIZE);
  
  /* Open EP OUT */
  USBD_LL_OpenEP(pdev,
c0d03bf0:	4620      	mov	r0, r4
c0d03bf2:	4639      	mov	r1, r7
c0d03bf4:	4632      	mov	r2, r6
c0d03bf6:	462b      	mov	r3, r5
c0d03bf8:	f7ff fa84 	bl	c0d03104 <USBD_LL_OpenEP>
                 HID_EPOUT_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPOUT_SIZE);

        /* Prepare Out endpoint to receive 1st packet */ 
  USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR, HID_EPOUT_SIZE);
c0d03bfc:	4620      	mov	r0, r4
c0d03bfe:	4639      	mov	r1, r7
c0d03c00:	462a      	mov	r2, r5
c0d03c02:	f7ff fb42 	bl	c0d0328a <USBD_LL_PrepareReceive>
  USBD_LL_Transmit (pdev, 
                    HID_EPIN_ADDR,                                      
                    NULL,
                    0);
  */
  return USBD_OK;
c0d03c06:	2000      	movs	r0, #0
c0d03c08:	b001      	add	sp, #4
c0d03c0a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03c0c <USBD_HID_DeInit>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_DeInit (USBD_HandleTypeDef *pdev, 
                                 uint8_t cfgidx)
{
c0d03c0c:	b510      	push	{r4, lr}
c0d03c0e:	4604      	mov	r4, r0
  UNUSED(cfgidx);
  /* Close HID EP IN */
  USBD_LL_CloseEP(pdev,
c0d03c10:	2182      	movs	r1, #130	; 0x82
c0d03c12:	f7ff fa9d 	bl	c0d03150 <USBD_LL_CloseEP>
                  HID_EPIN_ADDR);
  
  /* Close HID EP OUT */
  USBD_LL_CloseEP(pdev,
c0d03c16:	2102      	movs	r1, #2
c0d03c18:	4620      	mov	r0, r4
c0d03c1a:	f7ff fa99 	bl	c0d03150 <USBD_LL_CloseEP>
                  HID_EPOUT_ADDR);
  
  return USBD_OK;
c0d03c1e:	2000      	movs	r0, #0
c0d03c20:	bd10      	pop	{r4, pc}
	...

c0d03c24 <USBD_HID_GetHidDescriptor_impl>:
  *length = sizeof (USBD_CfgDesc);
  return (uint8_t*)USBD_CfgDesc;
}

uint8_t* USBD_HID_GetHidDescriptor_impl(uint16_t* len) {
  switch (USBD_Device.request.wIndex&0xFF) {
c0d03c24:	2143      	movs	r1, #67	; 0x43
c0d03c26:	0089      	lsls	r1, r1, #2
c0d03c28:	4a08      	ldr	r2, [pc, #32]	; (c0d03c4c <USBD_HID_GetHidDescriptor_impl+0x28>)
c0d03c2a:	5c51      	ldrb	r1, [r2, r1]
c0d03c2c:	2209      	movs	r2, #9
c0d03c2e:	2900      	cmp	r1, #0
c0d03c30:	d004      	beq.n	c0d03c3c <USBD_HID_GetHidDescriptor_impl+0x18>
c0d03c32:	2901      	cmp	r1, #1
c0d03c34:	d105      	bne.n	c0d03c42 <USBD_HID_GetHidDescriptor_impl+0x1e>
c0d03c36:	4907      	ldr	r1, [pc, #28]	; (c0d03c54 <USBD_HID_GetHidDescriptor_impl+0x30>)
c0d03c38:	4479      	add	r1, pc
c0d03c3a:	e004      	b.n	c0d03c46 <USBD_HID_GetHidDescriptor_impl+0x22>
c0d03c3c:	4904      	ldr	r1, [pc, #16]	; (c0d03c50 <USBD_HID_GetHidDescriptor_impl+0x2c>)
c0d03c3e:	4479      	add	r1, pc
c0d03c40:	e001      	b.n	c0d03c46 <USBD_HID_GetHidDescriptor_impl+0x22>
c0d03c42:	2200      	movs	r2, #0
c0d03c44:	4611      	mov	r1, r2
c0d03c46:	8002      	strh	r2, [r0, #0]
      *len = sizeof(USBD_HID_Desc);
      return (uint8_t*)USBD_HID_Desc; 
  }
  *len = 0;
  return 0;
}
c0d03c48:	4608      	mov	r0, r1
c0d03c4a:	4770      	bx	lr
c0d03c4c:	20001c8c 	.word	0x20001c8c
c0d03c50:	00000ade 	.word	0x00000ade
c0d03c54:	00000ad8 	.word	0x00000ad8

c0d03c58 <USBD_HID_GetReportDescriptor_impl>:

uint8_t* USBD_HID_GetReportDescriptor_impl(uint16_t* len) {
c0d03c58:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03c5a:	b081      	sub	sp, #4
c0d03c5c:	4602      	mov	r2, r0
  switch (USBD_Device.request.wIndex&0xFF) {
c0d03c5e:	2043      	movs	r0, #67	; 0x43
c0d03c60:	0080      	lsls	r0, r0, #2
c0d03c62:	4914      	ldr	r1, [pc, #80]	; (c0d03cb4 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d03c64:	5c08      	ldrb	r0, [r1, r0]
c0d03c66:	2422      	movs	r4, #34	; 0x22
c0d03c68:	2800      	cmp	r0, #0
c0d03c6a:	d01a      	beq.n	c0d03ca2 <USBD_HID_GetReportDescriptor_impl+0x4a>
c0d03c6c:	2801      	cmp	r0, #1
c0d03c6e:	d11b      	bne.n	c0d03ca8 <USBD_HID_GetReportDescriptor_impl+0x50>
#ifdef HAVE_IO_U2F
  case U2F_INTF:

    // very dirty work due to lack of callback when USB_HID_Init is called
    USBD_LL_OpenEP(&USBD_Device,
c0d03c70:	4810      	ldr	r0, [pc, #64]	; (c0d03cb4 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d03c72:	2181      	movs	r1, #129	; 0x81
c0d03c74:	2703      	movs	r7, #3
c0d03c76:	2640      	movs	r6, #64	; 0x40
c0d03c78:	9200      	str	r2, [sp, #0]
c0d03c7a:	463a      	mov	r2, r7
c0d03c7c:	4633      	mov	r3, r6
c0d03c7e:	f7ff fa41 	bl	c0d03104 <USBD_LL_OpenEP>
c0d03c82:	2501      	movs	r5, #1
                   U2F_EPIN_ADDR,
                   USBD_EP_TYPE_INTR,
                   U2F_EPIN_SIZE);
    
    USBD_LL_OpenEP(&USBD_Device,
c0d03c84:	480b      	ldr	r0, [pc, #44]	; (c0d03cb4 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d03c86:	4629      	mov	r1, r5
c0d03c88:	463a      	mov	r2, r7
c0d03c8a:	4633      	mov	r3, r6
c0d03c8c:	f7ff fa3a 	bl	c0d03104 <USBD_LL_OpenEP>
                   U2F_EPOUT_ADDR,
                   USBD_EP_TYPE_INTR,
                   U2F_EPOUT_SIZE);

    /* Prepare Out endpoint to receive 1st packet */ 
    USBD_LL_PrepareReceive(&USBD_Device, U2F_EPOUT_ADDR, U2F_EPOUT_SIZE);
c0d03c90:	4808      	ldr	r0, [pc, #32]	; (c0d03cb4 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d03c92:	4629      	mov	r1, r5
c0d03c94:	4632      	mov	r2, r6
c0d03c96:	f7ff faf8 	bl	c0d0328a <USBD_LL_PrepareReceive>
c0d03c9a:	9a00      	ldr	r2, [sp, #0]
c0d03c9c:	4807      	ldr	r0, [pc, #28]	; (c0d03cbc <USBD_HID_GetReportDescriptor_impl+0x64>)
c0d03c9e:	4478      	add	r0, pc
c0d03ca0:	e004      	b.n	c0d03cac <USBD_HID_GetReportDescriptor_impl+0x54>
c0d03ca2:	4805      	ldr	r0, [pc, #20]	; (c0d03cb8 <USBD_HID_GetReportDescriptor_impl+0x60>)
c0d03ca4:	4478      	add	r0, pc
c0d03ca6:	e001      	b.n	c0d03cac <USBD_HID_GetReportDescriptor_impl+0x54>
c0d03ca8:	2400      	movs	r4, #0
c0d03caa:	4620      	mov	r0, r4
c0d03cac:	8014      	strh	r4, [r2, #0]
    *len = sizeof(HID_ReportDesc);
    return (uint8_t*)HID_ReportDesc;
  }
  *len = 0;
  return 0;
}
c0d03cae:	b001      	add	sp, #4
c0d03cb0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03cb2:	46c0      	nop			; (mov r8, r8)
c0d03cb4:	20001c8c 	.word	0x20001c8c
c0d03cb8:	00000aa3 	.word	0x00000aa3
c0d03cbc:	00000a87 	.word	0x00000a87

c0d03cc0 <USBD_U2F_Init>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_U2F_Init (USBD_HandleTypeDef *pdev, 
                               uint8_t cfgidx)
{
c0d03cc0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03cc2:	b081      	sub	sp, #4
c0d03cc4:	4604      	mov	r4, r0
  UNUSED(cfgidx);

  /* Open EP IN */
  USBD_LL_OpenEP(pdev,
c0d03cc6:	2181      	movs	r1, #129	; 0x81
c0d03cc8:	2603      	movs	r6, #3
c0d03cca:	2540      	movs	r5, #64	; 0x40
c0d03ccc:	4632      	mov	r2, r6
c0d03cce:	462b      	mov	r3, r5
c0d03cd0:	f7ff fa18 	bl	c0d03104 <USBD_LL_OpenEP>
c0d03cd4:	2701      	movs	r7, #1
                 U2F_EPIN_ADDR,
                 USBD_EP_TYPE_INTR,
                 U2F_EPIN_SIZE);
  
  /* Open EP OUT */
  USBD_LL_OpenEP(pdev,
c0d03cd6:	4620      	mov	r0, r4
c0d03cd8:	4639      	mov	r1, r7
c0d03cda:	4632      	mov	r2, r6
c0d03cdc:	462b      	mov	r3, r5
c0d03cde:	f7ff fa11 	bl	c0d03104 <USBD_LL_OpenEP>
                 U2F_EPOUT_ADDR,
                 USBD_EP_TYPE_INTR,
                 U2F_EPOUT_SIZE);

        /* Prepare Out endpoint to receive 1st packet */ 
  USBD_LL_PrepareReceive(pdev, U2F_EPOUT_ADDR, U2F_EPOUT_SIZE);
c0d03ce2:	4620      	mov	r0, r4
c0d03ce4:	4639      	mov	r1, r7
c0d03ce6:	462a      	mov	r2, r5
c0d03ce8:	f7ff facf 	bl	c0d0328a <USBD_LL_PrepareReceive>

  return USBD_OK;
c0d03cec:	2000      	movs	r0, #0
c0d03cee:	b001      	add	sp, #4
c0d03cf0:	bdf0      	pop	{r4, r5, r6, r7, pc}
	...

c0d03cf4 <USBD_U2F_DataIn_impl>:
}

uint8_t  USBD_U2F_DataIn_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum)
{
c0d03cf4:	b580      	push	{r7, lr}
  UNUSED(pdev);
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d03cf6:	2901      	cmp	r1, #1
c0d03cf8:	d103      	bne.n	c0d03d02 <USBD_U2F_DataIn_impl+0xe>
  // FIDO endpoint
  case (U2F_EPIN_ADDR&0x7F):
    // advance the u2f sending machine state
    u2f_transport_sent(&G_io_u2f, U2F_MEDIA_USB);
c0d03cfa:	4803      	ldr	r0, [pc, #12]	; (c0d03d08 <USBD_U2F_DataIn_impl+0x14>)
c0d03cfc:	2101      	movs	r1, #1
c0d03cfe:	f7fe fc39 	bl	c0d02574 <u2f_transport_sent>
    break;
  } 
  return USBD_OK;
c0d03d02:	2000      	movs	r0, #0
c0d03d04:	bd80      	pop	{r7, pc}
c0d03d06:	46c0      	nop			; (mov r8, r8)
c0d03d08:	20001a7c 	.word	0x20001a7c

c0d03d0c <USBD_U2F_DataOut_impl>:
}

uint8_t  USBD_U2F_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d03d0c:	b5b0      	push	{r4, r5, r7, lr}
c0d03d0e:	4614      	mov	r4, r2
  switch (epnum) {
c0d03d10:	2901      	cmp	r1, #1
c0d03d12:	d10d      	bne.n	c0d03d30 <USBD_U2F_DataOut_impl+0x24>
c0d03d14:	2501      	movs	r5, #1
  // FIDO endpoint
  case (U2F_EPOUT_ADDR&0x7F):
      USBD_LL_PrepareReceive(pdev, U2F_EPOUT_ADDR , U2F_EPOUT_SIZE);
c0d03d16:	2240      	movs	r2, #64	; 0x40
c0d03d18:	4629      	mov	r1, r5
c0d03d1a:	f7ff fab6 	bl	c0d0328a <USBD_LL_PrepareReceive>
      u2f_transport_received(&G_io_u2f, buffer, io_seproxyhal_get_ep_rx_size(U2F_EPOUT_ADDR), U2F_MEDIA_USB);
c0d03d1e:	4628      	mov	r0, r5
c0d03d20:	f7fd f8dc 	bl	c0d00edc <io_seproxyhal_get_ep_rx_size>
c0d03d24:	4602      	mov	r2, r0
c0d03d26:	4803      	ldr	r0, [pc, #12]	; (c0d03d34 <USBD_U2F_DataOut_impl+0x28>)
c0d03d28:	4621      	mov	r1, r4
c0d03d2a:	462b      	mov	r3, r5
c0d03d2c:	f7fe fd5c 	bl	c0d027e8 <u2f_transport_received>
    break;
  }

  return USBD_OK;
c0d03d30:	2000      	movs	r0, #0
c0d03d32:	bdb0      	pop	{r4, r5, r7, pc}
c0d03d34:	20001a7c 	.word	0x20001a7c

c0d03d38 <USBD_HID_DataIn_impl>:
}
#endif // HAVE_IO_U2F

uint8_t  USBD_HID_DataIn_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum)
{
c0d03d38:	b580      	push	{r7, lr}
  UNUSED(pdev);
  switch (epnum) {
c0d03d3a:	2902      	cmp	r1, #2
c0d03d3c:	d103      	bne.n	c0d03d46 <USBD_HID_DataIn_impl+0xe>
    // HID gen endpoint
    case (HID_EPIN_ADDR&0x7F):
      io_usb_hid_sent(io_usb_send_apdu_data);
c0d03d3e:	4803      	ldr	r0, [pc, #12]	; (c0d03d4c <USBD_HID_DataIn_impl+0x14>)
c0d03d40:	4478      	add	r0, pc
c0d03d42:	f7fc ffd9 	bl	c0d00cf8 <io_usb_hid_sent>
      break;
  }

  return USBD_OK;
c0d03d46:	2000      	movs	r0, #0
c0d03d48:	bd80      	pop	{r7, pc}
c0d03d4a:	46c0      	nop			; (mov r8, r8)
c0d03d4c:	ffffd25d 	.word	0xffffd25d

c0d03d50 <USBD_HID_DataOut_impl>:
}

uint8_t  USBD_HID_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d03d50:	b5b0      	push	{r4, r5, r7, lr}
c0d03d52:	4614      	mov	r4, r2
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d03d54:	2902      	cmp	r1, #2
c0d03d56:	d11b      	bne.n	c0d03d90 <USBD_HID_DataOut_impl+0x40>

  // HID gen endpoint
  case (HID_EPOUT_ADDR&0x7F):
    // prepare receiving the next chunk (masked time)
    USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR , HID_EPOUT_SIZE);
c0d03d58:	2102      	movs	r1, #2
c0d03d5a:	2240      	movs	r2, #64	; 0x40
c0d03d5c:	f7ff fa95 	bl	c0d0328a <USBD_LL_PrepareReceive>

    // avoid troubles when an apdu has not been replied yet
    if (G_io_apdu_media == IO_APDU_MEDIA_NONE) {      
c0d03d60:	4d0c      	ldr	r5, [pc, #48]	; (c0d03d94 <USBD_HID_DataOut_impl+0x44>)
c0d03d62:	7828      	ldrb	r0, [r5, #0]
c0d03d64:	2800      	cmp	r0, #0
c0d03d66:	d113      	bne.n	c0d03d90 <USBD_HID_DataOut_impl+0x40>
      // add to the hid transport
      switch(io_usb_hid_receive(io_usb_send_apdu_data, buffer, io_seproxyhal_get_ep_rx_size(HID_EPOUT_ADDR))) {
c0d03d68:	2002      	movs	r0, #2
c0d03d6a:	f7fd f8b7 	bl	c0d00edc <io_seproxyhal_get_ep_rx_size>
c0d03d6e:	4602      	mov	r2, r0
c0d03d70:	480c      	ldr	r0, [pc, #48]	; (c0d03da4 <USBD_HID_DataOut_impl+0x54>)
c0d03d72:	4478      	add	r0, pc
c0d03d74:	4621      	mov	r1, r4
c0d03d76:	f7fc feed 	bl	c0d00b54 <io_usb_hid_receive>
c0d03d7a:	2802      	cmp	r0, #2
c0d03d7c:	d108      	bne.n	c0d03d90 <USBD_HID_DataOut_impl+0x40>
        default:
          break;

        case IO_USB_APDU_RECEIVED:
          G_io_apdu_media = IO_APDU_MEDIA_USB_HID; // for application code
c0d03d7e:	2001      	movs	r0, #1
c0d03d80:	7028      	strb	r0, [r5, #0]
          G_io_apdu_state = APDU_USB_HID; // for next call to io_exchange
c0d03d82:	4805      	ldr	r0, [pc, #20]	; (c0d03d98 <USBD_HID_DataOut_impl+0x48>)
c0d03d84:	2107      	movs	r1, #7
c0d03d86:	7001      	strb	r1, [r0, #0]
          G_io_apdu_length = G_io_usb_hid_total_length;
c0d03d88:	4804      	ldr	r0, [pc, #16]	; (c0d03d9c <USBD_HID_DataOut_impl+0x4c>)
c0d03d8a:	6800      	ldr	r0, [r0, #0]
c0d03d8c:	4904      	ldr	r1, [pc, #16]	; (c0d03da0 <USBD_HID_DataOut_impl+0x50>)
c0d03d8e:	8008      	strh	r0, [r1, #0]
      }
    }
    break;
  }

  return USBD_OK;
c0d03d90:	2000      	movs	r0, #0
c0d03d92:	bdb0      	pop	{r4, r5, r7, pc}
c0d03d94:	20001a54 	.word	0x20001a54
c0d03d98:	20001a6a 	.word	0x20001a6a
c0d03d9c:	200018f0 	.word	0x200018f0
c0d03da0:	20001a6c 	.word	0x20001a6c
c0d03da4:	ffffd22b 	.word	0xffffd22b

c0d03da8 <USBD_WEBUSB_Init>:

#ifdef HAVE_WEBUSB

uint8_t  USBD_WEBUSB_Init (USBD_HandleTypeDef *pdev, 
                               uint8_t cfgidx)
{
c0d03da8:	b570      	push	{r4, r5, r6, lr}
c0d03daa:	4604      	mov	r4, r0
  UNUSED(cfgidx);

  /* Open EP IN */
  USBD_LL_OpenEP(pdev,
c0d03dac:	2183      	movs	r1, #131	; 0x83
c0d03dae:	2503      	movs	r5, #3
c0d03db0:	2640      	movs	r6, #64	; 0x40
c0d03db2:	462a      	mov	r2, r5
c0d03db4:	4633      	mov	r3, r6
c0d03db6:	f7ff f9a5 	bl	c0d03104 <USBD_LL_OpenEP>
                 WEBUSB_EPIN_ADDR,
                 USBD_EP_TYPE_INTR,
                 WEBUSB_EPIN_SIZE);
  
  /* Open EP OUT */
  USBD_LL_OpenEP(pdev,
c0d03dba:	4620      	mov	r0, r4
c0d03dbc:	4629      	mov	r1, r5
c0d03dbe:	462a      	mov	r2, r5
c0d03dc0:	4633      	mov	r3, r6
c0d03dc2:	f7ff f99f 	bl	c0d03104 <USBD_LL_OpenEP>
                 WEBUSB_EPOUT_ADDR,
                 USBD_EP_TYPE_INTR,
                 WEBUSB_EPOUT_SIZE);

        /* Prepare Out endpoint to receive 1st packet */ 
  USBD_LL_PrepareReceive(pdev, WEBUSB_EPOUT_ADDR, WEBUSB_EPOUT_SIZE);
c0d03dc6:	4620      	mov	r0, r4
c0d03dc8:	4629      	mov	r1, r5
c0d03dca:	4632      	mov	r2, r6
c0d03dcc:	f7ff fa5d 	bl	c0d0328a <USBD_LL_PrepareReceive>

  return USBD_OK;
c0d03dd0:	2000      	movs	r0, #0
c0d03dd2:	bd70      	pop	{r4, r5, r6, pc}

c0d03dd4 <USBD_WEBUSB_DeInit>:

uint8_t  USBD_WEBUSB_DeInit (USBD_HandleTypeDef *pdev, 
                                 uint8_t cfgidx) {
  UNUSED(pdev);
  UNUSED(cfgidx);
  return USBD_OK;
c0d03dd4:	2000      	movs	r0, #0
c0d03dd6:	4770      	bx	lr

c0d03dd8 <USBD_WEBUSB_Setup>:
uint8_t  USBD_WEBUSB_Setup (USBD_HandleTypeDef *pdev, 
                                USBD_SetupReqTypedef *req)
{
  UNUSED(pdev);
  UNUSED(req);
  return USBD_OK;
c0d03dd8:	2000      	movs	r0, #0
c0d03dda:	4770      	bx	lr

c0d03ddc <USBD_WEBUSB_DataIn>:
}

uint8_t  USBD_WEBUSB_DataIn (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum)
{
c0d03ddc:	b580      	push	{r7, lr}
  UNUSED(pdev);
  switch (epnum) {
c0d03dde:	2903      	cmp	r1, #3
c0d03de0:	d103      	bne.n	c0d03dea <USBD_WEBUSB_DataIn+0xe>
    // HID gen endpoint
    case (WEBUSB_EPIN_ADDR&0x7F):
      io_usb_hid_sent(io_usb_send_apdu_data_ep0x83);
c0d03de2:	4803      	ldr	r0, [pc, #12]	; (c0d03df0 <USBD_WEBUSB_DataIn+0x14>)
c0d03de4:	4478      	add	r0, pc
c0d03de6:	f7fc ff87 	bl	c0d00cf8 <io_usb_hid_sent>
      break;
  }
  return USBD_OK;
c0d03dea:	2000      	movs	r0, #0
c0d03dec:	bd80      	pop	{r7, pc}
c0d03dee:	46c0      	nop			; (mov r8, r8)
c0d03df0:	ffffd1c9 	.word	0xffffd1c9

c0d03df4 <USBD_WEBUSB_DataOut>:
}

uint8_t USBD_WEBUSB_DataOut (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d03df4:	b5b0      	push	{r4, r5, r7, lr}
c0d03df6:	4614      	mov	r4, r2
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d03df8:	2903      	cmp	r1, #3
c0d03dfa:	d11b      	bne.n	c0d03e34 <USBD_WEBUSB_DataOut+0x40>

  // HID gen endpoint
  case (WEBUSB_EPOUT_ADDR&0x7F):
    // prepare receiving the next chunk (masked time)
    USBD_LL_PrepareReceive(pdev, WEBUSB_EPOUT_ADDR, WEBUSB_EPOUT_SIZE);
c0d03dfc:	2103      	movs	r1, #3
c0d03dfe:	2240      	movs	r2, #64	; 0x40
c0d03e00:	f7ff fa43 	bl	c0d0328a <USBD_LL_PrepareReceive>

    // avoid troubles when an apdu has not been replied yet
    if (G_io_apdu_media == IO_APDU_MEDIA_NONE) {      
c0d03e04:	4d0c      	ldr	r5, [pc, #48]	; (c0d03e38 <USBD_WEBUSB_DataOut+0x44>)
c0d03e06:	7828      	ldrb	r0, [r5, #0]
c0d03e08:	2800      	cmp	r0, #0
c0d03e0a:	d113      	bne.n	c0d03e34 <USBD_WEBUSB_DataOut+0x40>
      // add to the hid transport
      switch(io_usb_hid_receive(io_usb_send_apdu_data_ep0x83, buffer, io_seproxyhal_get_ep_rx_size(WEBUSB_EPOUT_ADDR))) {
c0d03e0c:	2003      	movs	r0, #3
c0d03e0e:	f7fd f865 	bl	c0d00edc <io_seproxyhal_get_ep_rx_size>
c0d03e12:	4602      	mov	r2, r0
c0d03e14:	480c      	ldr	r0, [pc, #48]	; (c0d03e48 <USBD_WEBUSB_DataOut+0x54>)
c0d03e16:	4478      	add	r0, pc
c0d03e18:	4621      	mov	r1, r4
c0d03e1a:	f7fc fe9b 	bl	c0d00b54 <io_usb_hid_receive>
c0d03e1e:	2802      	cmp	r0, #2
c0d03e20:	d108      	bne.n	c0d03e34 <USBD_WEBUSB_DataOut+0x40>
        default:
          break;

        case IO_USB_APDU_RECEIVED:
          G_io_apdu_media = IO_APDU_MEDIA_USB_WEBUSB; // for application code
c0d03e22:	2005      	movs	r0, #5
c0d03e24:	7028      	strb	r0, [r5, #0]
          G_io_apdu_state = APDU_USB_WEBUSB; // for next call to io_exchange
c0d03e26:	4805      	ldr	r0, [pc, #20]	; (c0d03e3c <USBD_WEBUSB_DataOut+0x48>)
c0d03e28:	210b      	movs	r1, #11
c0d03e2a:	7001      	strb	r1, [r0, #0]
          G_io_apdu_length = G_io_usb_hid_total_length;
c0d03e2c:	4804      	ldr	r0, [pc, #16]	; (c0d03e40 <USBD_WEBUSB_DataOut+0x4c>)
c0d03e2e:	6800      	ldr	r0, [r0, #0]
c0d03e30:	4904      	ldr	r1, [pc, #16]	; (c0d03e44 <USBD_WEBUSB_DataOut+0x50>)
c0d03e32:	8008      	strh	r0, [r1, #0]
      }
    }
    break;
  }

  return USBD_OK;
c0d03e34:	2000      	movs	r0, #0
c0d03e36:	bdb0      	pop	{r4, r5, r7, pc}
c0d03e38:	20001a54 	.word	0x20001a54
c0d03e3c:	20001a6a 	.word	0x20001a6a
c0d03e40:	200018f0 	.word	0x200018f0
c0d03e44:	20001a6c 	.word	0x20001a6c
c0d03e48:	ffffd197 	.word	0xffffd197

c0d03e4c <USBD_DeviceDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_DeviceDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_DeviceDesc);
c0d03e4c:	2012      	movs	r0, #18
c0d03e4e:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_DeviceDesc;
c0d03e50:	4801      	ldr	r0, [pc, #4]	; (c0d03e58 <USBD_DeviceDescriptor+0xc>)
c0d03e52:	4478      	add	r0, pc
c0d03e54:	4770      	bx	lr
c0d03e56:	46c0      	nop			; (mov r8, r8)
c0d03e58:	00000a16 	.word	0x00000a16

c0d03e5c <USBD_LangIDStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_LangIDStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_LangIDDesc);  
c0d03e5c:	2004      	movs	r0, #4
c0d03e5e:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_LangIDDesc;
c0d03e60:	4801      	ldr	r0, [pc, #4]	; (c0d03e68 <USBD_LangIDStrDescriptor+0xc>)
c0d03e62:	4478      	add	r0, pc
c0d03e64:	4770      	bx	lr
c0d03e66:	46c0      	nop			; (mov r8, r8)
c0d03e68:	00000a18 	.word	0x00000a18

c0d03e6c <USBD_ManufacturerStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ManufacturerStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_MANUFACTURER_STRING);
c0d03e6c:	200e      	movs	r0, #14
c0d03e6e:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_MANUFACTURER_STRING;
c0d03e70:	4801      	ldr	r0, [pc, #4]	; (c0d03e78 <USBD_ManufacturerStrDescriptor+0xc>)
c0d03e72:	4478      	add	r0, pc
c0d03e74:	4770      	bx	lr
c0d03e76:	46c0      	nop			; (mov r8, r8)
c0d03e78:	00000a0c 	.word	0x00000a0c

c0d03e7c <USBD_ProductStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ProductStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_PRODUCT_FS_STRING);
c0d03e7c:	200e      	movs	r0, #14
c0d03e7e:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_PRODUCT_FS_STRING;
c0d03e80:	4801      	ldr	r0, [pc, #4]	; (c0d03e88 <USBD_ProductStrDescriptor+0xc>)
c0d03e82:	4478      	add	r0, pc
c0d03e84:	4770      	bx	lr
c0d03e86:	46c0      	nop			; (mov r8, r8)
c0d03e88:	00000a0a 	.word	0x00000a0a

c0d03e8c <USBD_SerialStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_SerialStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USB_SERIAL_STRING);
c0d03e8c:	200a      	movs	r0, #10
c0d03e8e:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USB_SERIAL_STRING;
c0d03e90:	4801      	ldr	r0, [pc, #4]	; (c0d03e98 <USBD_SerialStrDescriptor+0xc>)
c0d03e92:	4478      	add	r0, pc
c0d03e94:	4770      	bx	lr
c0d03e96:	46c0      	nop			; (mov r8, r8)
c0d03e98:	00000a08 	.word	0x00000a08

c0d03e9c <USBD_ConfigStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ConfigStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_CONFIGURATION_FS_STRING);
c0d03e9c:	200e      	movs	r0, #14
c0d03e9e:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_CONFIGURATION_FS_STRING;
c0d03ea0:	4801      	ldr	r0, [pc, #4]	; (c0d03ea8 <USBD_ConfigStrDescriptor+0xc>)
c0d03ea2:	4478      	add	r0, pc
c0d03ea4:	4770      	bx	lr
c0d03ea6:	46c0      	nop			; (mov r8, r8)
c0d03ea8:	000009ea 	.word	0x000009ea

c0d03eac <USBD_InterfaceStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_InterfaceStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_INTERFACE_FS_STRING);
c0d03eac:	200e      	movs	r0, #14
c0d03eae:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_INTERFACE_FS_STRING;
c0d03eb0:	4801      	ldr	r0, [pc, #4]	; (c0d03eb8 <USBD_InterfaceStrDescriptor+0xc>)
c0d03eb2:	4478      	add	r0, pc
c0d03eb4:	4770      	bx	lr
c0d03eb6:	46c0      	nop			; (mov r8, r8)
c0d03eb8:	000009da 	.word	0x000009da

c0d03ebc <USBD_CtlError>:
  WEBUSB_VENDOR_CODE, // bVencordCode
  1 // iLanding
};

// upon unsupported request, check for webusb request
void USBD_CtlError( USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef *req) {
c0d03ebc:	b580      	push	{r7, lr}
  if ((req->bmRequest & 0x80) && req->bRequest == WEBUSB_VENDOR_CODE && req->wIndex == WEBUSB_REQ_GET_URL
c0d03ebe:	780a      	ldrb	r2, [r1, #0]
c0d03ec0:	b252      	sxtb	r2, r2
c0d03ec2:	2a00      	cmp	r2, #0
c0d03ec4:	db02      	blt.n	c0d03ecc <USBD_CtlError+0x10>
  }
  else if ((req->bmRequest & 0x80) && req->bRequest == USB_REQ_GET_DESCRIPTOR && (req->wValue>>8) == USB_DT_BOS) {
    USBD_CtlSendData(pdev, (unsigned char*)C_usb_bos, sizeof(C_usb_bos));
  }
  else {
    USBD_CtlStall(pdev);
c0d03ec6:	f7ff fe32 	bl	c0d03b2e <USBD_CtlStall>
  }
}
c0d03eca:	bd80      	pop	{r7, pc}
  1 // iLanding
};

// upon unsupported request, check for webusb request
void USBD_CtlError( USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef *req) {
  if ((req->bmRequest & 0x80) && req->bRequest == WEBUSB_VENDOR_CODE && req->wIndex == WEBUSB_REQ_GET_URL
c0d03ecc:	784a      	ldrb	r2, [r1, #1]
c0d03ece:	2a06      	cmp	r2, #6
c0d03ed0:	d00d      	beq.n	c0d03eee <USBD_CtlError+0x32>
c0d03ed2:	2a1e      	cmp	r2, #30
c0d03ed4:	d1f7      	bne.n	c0d03ec6 <USBD_CtlError+0xa>
c0d03ed6:	888a      	ldrh	r2, [r1, #4]
    // HTTPS url
    && req->wValue == 1) {
c0d03ed8:	2a02      	cmp	r2, #2
c0d03eda:	d1f4      	bne.n	c0d03ec6 <USBD_CtlError+0xa>
c0d03edc:	8849      	ldrh	r1, [r1, #2]
  1 // iLanding
};

// upon unsupported request, check for webusb request
void USBD_CtlError( USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef *req) {
  if ((req->bmRequest & 0x80) && req->bRequest == WEBUSB_VENDOR_CODE && req->wIndex == WEBUSB_REQ_GET_URL
c0d03ede:	2901      	cmp	r1, #1
c0d03ee0:	d1f1      	bne.n	c0d03ec6 <USBD_CtlError+0xa>
    // HTTPS url
    && req->wValue == 1) {
    // return the URL descriptor
    USBD_CtlSendData (pdev, (unsigned char*)C_webusb_url_descriptor, sizeof(C_webusb_url_descriptor));
c0d03ee2:	4907      	ldr	r1, [pc, #28]	; (c0d03f00 <USBD_CtlError+0x44>)
c0d03ee4:	4479      	add	r1, pc
c0d03ee6:	2217      	movs	r2, #23
c0d03ee8:	f000 f86a 	bl	c0d03fc0 <USBD_CtlSendData>
    USBD_CtlSendData(pdev, (unsigned char*)C_usb_bos, sizeof(C_usb_bos));
  }
  else {
    USBD_CtlStall(pdev);
  }
}
c0d03eec:	bd80      	pop	{r7, pc}
    // HTTPS url
    && req->wValue == 1) {
    // return the URL descriptor
    USBD_CtlSendData (pdev, (unsigned char*)C_webusb_url_descriptor, sizeof(C_webusb_url_descriptor));
  }
  else if ((req->bmRequest & 0x80) && req->bRequest == USB_REQ_GET_DESCRIPTOR && (req->wValue>>8) == USB_DT_BOS) {
c0d03eee:	78c9      	ldrb	r1, [r1, #3]
c0d03ef0:	290f      	cmp	r1, #15
c0d03ef2:	d1e8      	bne.n	c0d03ec6 <USBD_CtlError+0xa>
    USBD_CtlSendData(pdev, (unsigned char*)C_usb_bos, sizeof(C_usb_bos));
c0d03ef4:	4903      	ldr	r1, [pc, #12]	; (c0d03f04 <USBD_CtlError+0x48>)
c0d03ef6:	4479      	add	r1, pc
c0d03ef8:	221d      	movs	r2, #29
c0d03efa:	f000 f861 	bl	c0d03fc0 <USBD_CtlSendData>
  }
  else {
    USBD_CtlStall(pdev);
  }
}
c0d03efe:	bd80      	pop	{r7, pc}
c0d03f00:	000008a8 	.word	0x000008a8
c0d03f04:	000008ad 	.word	0x000008ad

c0d03f08 <USB_power>:
  // nothing to do ?
  return 0;
}
#endif // HAVE_USB_CLASS_CCID

void USB_power(unsigned char enabled) {
c0d03f08:	b570      	push	{r4, r5, r6, lr}
c0d03f0a:	4604      	mov	r4, r0
c0d03f0c:	204d      	movs	r0, #77	; 0x4d
c0d03f0e:	0085      	lsls	r5, r0, #2
  os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d03f10:	481c      	ldr	r0, [pc, #112]	; (c0d03f84 <USB_power+0x7c>)
c0d03f12:	2100      	movs	r1, #0
c0d03f14:	462a      	mov	r2, r5
c0d03f16:	f7fc fec5 	bl	c0d00ca4 <os_memset>

  if (enabled) {
c0d03f1a:	2c00      	cmp	r4, #0
c0d03f1c:	d02d      	beq.n	c0d03f7a <USB_power+0x72>
    os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d03f1e:	4c19      	ldr	r4, [pc, #100]	; (c0d03f84 <USB_power+0x7c>)
c0d03f20:	2600      	movs	r6, #0
c0d03f22:	4620      	mov	r0, r4
c0d03f24:	4631      	mov	r1, r6
c0d03f26:	462a      	mov	r2, r5
c0d03f28:	f7fc febc 	bl	c0d00ca4 <os_memset>
    /* Init Device Library */
    USBD_Init(&USBD_Device, (USBD_DescriptorsTypeDef*)&HID_Desc, 0);
c0d03f2c:	4918      	ldr	r1, [pc, #96]	; (c0d03f90 <USB_power+0x88>)
c0d03f2e:	4479      	add	r1, pc
c0d03f30:	4620      	mov	r0, r4
c0d03f32:	4632      	mov	r2, r6
c0d03f34:	f7ff f9bc 	bl	c0d032b0 <USBD_Init>
    
    /* Register the HID class */
    USBD_RegisterClassForInterface(HID_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_HID);
c0d03f38:	4a16      	ldr	r2, [pc, #88]	; (c0d03f94 <USB_power+0x8c>)
c0d03f3a:	447a      	add	r2, pc
c0d03f3c:	4630      	mov	r0, r6
c0d03f3e:	4621      	mov	r1, r4
c0d03f40:	f7ff f9f0 	bl	c0d03324 <USBD_RegisterClassForInterface>
#ifdef HAVE_IO_U2F
    USBD_RegisterClassForInterface(U2F_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_U2F);
c0d03f44:	2001      	movs	r0, #1
c0d03f46:	4a14      	ldr	r2, [pc, #80]	; (c0d03f98 <USB_power+0x90>)
c0d03f48:	447a      	add	r2, pc
c0d03f4a:	4621      	mov	r1, r4
c0d03f4c:	f7ff f9ea 	bl	c0d03324 <USBD_RegisterClassForInterface>
    // initialize the U2F tunnel transport
    u2f_transport_init(&G_io_u2f, G_io_apdu_buffer, IO_APDU_BUFFER_SIZE);
c0d03f50:	22ff      	movs	r2, #255	; 0xff
c0d03f52:	3252      	adds	r2, #82	; 0x52
c0d03f54:	480c      	ldr	r0, [pc, #48]	; (c0d03f88 <USB_power+0x80>)
c0d03f56:	490d      	ldr	r1, [pc, #52]	; (c0d03f8c <USB_power+0x84>)
c0d03f58:	f7fe fafe 	bl	c0d02558 <u2f_transport_init>
#ifdef HAVE_USB_CLASS_CCID
    USBD_RegisterClassForInterface(CCID_INTF, &USBD_Device, (USBD_ClassTypeDef*)&USBD_CCID);
#endif // HAVE_USB_CLASS_CCID

#ifdef HAVE_WEBUSB
    USBD_RegisterClassForInterface(WEBUSB_INTF, &USBD_Device, (USBD_ClassTypeDef*)&USBD_WEBUSB);
c0d03f5c:	2002      	movs	r0, #2
c0d03f5e:	4a0f      	ldr	r2, [pc, #60]	; (c0d03f9c <USB_power+0x94>)
c0d03f60:	447a      	add	r2, pc
c0d03f62:	4621      	mov	r1, r4
c0d03f64:	f7ff f9de 	bl	c0d03324 <USBD_RegisterClassForInterface>
    USBD_LL_PrepareReceive(&USBD_Device, WEBUSB_EPOUT_ADDR , WEBUSB_EPOUT_SIZE);
c0d03f68:	2103      	movs	r1, #3
c0d03f6a:	2240      	movs	r2, #64	; 0x40
c0d03f6c:	4620      	mov	r0, r4
c0d03f6e:	f7ff f98c 	bl	c0d0328a <USBD_LL_PrepareReceive>
#endif // HAVE_WEBUSB

    /* Start Device Process */
    USBD_Start(&USBD_Device);
c0d03f72:	4620      	mov	r0, r4
c0d03f74:	f7ff f9e3 	bl	c0d0333e <USBD_Start>
  }
  else {
    USBD_DeInit(&USBD_Device);
  }
}
c0d03f78:	bd70      	pop	{r4, r5, r6, pc}

    /* Start Device Process */
    USBD_Start(&USBD_Device);
  }
  else {
    USBD_DeInit(&USBD_Device);
c0d03f7a:	4802      	ldr	r0, [pc, #8]	; (c0d03f84 <USB_power+0x7c>)
c0d03f7c:	f7ff f9b3 	bl	c0d032e6 <USBD_DeInit>
  }
}
c0d03f80:	bd70      	pop	{r4, r5, r6, pc}
c0d03f82:	46c0      	nop			; (mov r8, r8)
c0d03f84:	20001c8c 	.word	0x20001c8c
c0d03f88:	20001a7c 	.word	0x20001a7c
c0d03f8c:	200018f8 	.word	0x200018f8
c0d03f90:	0000083e 	.word	0x0000083e
c0d03f94:	00000886 	.word	0x00000886
c0d03f98:	000008b0 	.word	0x000008b0
c0d03f9c:	000008d0 	.word	0x000008d0

c0d03fa0 <USBD_GetCfgDesc_impl>:
  * @param  length : pointer data length
  * @retval pointer to descriptor buffer
  */
static uint8_t  *USBD_GetCfgDesc_impl (uint16_t *length)
{
  *length = sizeof (USBD_CfgDesc);
c0d03fa0:	2160      	movs	r1, #96	; 0x60
c0d03fa2:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_CfgDesc;
c0d03fa4:	4801      	ldr	r0, [pc, #4]	; (c0d03fac <USBD_GetCfgDesc_impl+0xc>)
c0d03fa6:	4478      	add	r0, pc
c0d03fa8:	4770      	bx	lr
c0d03faa:	46c0      	nop			; (mov r8, r8)
c0d03fac:	000008fe 	.word	0x000008fe

c0d03fb0 <USBD_GetDeviceQualifierDesc_impl>:
* @param  length : pointer data length
* @retval pointer to descriptor buffer
*/
static uint8_t  *USBD_GetDeviceQualifierDesc_impl (uint16_t *length)
{
  *length = sizeof (USBD_DeviceQualifierDesc);
c0d03fb0:	210a      	movs	r1, #10
c0d03fb2:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_DeviceQualifierDesc;
c0d03fb4:	4801      	ldr	r0, [pc, #4]	; (c0d03fbc <USBD_GetDeviceQualifierDesc_impl+0xc>)
c0d03fb6:	4478      	add	r0, pc
c0d03fb8:	4770      	bx	lr
c0d03fba:	46c0      	nop			; (mov r8, r8)
c0d03fbc:	0000094e 	.word	0x0000094e

c0d03fc0 <USBD_CtlSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendData (USBD_HandleTypeDef  *pdev, 
                               uint8_t *pbuf,
                               uint16_t len)
{
c0d03fc0:	b5b0      	push	{r4, r5, r7, lr}
c0d03fc2:	460c      	mov	r4, r1
  /* Set EP0 State */
  pdev->ep0_state          = USBD_EP0_DATA_IN;                                      
c0d03fc4:	21f4      	movs	r1, #244	; 0xf4
c0d03fc6:	2302      	movs	r3, #2
c0d03fc8:	5043      	str	r3, [r0, r1]
  pdev->ep_in[0].total_length = len;
c0d03fca:	6182      	str	r2, [r0, #24]
  pdev->ep_in[0].rem_length   = len;
c0d03fcc:	61c2      	str	r2, [r0, #28]
  // store the continuation data if needed
  pdev->pData = pbuf;
c0d03fce:	2113      	movs	r1, #19
c0d03fd0:	0109      	lsls	r1, r1, #4
c0d03fd2:	5044      	str	r4, [r0, r1]
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));  
c0d03fd4:	6a01      	ldr	r1, [r0, #32]
c0d03fd6:	428a      	cmp	r2, r1
c0d03fd8:	d300      	bcc.n	c0d03fdc <USBD_CtlSendData+0x1c>
c0d03fda:	460a      	mov	r2, r1
c0d03fdc:	b293      	uxth	r3, r2
c0d03fde:	2500      	movs	r5, #0
c0d03fe0:	4629      	mov	r1, r5
c0d03fe2:	4622      	mov	r2, r4
c0d03fe4:	f7ff f938 	bl	c0d03258 <USBD_LL_Transmit>
  
  return USBD_OK;
c0d03fe8:	4628      	mov	r0, r5
c0d03fea:	bdb0      	pop	{r4, r5, r7, pc}

c0d03fec <USBD_CtlContinueSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueSendData (USBD_HandleTypeDef  *pdev, 
                                       uint8_t *pbuf,
                                       uint16_t len)
{
c0d03fec:	b5b0      	push	{r4, r5, r7, lr}
c0d03fee:	460c      	mov	r4, r1
 /* Start the next transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));   
c0d03ff0:	6a01      	ldr	r1, [r0, #32]
c0d03ff2:	428a      	cmp	r2, r1
c0d03ff4:	d300      	bcc.n	c0d03ff8 <USBD_CtlContinueSendData+0xc>
c0d03ff6:	460a      	mov	r2, r1
c0d03ff8:	b293      	uxth	r3, r2
c0d03ffa:	2500      	movs	r5, #0
c0d03ffc:	4629      	mov	r1, r5
c0d03ffe:	4622      	mov	r2, r4
c0d04000:	f7ff f92a 	bl	c0d03258 <USBD_LL_Transmit>
  return USBD_OK;
c0d04004:	4628      	mov	r0, r5
c0d04006:	bdb0      	pop	{r4, r5, r7, pc}

c0d04008 <USBD_CtlContinueRx>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueRx (USBD_HandleTypeDef  *pdev, 
                                          uint8_t *pbuf,                                          
                                          uint16_t len)
{
c0d04008:	b510      	push	{r4, lr}
c0d0400a:	2400      	movs	r4, #0
  UNUSED(pbuf);
  USBD_LL_PrepareReceive (pdev,
c0d0400c:	4621      	mov	r1, r4
c0d0400e:	f7ff f93c 	bl	c0d0328a <USBD_LL_PrepareReceive>
                          0,                                            
                          len);
  return USBD_OK;
c0d04012:	4620      	mov	r0, r4
c0d04014:	bd10      	pop	{r4, pc}

c0d04016 <USBD_CtlSendStatus>:
*         send zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendStatus (USBD_HandleTypeDef  *pdev)
{
c0d04016:	b510      	push	{r4, lr}

  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_IN;
c0d04018:	21f4      	movs	r1, #244	; 0xf4
c0d0401a:	2204      	movs	r2, #4
c0d0401c:	5042      	str	r2, [r0, r1]
c0d0401e:	2400      	movs	r4, #0
  
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, NULL, 0);   
c0d04020:	4621      	mov	r1, r4
c0d04022:	4622      	mov	r2, r4
c0d04024:	4623      	mov	r3, r4
c0d04026:	f7ff f917 	bl	c0d03258 <USBD_LL_Transmit>
  
  return USBD_OK;
c0d0402a:	4620      	mov	r0, r4
c0d0402c:	bd10      	pop	{r4, pc}

c0d0402e <USBD_CtlReceiveStatus>:
*         receive zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlReceiveStatus (USBD_HandleTypeDef  *pdev)
{
c0d0402e:	b510      	push	{r4, lr}
  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_OUT; 
c0d04030:	21f4      	movs	r1, #244	; 0xf4
c0d04032:	2205      	movs	r2, #5
c0d04034:	5042      	str	r2, [r0, r1]
c0d04036:	2400      	movs	r4, #0
  
 /* Start the transfer */  
  USBD_LL_PrepareReceive ( pdev,
c0d04038:	4621      	mov	r1, r4
c0d0403a:	4622      	mov	r2, r4
c0d0403c:	f7ff f925 	bl	c0d0328a <USBD_LL_PrepareReceive>
                    0,
                    0);  

  return USBD_OK;
c0d04040:	4620      	mov	r0, r4
c0d04042:	bd10      	pop	{r4, pc}

c0d04044 <hex_to_str>:
# include "utils.h"

//字节流转换为十六进制字符串的另一种实现方式
void hex_to_str( const unsigned char* source, char* dest, int sourceLen )
{
c0d04044:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04046:	b081      	sub	sp, #4
c0d04048:	9000      	str	r0, [sp, #0]
    short i;
    unsigned char highByte, lowByte;


    for (i = 0; i < sourceLen; i++)
c0d0404a:	2a01      	cmp	r2, #1
c0d0404c:	db1a      	blt.n	c0d04084 <hex_to_str+0x40>
c0d0404e:	2400      	movs	r4, #0
c0d04050:	4623      	mov	r3, r4
    {
        highByte = source[i] >> 4;
c0d04052:	9800      	ldr	r0, [sp, #0]
c0d04054:	5d05      	ldrb	r5, [r0, r4]
c0d04056:	092f      	lsrs	r7, r5, #4
        lowByte = source[i] & 0x0f ;


        highByte += 0x30;
c0d04058:	2030      	movs	r0, #48	; 0x30
c0d0405a:	4307      	orrs	r7, r0


        if (highByte > 0x39)
                dest[i * 2] = highByte + 0x07;
c0d0405c:	1dfe      	adds	r6, r7, #7


        highByte += 0x30;


        if (highByte > 0x39)
c0d0405e:	2f39      	cmp	r7, #57	; 0x39
c0d04060:	d800      	bhi.n	c0d04064 <hex_to_str+0x20>
c0d04062:	463e      	mov	r6, r7
c0d04064:	0064      	lsls	r4, r4, #1
c0d04066:	550e      	strb	r6, [r1, r4]


    for (i = 0; i < sourceLen; i++)
    {
        highByte = source[i] >> 4;
        lowByte = source[i] & 0x0f ;
c0d04068:	260f      	movs	r6, #15
c0d0406a:	4035      	ands	r5, r6
                dest[i * 2] = highByte + 0x07;
        else
                dest[i * 2] = highByte;


        lowByte += 0x30;
c0d0406c:	4305      	orrs	r5, r0
        if (lowByte > 0x39)
            dest[i * 2 + 1] = lowByte + 0x07;
c0d0406e:	1dee      	adds	r6, r5, #7
        else
                dest[i * 2] = highByte;


        lowByte += 0x30;
        if (lowByte > 0x39)
c0d04070:	2d39      	cmp	r5, #57	; 0x39
c0d04072:	d800      	bhi.n	c0d04076 <hex_to_str+0x32>
c0d04074:	462e      	mov	r6, r5
c0d04076:	2001      	movs	r0, #1
c0d04078:	4304      	orrs	r4, r0
c0d0407a:	550e      	strb	r6, [r1, r4]
{
    short i;
    unsigned char highByte, lowByte;


    for (i = 0; i < sourceLen; i++)
c0d0407c:	1c5b      	adds	r3, r3, #1
c0d0407e:	b21c      	sxth	r4, r3
c0d04080:	4294      	cmp	r4, r2
c0d04082:	dbe6      	blt.n	c0d04052 <hex_to_str+0xe>
            dest[i * 2 + 1] = lowByte + 0x07;
        else
            dest[i * 2 + 1] = lowByte;
    }
    return ;
c0d04084:	b001      	add	sp, #4
c0d04086:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d04088 <__aeabi_uidiv>:
c0d04088:	2200      	movs	r2, #0
c0d0408a:	0843      	lsrs	r3, r0, #1
c0d0408c:	428b      	cmp	r3, r1
c0d0408e:	d374      	bcc.n	c0d0417a <__aeabi_uidiv+0xf2>
c0d04090:	0903      	lsrs	r3, r0, #4
c0d04092:	428b      	cmp	r3, r1
c0d04094:	d35f      	bcc.n	c0d04156 <__aeabi_uidiv+0xce>
c0d04096:	0a03      	lsrs	r3, r0, #8
c0d04098:	428b      	cmp	r3, r1
c0d0409a:	d344      	bcc.n	c0d04126 <__aeabi_uidiv+0x9e>
c0d0409c:	0b03      	lsrs	r3, r0, #12
c0d0409e:	428b      	cmp	r3, r1
c0d040a0:	d328      	bcc.n	c0d040f4 <__aeabi_uidiv+0x6c>
c0d040a2:	0c03      	lsrs	r3, r0, #16
c0d040a4:	428b      	cmp	r3, r1
c0d040a6:	d30d      	bcc.n	c0d040c4 <__aeabi_uidiv+0x3c>
c0d040a8:	22ff      	movs	r2, #255	; 0xff
c0d040aa:	0209      	lsls	r1, r1, #8
c0d040ac:	ba12      	rev	r2, r2
c0d040ae:	0c03      	lsrs	r3, r0, #16
c0d040b0:	428b      	cmp	r3, r1
c0d040b2:	d302      	bcc.n	c0d040ba <__aeabi_uidiv+0x32>
c0d040b4:	1212      	asrs	r2, r2, #8
c0d040b6:	0209      	lsls	r1, r1, #8
c0d040b8:	d065      	beq.n	c0d04186 <__aeabi_uidiv+0xfe>
c0d040ba:	0b03      	lsrs	r3, r0, #12
c0d040bc:	428b      	cmp	r3, r1
c0d040be:	d319      	bcc.n	c0d040f4 <__aeabi_uidiv+0x6c>
c0d040c0:	e000      	b.n	c0d040c4 <__aeabi_uidiv+0x3c>
c0d040c2:	0a09      	lsrs	r1, r1, #8
c0d040c4:	0bc3      	lsrs	r3, r0, #15
c0d040c6:	428b      	cmp	r3, r1
c0d040c8:	d301      	bcc.n	c0d040ce <__aeabi_uidiv+0x46>
c0d040ca:	03cb      	lsls	r3, r1, #15
c0d040cc:	1ac0      	subs	r0, r0, r3
c0d040ce:	4152      	adcs	r2, r2
c0d040d0:	0b83      	lsrs	r3, r0, #14
c0d040d2:	428b      	cmp	r3, r1
c0d040d4:	d301      	bcc.n	c0d040da <__aeabi_uidiv+0x52>
c0d040d6:	038b      	lsls	r3, r1, #14
c0d040d8:	1ac0      	subs	r0, r0, r3
c0d040da:	4152      	adcs	r2, r2
c0d040dc:	0b43      	lsrs	r3, r0, #13
c0d040de:	428b      	cmp	r3, r1
c0d040e0:	d301      	bcc.n	c0d040e6 <__aeabi_uidiv+0x5e>
c0d040e2:	034b      	lsls	r3, r1, #13
c0d040e4:	1ac0      	subs	r0, r0, r3
c0d040e6:	4152      	adcs	r2, r2
c0d040e8:	0b03      	lsrs	r3, r0, #12
c0d040ea:	428b      	cmp	r3, r1
c0d040ec:	d301      	bcc.n	c0d040f2 <__aeabi_uidiv+0x6a>
c0d040ee:	030b      	lsls	r3, r1, #12
c0d040f0:	1ac0      	subs	r0, r0, r3
c0d040f2:	4152      	adcs	r2, r2
c0d040f4:	0ac3      	lsrs	r3, r0, #11
c0d040f6:	428b      	cmp	r3, r1
c0d040f8:	d301      	bcc.n	c0d040fe <__aeabi_uidiv+0x76>
c0d040fa:	02cb      	lsls	r3, r1, #11
c0d040fc:	1ac0      	subs	r0, r0, r3
c0d040fe:	4152      	adcs	r2, r2
c0d04100:	0a83      	lsrs	r3, r0, #10
c0d04102:	428b      	cmp	r3, r1
c0d04104:	d301      	bcc.n	c0d0410a <__aeabi_uidiv+0x82>
c0d04106:	028b      	lsls	r3, r1, #10
c0d04108:	1ac0      	subs	r0, r0, r3
c0d0410a:	4152      	adcs	r2, r2
c0d0410c:	0a43      	lsrs	r3, r0, #9
c0d0410e:	428b      	cmp	r3, r1
c0d04110:	d301      	bcc.n	c0d04116 <__aeabi_uidiv+0x8e>
c0d04112:	024b      	lsls	r3, r1, #9
c0d04114:	1ac0      	subs	r0, r0, r3
c0d04116:	4152      	adcs	r2, r2
c0d04118:	0a03      	lsrs	r3, r0, #8
c0d0411a:	428b      	cmp	r3, r1
c0d0411c:	d301      	bcc.n	c0d04122 <__aeabi_uidiv+0x9a>
c0d0411e:	020b      	lsls	r3, r1, #8
c0d04120:	1ac0      	subs	r0, r0, r3
c0d04122:	4152      	adcs	r2, r2
c0d04124:	d2cd      	bcs.n	c0d040c2 <__aeabi_uidiv+0x3a>
c0d04126:	09c3      	lsrs	r3, r0, #7
c0d04128:	428b      	cmp	r3, r1
c0d0412a:	d301      	bcc.n	c0d04130 <__aeabi_uidiv+0xa8>
c0d0412c:	01cb      	lsls	r3, r1, #7
c0d0412e:	1ac0      	subs	r0, r0, r3
c0d04130:	4152      	adcs	r2, r2
c0d04132:	0983      	lsrs	r3, r0, #6
c0d04134:	428b      	cmp	r3, r1
c0d04136:	d301      	bcc.n	c0d0413c <__aeabi_uidiv+0xb4>
c0d04138:	018b      	lsls	r3, r1, #6
c0d0413a:	1ac0      	subs	r0, r0, r3
c0d0413c:	4152      	adcs	r2, r2
c0d0413e:	0943      	lsrs	r3, r0, #5
c0d04140:	428b      	cmp	r3, r1
c0d04142:	d301      	bcc.n	c0d04148 <__aeabi_uidiv+0xc0>
c0d04144:	014b      	lsls	r3, r1, #5
c0d04146:	1ac0      	subs	r0, r0, r3
c0d04148:	4152      	adcs	r2, r2
c0d0414a:	0903      	lsrs	r3, r0, #4
c0d0414c:	428b      	cmp	r3, r1
c0d0414e:	d301      	bcc.n	c0d04154 <__aeabi_uidiv+0xcc>
c0d04150:	010b      	lsls	r3, r1, #4
c0d04152:	1ac0      	subs	r0, r0, r3
c0d04154:	4152      	adcs	r2, r2
c0d04156:	08c3      	lsrs	r3, r0, #3
c0d04158:	428b      	cmp	r3, r1
c0d0415a:	d301      	bcc.n	c0d04160 <__aeabi_uidiv+0xd8>
c0d0415c:	00cb      	lsls	r3, r1, #3
c0d0415e:	1ac0      	subs	r0, r0, r3
c0d04160:	4152      	adcs	r2, r2
c0d04162:	0883      	lsrs	r3, r0, #2
c0d04164:	428b      	cmp	r3, r1
c0d04166:	d301      	bcc.n	c0d0416c <__aeabi_uidiv+0xe4>
c0d04168:	008b      	lsls	r3, r1, #2
c0d0416a:	1ac0      	subs	r0, r0, r3
c0d0416c:	4152      	adcs	r2, r2
c0d0416e:	0843      	lsrs	r3, r0, #1
c0d04170:	428b      	cmp	r3, r1
c0d04172:	d301      	bcc.n	c0d04178 <__aeabi_uidiv+0xf0>
c0d04174:	004b      	lsls	r3, r1, #1
c0d04176:	1ac0      	subs	r0, r0, r3
c0d04178:	4152      	adcs	r2, r2
c0d0417a:	1a41      	subs	r1, r0, r1
c0d0417c:	d200      	bcs.n	c0d04180 <__aeabi_uidiv+0xf8>
c0d0417e:	4601      	mov	r1, r0
c0d04180:	4152      	adcs	r2, r2
c0d04182:	4610      	mov	r0, r2
c0d04184:	4770      	bx	lr
c0d04186:	e7ff      	b.n	c0d04188 <__aeabi_uidiv+0x100>
c0d04188:	b501      	push	{r0, lr}
c0d0418a:	2000      	movs	r0, #0
c0d0418c:	f000 f806 	bl	c0d0419c <__aeabi_idiv0>
c0d04190:	bd02      	pop	{r1, pc}
c0d04192:	46c0      	nop			; (mov r8, r8)

c0d04194 <__aeabi_uidivmod>:
c0d04194:	2900      	cmp	r1, #0
c0d04196:	d0f7      	beq.n	c0d04188 <__aeabi_uidiv+0x100>
c0d04198:	e776      	b.n	c0d04088 <__aeabi_uidiv>
c0d0419a:	4770      	bx	lr

c0d0419c <__aeabi_idiv0>:
c0d0419c:	4770      	bx	lr
c0d0419e:	46c0      	nop			; (mov r8, r8)

c0d041a0 <__aeabi_memclr>:
c0d041a0:	b510      	push	{r4, lr}
c0d041a2:	2200      	movs	r2, #0
c0d041a4:	f000 f806 	bl	c0d041b4 <__aeabi_memset>
c0d041a8:	bd10      	pop	{r4, pc}
c0d041aa:	46c0      	nop			; (mov r8, r8)

c0d041ac <__aeabi_memcpy>:
c0d041ac:	b510      	push	{r4, lr}
c0d041ae:	f000 f809 	bl	c0d041c4 <memcpy>
c0d041b2:	bd10      	pop	{r4, pc}

c0d041b4 <__aeabi_memset>:
c0d041b4:	0013      	movs	r3, r2
c0d041b6:	b510      	push	{r4, lr}
c0d041b8:	000a      	movs	r2, r1
c0d041ba:	0019      	movs	r1, r3
c0d041bc:	f000 f840 	bl	c0d04240 <memset>
c0d041c0:	bd10      	pop	{r4, pc}
c0d041c2:	46c0      	nop			; (mov r8, r8)

c0d041c4 <memcpy>:
c0d041c4:	b570      	push	{r4, r5, r6, lr}
c0d041c6:	2a0f      	cmp	r2, #15
c0d041c8:	d932      	bls.n	c0d04230 <memcpy+0x6c>
c0d041ca:	000c      	movs	r4, r1
c0d041cc:	4304      	orrs	r4, r0
c0d041ce:	000b      	movs	r3, r1
c0d041d0:	07a4      	lsls	r4, r4, #30
c0d041d2:	d131      	bne.n	c0d04238 <memcpy+0x74>
c0d041d4:	0015      	movs	r5, r2
c0d041d6:	0004      	movs	r4, r0
c0d041d8:	3d10      	subs	r5, #16
c0d041da:	092d      	lsrs	r5, r5, #4
c0d041dc:	3501      	adds	r5, #1
c0d041de:	012d      	lsls	r5, r5, #4
c0d041e0:	1949      	adds	r1, r1, r5
c0d041e2:	681e      	ldr	r6, [r3, #0]
c0d041e4:	6026      	str	r6, [r4, #0]
c0d041e6:	685e      	ldr	r6, [r3, #4]
c0d041e8:	6066      	str	r6, [r4, #4]
c0d041ea:	689e      	ldr	r6, [r3, #8]
c0d041ec:	60a6      	str	r6, [r4, #8]
c0d041ee:	68de      	ldr	r6, [r3, #12]
c0d041f0:	3310      	adds	r3, #16
c0d041f2:	60e6      	str	r6, [r4, #12]
c0d041f4:	3410      	adds	r4, #16
c0d041f6:	4299      	cmp	r1, r3
c0d041f8:	d1f3      	bne.n	c0d041e2 <memcpy+0x1e>
c0d041fa:	230f      	movs	r3, #15
c0d041fc:	1945      	adds	r5, r0, r5
c0d041fe:	4013      	ands	r3, r2
c0d04200:	2b03      	cmp	r3, #3
c0d04202:	d91b      	bls.n	c0d0423c <memcpy+0x78>
c0d04204:	1f1c      	subs	r4, r3, #4
c0d04206:	2300      	movs	r3, #0
c0d04208:	08a4      	lsrs	r4, r4, #2
c0d0420a:	3401      	adds	r4, #1
c0d0420c:	00a4      	lsls	r4, r4, #2
c0d0420e:	58ce      	ldr	r6, [r1, r3]
c0d04210:	50ee      	str	r6, [r5, r3]
c0d04212:	3304      	adds	r3, #4
c0d04214:	429c      	cmp	r4, r3
c0d04216:	d1fa      	bne.n	c0d0420e <memcpy+0x4a>
c0d04218:	2303      	movs	r3, #3
c0d0421a:	192d      	adds	r5, r5, r4
c0d0421c:	1909      	adds	r1, r1, r4
c0d0421e:	401a      	ands	r2, r3
c0d04220:	d005      	beq.n	c0d0422e <memcpy+0x6a>
c0d04222:	2300      	movs	r3, #0
c0d04224:	5ccc      	ldrb	r4, [r1, r3]
c0d04226:	54ec      	strb	r4, [r5, r3]
c0d04228:	3301      	adds	r3, #1
c0d0422a:	429a      	cmp	r2, r3
c0d0422c:	d1fa      	bne.n	c0d04224 <memcpy+0x60>
c0d0422e:	bd70      	pop	{r4, r5, r6, pc}
c0d04230:	0005      	movs	r5, r0
c0d04232:	2a00      	cmp	r2, #0
c0d04234:	d1f5      	bne.n	c0d04222 <memcpy+0x5e>
c0d04236:	e7fa      	b.n	c0d0422e <memcpy+0x6a>
c0d04238:	0005      	movs	r5, r0
c0d0423a:	e7f2      	b.n	c0d04222 <memcpy+0x5e>
c0d0423c:	001a      	movs	r2, r3
c0d0423e:	e7f8      	b.n	c0d04232 <memcpy+0x6e>

c0d04240 <memset>:
c0d04240:	b570      	push	{r4, r5, r6, lr}
c0d04242:	0783      	lsls	r3, r0, #30
c0d04244:	d03f      	beq.n	c0d042c6 <memset+0x86>
c0d04246:	1e54      	subs	r4, r2, #1
c0d04248:	2a00      	cmp	r2, #0
c0d0424a:	d03b      	beq.n	c0d042c4 <memset+0x84>
c0d0424c:	b2ce      	uxtb	r6, r1
c0d0424e:	0003      	movs	r3, r0
c0d04250:	2503      	movs	r5, #3
c0d04252:	e003      	b.n	c0d0425c <memset+0x1c>
c0d04254:	1e62      	subs	r2, r4, #1
c0d04256:	2c00      	cmp	r4, #0
c0d04258:	d034      	beq.n	c0d042c4 <memset+0x84>
c0d0425a:	0014      	movs	r4, r2
c0d0425c:	3301      	adds	r3, #1
c0d0425e:	1e5a      	subs	r2, r3, #1
c0d04260:	7016      	strb	r6, [r2, #0]
c0d04262:	422b      	tst	r3, r5
c0d04264:	d1f6      	bne.n	c0d04254 <memset+0x14>
c0d04266:	2c03      	cmp	r4, #3
c0d04268:	d924      	bls.n	c0d042b4 <memset+0x74>
c0d0426a:	25ff      	movs	r5, #255	; 0xff
c0d0426c:	400d      	ands	r5, r1
c0d0426e:	022a      	lsls	r2, r5, #8
c0d04270:	4315      	orrs	r5, r2
c0d04272:	042a      	lsls	r2, r5, #16
c0d04274:	4315      	orrs	r5, r2
c0d04276:	2c0f      	cmp	r4, #15
c0d04278:	d911      	bls.n	c0d0429e <memset+0x5e>
c0d0427a:	0026      	movs	r6, r4
c0d0427c:	3e10      	subs	r6, #16
c0d0427e:	0936      	lsrs	r6, r6, #4
c0d04280:	3601      	adds	r6, #1
c0d04282:	0136      	lsls	r6, r6, #4
c0d04284:	001a      	movs	r2, r3
c0d04286:	199b      	adds	r3, r3, r6
c0d04288:	6015      	str	r5, [r2, #0]
c0d0428a:	6055      	str	r5, [r2, #4]
c0d0428c:	6095      	str	r5, [r2, #8]
c0d0428e:	60d5      	str	r5, [r2, #12]
c0d04290:	3210      	adds	r2, #16
c0d04292:	4293      	cmp	r3, r2
c0d04294:	d1f8      	bne.n	c0d04288 <memset+0x48>
c0d04296:	220f      	movs	r2, #15
c0d04298:	4014      	ands	r4, r2
c0d0429a:	2c03      	cmp	r4, #3
c0d0429c:	d90a      	bls.n	c0d042b4 <memset+0x74>
c0d0429e:	1f26      	subs	r6, r4, #4
c0d042a0:	08b6      	lsrs	r6, r6, #2
c0d042a2:	3601      	adds	r6, #1
c0d042a4:	00b6      	lsls	r6, r6, #2
c0d042a6:	001a      	movs	r2, r3
c0d042a8:	199b      	adds	r3, r3, r6
c0d042aa:	c220      	stmia	r2!, {r5}
c0d042ac:	4293      	cmp	r3, r2
c0d042ae:	d1fc      	bne.n	c0d042aa <memset+0x6a>
c0d042b0:	2203      	movs	r2, #3
c0d042b2:	4014      	ands	r4, r2
c0d042b4:	2c00      	cmp	r4, #0
c0d042b6:	d005      	beq.n	c0d042c4 <memset+0x84>
c0d042b8:	b2c9      	uxtb	r1, r1
c0d042ba:	191c      	adds	r4, r3, r4
c0d042bc:	7019      	strb	r1, [r3, #0]
c0d042be:	3301      	adds	r3, #1
c0d042c0:	429c      	cmp	r4, r3
c0d042c2:	d1fb      	bne.n	c0d042bc <memset+0x7c>
c0d042c4:	bd70      	pop	{r4, r5, r6, pc}
c0d042c6:	0014      	movs	r4, r2
c0d042c8:	0003      	movs	r3, r0
c0d042ca:	e7cc      	b.n	c0d04266 <memset+0x26>

c0d042cc <setjmp>:
c0d042cc:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0d042ce:	4641      	mov	r1, r8
c0d042d0:	464a      	mov	r2, r9
c0d042d2:	4653      	mov	r3, sl
c0d042d4:	465c      	mov	r4, fp
c0d042d6:	466d      	mov	r5, sp
c0d042d8:	4676      	mov	r6, lr
c0d042da:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0d042dc:	3828      	subs	r0, #40	; 0x28
c0d042de:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d042e0:	2000      	movs	r0, #0
c0d042e2:	4770      	bx	lr

c0d042e4 <longjmp>:
c0d042e4:	3010      	adds	r0, #16
c0d042e6:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0d042e8:	4690      	mov	r8, r2
c0d042ea:	4699      	mov	r9, r3
c0d042ec:	46a2      	mov	sl, r4
c0d042ee:	46ab      	mov	fp, r5
c0d042f0:	46b5      	mov	sp, r6
c0d042f2:	c808      	ldmia	r0!, {r3}
c0d042f4:	3828      	subs	r0, #40	; 0x28
c0d042f6:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d042f8:	1c08      	adds	r0, r1, #0
c0d042fa:	d100      	bne.n	c0d042fe <longjmp+0x1a>
c0d042fc:	2001      	movs	r0, #1
c0d042fe:	4718      	bx	r3

c0d04300 <strlen>:
c0d04300:	b510      	push	{r4, lr}
c0d04302:	0783      	lsls	r3, r0, #30
c0d04304:	d027      	beq.n	c0d04356 <strlen+0x56>
c0d04306:	7803      	ldrb	r3, [r0, #0]
c0d04308:	2b00      	cmp	r3, #0
c0d0430a:	d026      	beq.n	c0d0435a <strlen+0x5a>
c0d0430c:	0003      	movs	r3, r0
c0d0430e:	2103      	movs	r1, #3
c0d04310:	e002      	b.n	c0d04318 <strlen+0x18>
c0d04312:	781a      	ldrb	r2, [r3, #0]
c0d04314:	2a00      	cmp	r2, #0
c0d04316:	d01c      	beq.n	c0d04352 <strlen+0x52>
c0d04318:	3301      	adds	r3, #1
c0d0431a:	420b      	tst	r3, r1
c0d0431c:	d1f9      	bne.n	c0d04312 <strlen+0x12>
c0d0431e:	6819      	ldr	r1, [r3, #0]
c0d04320:	4a0f      	ldr	r2, [pc, #60]	; (c0d04360 <strlen+0x60>)
c0d04322:	4c10      	ldr	r4, [pc, #64]	; (c0d04364 <strlen+0x64>)
c0d04324:	188a      	adds	r2, r1, r2
c0d04326:	438a      	bics	r2, r1
c0d04328:	4222      	tst	r2, r4
c0d0432a:	d10f      	bne.n	c0d0434c <strlen+0x4c>
c0d0432c:	3304      	adds	r3, #4
c0d0432e:	6819      	ldr	r1, [r3, #0]
c0d04330:	4a0b      	ldr	r2, [pc, #44]	; (c0d04360 <strlen+0x60>)
c0d04332:	188a      	adds	r2, r1, r2
c0d04334:	438a      	bics	r2, r1
c0d04336:	4222      	tst	r2, r4
c0d04338:	d108      	bne.n	c0d0434c <strlen+0x4c>
c0d0433a:	3304      	adds	r3, #4
c0d0433c:	6819      	ldr	r1, [r3, #0]
c0d0433e:	4a08      	ldr	r2, [pc, #32]	; (c0d04360 <strlen+0x60>)
c0d04340:	188a      	adds	r2, r1, r2
c0d04342:	438a      	bics	r2, r1
c0d04344:	4222      	tst	r2, r4
c0d04346:	d0f1      	beq.n	c0d0432c <strlen+0x2c>
c0d04348:	e000      	b.n	c0d0434c <strlen+0x4c>
c0d0434a:	3301      	adds	r3, #1
c0d0434c:	781a      	ldrb	r2, [r3, #0]
c0d0434e:	2a00      	cmp	r2, #0
c0d04350:	d1fb      	bne.n	c0d0434a <strlen+0x4a>
c0d04352:	1a18      	subs	r0, r3, r0
c0d04354:	bd10      	pop	{r4, pc}
c0d04356:	0003      	movs	r3, r0
c0d04358:	e7e1      	b.n	c0d0431e <strlen+0x1e>
c0d0435a:	2000      	movs	r0, #0
c0d0435c:	e7fa      	b.n	c0d04354 <strlen+0x54>
c0d0435e:	46c0      	nop			; (mov r8, r8)
c0d04360:	fefefeff 	.word	0xfefefeff
c0d04364:	80808080 	.word	0x80808080

c0d04368 <TXT_BLANK>:
c0d04368:	20202020 20202020 20202020 20202020                     
c0d04378:	32310020                                          .

c0d0437a <BASE_58_ALPHABET>:
c0d0437a:	34333231 38373635 43424139 47464544     123456789ABCDEFG
c0d0438a:	4c4b4a48 51504e4d 55545352 59585756     HJKLMNPQRSTUVWXY
c0d0439a:	6362615a 67666564 6b6a6968 706f6e6d     Zabcdefghijkmnop
c0d043aa:	74737271 78777675 31307a79                       qrstuvwxyz

c0d043b4 <g_pcHex>:
c0d043b4:	33323130 37363534 62613938 66656463     0123456789abcdef

c0d043c4 <g_pcHex_cap>:
c0d043c4:	33323130 37363534 42413938 46454443     0123456789ABCDEF
c0d043d4:	4f525245 006f0052                                ERROR.

c0d043da <SW_INTERNAL>:
c0d043da:	0190006f                                         o.

c0d043dc <SW_BUSY>:
c0d043dc:	00670190                                         ..

c0d043de <SW_WRONG_LENGTH>:
c0d043de:	85690067                                         g.

c0d043e0 <SW_PROOF_OF_PRESENCE_REQUIRED>:
c0d043e0:	806a8569                                         i.

c0d043e2 <SW_BAD_KEY_HANDLE>:
c0d043e2:	3255806a                                         j.

c0d043e4 <U2F_VERSION>:
c0d043e4:	5f463255 00903256                       U2F_V2..

c0d043ec <INFO>:
c0d043ec:	00900901                                ....

c0d043f0 <SW_UNKNOWN_CLASS>:
c0d043f0:	006d006e                                         n.

c0d043f2 <SW_UNKNOWN_INSTRUCTION>:
c0d043f2:	ffff006d                                         m.

c0d043f4 <BROADCAST_CHANNEL>:
c0d043f4:	ffffffff                                ....

c0d043f8 <FORBIDDEN_CHANNEL>:
c0d043f8:	00000000 20657241 20756f79 65727573     ....Are you sure
c0d04408:	6557003f 6d6f636c 6f422065 736f7474     ?.Welcome Bottos
c0d04418:	72655600 6e6f6973 302e3120 4300302e     .Version 1.0.0.C
c0d04428:	69666e6f 53206d72 206e6769 3f207854     onfirm Sign Tx ?
c0d04438:	00000000                                ....

c0d0443c <bagl_ui_test_nanos>:
c0d0443c:	00000003 00800000 00000020 00000001     ........ .......
c0d0444c:	00000000 00ffffff 00000000 00000000     ................
	...
c0d04474:	00030005 0007000c 00000007 00000000     ................
c0d04484:	00ffffff 00000000 00070000 00000000     ................
	...
c0d044ac:	00750005 0008000d 00000006 00000000     ..u.............
c0d044bc:	00ffffff 00000000 00060000 00000000     ................
	...
c0d044e4:	00000107 0080000c 0000000c 00000000     ................
c0d044f4:	00ffffff 00000000 00008008 c0d043fc     .............C..
	...

c0d0451c <bagl_ui_idle_nanos>:
c0d0451c:	00000003 00800000 00000020 00000001     ........ .......
c0d0452c:	00000000 00ffffff 00000000 00000000     ................
	...
c0d04554:	00000207 0080000c 0000000b 00000000     ................
c0d04564:	00ffffff 00000000 00008008 c0d0440a     .............D..
	...
c0d0458c:	000a0207 006c001c 008a000b 00000000     ......l.........
c0d0459c:	00ffffff 00000000 0000800a c0d04419     .............D..
	...
c0d045c4:	00030005 0007000c 00000007 00000000     ................
c0d045d4:	00ffffff 00000000 00070000 00000000     ................
	...

c0d045fc <bagl_ui_sign_hash_nanos>:
c0d045fc:	00000003 00800000 00000020 00000001     ........ .......
c0d0460c:	00000000 00ffffff 00000000 00000000     ................
	...
c0d04634:	00000207 0080000c 0000000b 00000000     ................
c0d04644:	00ffffff 00000000 00008008 c0d04427     ............'D..
	...
c0d0466c:	000a0207 006c001c 008a000b 00000000     ......l.........
c0d0467c:	00ffffff 00000000 0000800a 20001b00     ............... 
	...
c0d046a4:	00030005 0007000c 00000007 00000000     ................
c0d046b4:	00ffffff 00000000 00070000 00000000     ................
	...
c0d046dc:	00750005 0007000c 00000007 00000000     ..u.............
c0d046ec:	00ffffff 00000000 00060000 00000000     ................
	...

c0d04714 <USBD_HID_Desc_fido>:
c0d04714:	01112109 22220121 00000000              .!..!.""....

c0d04720 <USBD_HID_Desc>:
c0d04720:	01112109 22220100 f1d00600                       .!...."".

c0d04729 <HID_ReportDesc_fido>:
c0d04729:	09f1d006 0901a101 26001503 087500ff     ...........&..u.
c0d04739:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d04749:	a006c008                                         ..

c0d0474b <HID_ReportDesc>:
c0d0474b:	09ffa006 0901a101 26001503 087500ff     ...........&..u.
c0d0475b:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d0476b:	0000c008 d03e4d00                                .....

c0d04770 <HID_Desc>:
c0d04770:	c0d03e4d c0d03e5d c0d03e6d c0d03e7d     M>..]>..m>..}>..
c0d04780:	c0d03e8d c0d03e9d c0d03ead 00000000     .>...>...>......

c0d04790 <C_webusb_url_descriptor>:
c0d04790:	77010317 6c2e7777 65676465 6c617772     ...www.ledgerwal
c0d047a0:	2e74656c 056d6f63                                let.com

c0d047a7 <C_usb_bos>:
c0d047a7:	001d0f05 05101801 08b63800 a009a934     .........8..4...
c0d047b7:	a0fd8b47 b6158876 1e010065 d03bdb01              G...v...e....

c0d047c4 <USBD_HID>:
c0d047c4:	c0d03bdb c0d03c0d c0d03b43 00000000     .;...<..C;......
c0d047d4:	00000000 c0d03d39 c0d03d51 00000000     ....9=..Q=......
	...
c0d047ec:	c0d03fa1 c0d03fa1 c0d03fa1 c0d03fb1     .?...?...?...?..

c0d047fc <USBD_U2F>:
c0d047fc:	c0d03cc1 c0d03c0d c0d03b43 00000000     .<...<..C;......
c0d0480c:	00000000 c0d03cf5 c0d03d0d 00000000     .....<...=......
	...
c0d04824:	c0d03fa1 c0d03fa1 c0d03fa1 c0d03fb1     .?...?...?...?..

c0d04834 <USBD_WEBUSB>:
c0d04834:	c0d03da9 c0d03dd5 c0d03dd9 00000000     .=...=...=......
c0d04844:	00000000 c0d03ddd c0d03df5 00000000     .....=...=......
	...
c0d0485c:	c0d03fa1 c0d03fa1 c0d03fa1 c0d03fb1     .?...?...?...?..

c0d0486c <USBD_DeviceDesc>:
c0d0486c:	02000112 40000000 00012c97 02010200     .......@.,......
c0d0487c:	03040103                                         ..

c0d0487e <USBD_LangIDDesc>:
c0d0487e:	04090304                                ....

c0d04882 <USBD_MANUFACTURER_STRING>:
c0d04882:	004c030e 00640065 00650067 030e0072              ..L.e.d.g.e.r.

c0d04890 <USBD_PRODUCT_FS_STRING>:
c0d04890:	004e030e 006e0061 0020006f 030a0053              ..N.a.n.o. .S.

c0d0489e <USB_SERIAL_STRING>:
c0d0489e:	0030030a 00300030 02090031                       ..0.0.0.1.

c0d048a8 <USBD_CfgDesc>:
c0d048a8:	00600209 c0020103 00040932 00030200     ..`.....2.......
c0d048b8:	21090200 01000111 07002222 40038205     ...!...."".....@
c0d048c8:	05070100 00400302 01040901 01030200     ......@.........
c0d048d8:	21090201 01210111 07002222 40038105     ...!..!."".....@
c0d048e8:	05070100 00400301 02040901 ffff0200     ......@.........
c0d048f8:	050702ff 00400383 03050701 01004003     ......@......@..

c0d04908 <USBD_DeviceQualifierDesc>:
c0d04908:	0200060a 40000000 00000001              .......@....

c0d04914 <_etext>:
	...
