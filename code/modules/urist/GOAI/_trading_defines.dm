/*
// Macros and constants for the economy side of the AI
*/

/* Standard offer expiry times, in deciseconds as usual */

// 'Slow' offers are good for us and have longer TTL
// Live, 20 mins
// #define EXPIRY_TIME_SLOW 12000
// Debug, 60s:
#define EXPIRY_TIME_SLOW 600

// 'Fast' offers are bad for us, but we make them out of desperation, short TTL
// Live, 5 mins
// #define EXPIRY_TIME_FAST 3000
// Debug, 30 seconds
#define EXPIRY_TIME_FAST 300

// This is only used for the global marketplace, but it's nicer to have it here as it's linked to the expiry times above

// Default delay between cleanup ticks
// Ideally this would be a small multiple of standard expiry times for
//   offers; this ensures AIs don't need to scan through trash offers too much.
// However, too low means we do a bunch of scanning and allocs in *here* instead,
//   so this needs to be tuned a bit to strike a good balance.
//#define DEFAULT_MARKETWATCH_TICKRATE 3000
#define DEFAULT_MARKETWATCH_TICKRATE 300

// Default delay between production system ticks
#define DEFAULT_PRODUCTION_SYSTEM_TICKRATE 100

// Time quantization for production system - i.e. the lowest unit of time it takes for something to get produced
// This is mainly used to throttle processing so that it doesn't eat CPU cycles unnecessarily.
#define PRODUCTIONSYSTEM_TICKSIZE_DSECONDS 100

// Default delay between asset-needs system ticks
#define DEFAULT_ASSETNEEDS_SYSTEM_TICKRATE 50

/* Bitflag enum of trade_contract lifecycle states */

// The value at the beginning of the deal.
// Neither Goods nor Money has been transferred and neither side of the trade signed off yet
#define GOAI_CONTRACT_LIFECYCLE_INITIAL 0

// AWAITING_SIGNOFF_CREATOR => the creator of the contract has not confirmed it's all good yet
#define GOAI_CONTRACT_LIFECYCLE_SIGNOFF_CREATOR 1

// AWAITING_SIGNOFF_CONTRACTOR => the receiver of the contract has not confirmed it's all good yet
#define GOAI_CONTRACT_LIFECYCLE_SIGNOFF_CONTRACTOR 2

// GOODS_PENDING => Payer received ALL the goods.
#define GOAI_CONTRACT_LIFECYCLE_GOODS_DELIVERED 4

// PAYMENT_PENDING => ALL Money transferred to Supplier
#define GOAI_CONTRACT_LIFECYCLE_PAID 8

// First 4 bits are therefore all set, 8+4+2+1 == 15
#define GOAI_CONTRACT_LIFECYCLE_FULFILLED 15

// Shipments may get intercepted or be too big to be handled in one transport.
// In particular, player trade items might be sent in arbitrarily small batches, because humans.
// As such, the flags below track that at least SOME effort was made to fulfill the terms.
// These are stored in a SEPARATE bitflag!

// SHIPPING => Supplier sending goods
#define GOAI_CONTRACT_LIFECYCLE_SHIPPING 1

// RECEIVING => Payer received SOME goods
#define GOAI_CONTRACT_LIFECYCLE_RECEIVING 2

// PAYING => Supplier received SOME money
#define GOAI_CONTRACT_LIFECYCLE_PAYING 4

// Each requirement sets a bit. If all bits are set - we're good!
#define GOAI_CONTRACT_IS_COMPLETED(ContractStateVal, ContractAuxStateVal) (ContractStateVal == GOAI_CONTRACT_LIFECYCLE_FULFILLED)

// This is technically a success state, but something has gone horribly wrong with state flags.
// This can be used to force-complete contracts but with warn-level logging added.
#define GOAI_CONTRACT_IS_DIRTY_COMPLETED(ContractStateVal, ContractAuxStateVal) ((ContractStateVal & GOAI_CONTRACT_LIFECYCLE_FULFILLED) == GOAI_CONTRACT_LIFECYCLE_FULFILLED)

// Did both parties sign off on the contract completion?
#define GOAI_CONTRACT_IS_SIGNED(ContractStateVal, ContractAuxStateVal) ((ContractStateVal & GOAI_CONTRACT_LIFECYCLE_SIGNOFF_CREATOR) && (ContractStateVal & GOAI_CONTRACT_LIFECYCLE_SIGNOFF_CONTRACTOR))

// Beyond signoffs, is the contract completed? If FALSE, something was not delivered.
// If TRUE, we could force-complete contracts but with warn-level logging added.
#define GOAI_CONTRACT_COMPLETED_IF_SIGNED(ContractStateVal, ContractAuxStateVal) GOAI_CONTRACT_IS_COMPLETED((ContractStateVal | (GOAI_CONTRACT_LIFECYCLE_SIGNOFF_CREATOR | GOAI_CONTRACT_LIFECYCLE_SIGNOFF_CONTRACTOR)), ContractAuxStateVal)

// If any of the bits in progressed_state were set, someone made a good-faith effort to fulfill their obligations.
// This can be checked to add some leniency on things like expiration.
#define GOAI_CONTRACT_IS_PROGRESSING(ContractStateVal, ContractAuxStateVal) (ContractAuxStateVal > GOAI_CONTRACT_LIFECYCLE_INITIAL)

// Whether cash for trades can be submitted in multiple parts (i.e. I owe you 30$, I pay 10$ now and 20$ tomorrow) by default.
// If FALSE, we must have the whole amount ready as lump sum, if TRUE we will dump all our reserves into the trade if necessary.
// Hard to tell whether TRUE or FALSE is better here a priori - both can cause liquidity issues in their own ways.
// Can be overridden at call points for the EscrowPut() method.
#define ESCROW_PUT_PARTIAL_ALLOWED_DEFAULT FALSE
