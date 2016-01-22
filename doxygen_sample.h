/*******************************************************************************
 * Copyright 2014 Sony Corporation.
 * This is UNPUBLISHED PROPRIETARY SOURCE CODE of Sony Corporation.
 * No part of this file may be copied, modified, sold, and distributed in any
 * form or by any means without prior explicit permission in writing from
 * Sony Corporation.
 */

/**
 * @file       doxygen_sample.h
 * @brief      sample code comment for Spirtzer SDK API
 * @author     SPritzer SCM/Integ Team
 * @note       this code from pd_dmac.h, 
 * @attention  this file include SDK API and INTERNAL_API.
 */


/**
* @defgroup SPZ_SAMPLE_TOP_TEAM doxygen_sample_victor
* @brief doxygen samples for SDK APIs
*/

/**
* @ingroup  SPZ_SAMPLE_TOP_TEAM
* @defgroup SPZ_SAMPLE_GENERAL_TEAM general
* @brief    sample general (file header,function,data,etc)
* @{
*/

/**
* @name Callback Functions
* @{
*/
/**
 * Callback function for obtaining interrupt signals
 *
 * @param[in] a : xxx
 * @param[in] b : yyy
 *
 * @return none
 *
 * @detail describe callbackfunction detail here  
 */
typedef void (*PD_DmacIntrCallback_t)(int a, void * b);
/** @} */


/**
 * Link list item structure for use scatter/gather operation
 */
typedef struct {
    uint32_t src_addr;  /**< [in] source address       */
    uint32_t dest_addr; /**< [out] destination address */
    uint32_t nextlli;   /**< [in,out] next pointer     */
    uint32_t control;   /**< link controle             */
} PD_DmacLli_t;

#define PD_DMAC_INTR_ITC (1u<<0) /**< Terminal count interrupt status */
#define PD_DMAC_INTR_ERR (1u<<1) /**< Error interrupt status */

/**
 * Helper macro for construct transfer control parameter.
 * Each parameters are the same with PD_DmacSetControl().
 */
#define PD_DmacCtrlHelper(intr, di, si, dwidth, swidth, dbsize, sbsize, tsize) \
    (((intr) & 1u) << 31 |                                               \
     ((di) & 1u) << 27 |                                                 \
     ((si) & 1u) << 26 |                                                 \
     ((dwidth) & 7u) << 21 |                                             \
     ((swidth) & 7u) << 18 |                                             \
     ((dbsize) & 7u) << 15 |                                             \
     ((sbsize) & 7u) << 12 |                                             \
     (tsize & 0xfffu))

/**
 * DMA transfer parameter 
 */
enum {
    PD_DMAC_M2M = 0,   ///< Memory to memory
    PD_DMAC_M2P,       ///< Memory to peripehral, DMAC controlled
    PD_DMAC_P2M,       ///< Peripheral to memroy, DMAC controlled
    PD_DMAC_P2P,       ///< Peripheral to peripheral
    PD_DMAC_P2CP,      ///< P2P destination controlled
    PD_DMAC_M2CP,      ///< M2P peripheral controlled
    PD_DMAC_CP2M,      ///< P2M peripheral controlled
    PD_DMAC_CP2P,      ///< P2P source controlled
};


enum {
    PD_DMAC_LITTLE_ENDIAN = 0,
    PD_DMAC_BIG_ENDIAN
};

/**
 * Initialize DMAC driver
 */
void PD_DmacInit(void);

/**
 * @brief Set callback function and user data when interrupt occurred
 *
 * @param[in] ch : Channel #
 * @param[in,out] func : Callback function
 * @param[out] data : User data
 *
 * @retval -ENODEV : Invalid channel
 
 * @pre describe  pre-condition here
 * @post describe post-dondiion here
 *
 * @detail User must be set if getting signal when transfer has been done.
 */
int PD_DmacSetIntrCallback(int ch, PD_DmacIntrCallback_t func, void *data);

/** @cond SPZ_INT_API */
/**
 * Data width
 */
enum {
    PD_DMAC_WIDTH8  = 0,
    PD_DMAC_WIDTH16,
    PD_DMAC_WIDTH32,
};

/**
 * Set transfer control parameters
 *
 * @param ch : Channel #
 * @param itc : Raise interrupt on transfer done(1=enable)
 * @param destinc : Destination address increment (1=increment, 0=constant)
 * @param srcinc  : Source address increment (1=increment, 0=constant)
 * @param dwidth : Destination data width (PD_DMAC_WIDTH*)
 * @param swidth : Source data width (PD_DMAC_WIDTH*)
 * @param dbsize : Destination burst size (PD_DMAC_BSIZE*)
 * @param sbsize : Source burst size (PD_DMAC_BSIZE*)
 * @param txsize : Transfer size
 *
 * @retval -ENODEV : Invalid channel
 *
 * @see PrimeCell Single Master DMA Controller (PL081)  Technical reference manual
 */
int PD_DmacSetControl(int ch, int itc, int destinc, int srcinc,
                      int dwidth, int swidth, int dbsize, int sbsize, int txsize);

/** @endcond SPZ_INT_API */

/** @} SPZ_SAMPLE_GENERAL_TEAM */
