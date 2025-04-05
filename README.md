# Decentralized Specialized Disaster Communication Network

This blockchain-based platform provides a resilient communication infrastructure for disaster response scenarios, enabling coordinated deployment of communication equipment and certified operators when traditional networks fail. The system ensures verified identity, equipment tracking, and secure message relay during emergency situations.

## System Overview

The Decentralized Specialized Disaster Communication Network consists of four core smart contracts:

1. **Equipment Registration Contract**: Documents emergency communication devices and their capabilities
2. **Operator Certification Contract**: Verifies training and authorization of emergency communication personnel
3. **Deployment Coordination Contract**: Orchestrates strategic positioning of communication assets
4. **Message Relay Contract**: Secures critical communications during disaster response

## Getting Started

### Prerequisites

- Node.js (v16.0+)
- Blockchain development environment (Truffle/Hardhat)
- Web3 library
- Hardware wallet support
- Low-power mesh network compatibility

### Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/disaster-comms-network.git
   cd disaster-comms-network
   ```

2. Install dependencies
   ```
   npm install
   ```

3. Compile smart contracts
   ```
   npx hardhat compile
   ```

4. Deploy to test network
   ```
   npx hardhat run scripts/deploy.js --network testnet
   ```

## Smart Contract Architecture

### Equipment Registration Contract
Maintains a comprehensive registry of communication equipment including radio systems, satellite terminals, mesh network nodes, and power generators. Each device is assigned a unique identifier with detailed specifications, operational status, and current custodian.

### Operator Certification Contract
Validates and stores credentials of trained emergency communication operators including certification levels, specialized skills, availability status, and deployment history. Ensures only qualified personnel can deploy and operate critical communication systems.

### Deployment Coordination Contract
Manages the strategic positioning of communication assets during emergency scenarios. Handles deployment requests, equipment allocation, geographic coverage planning, and status updates to maximize communication effectiveness.

### Message Relay Contract
Provides a secure, immutable log of critical communications during disaster response operations. Enables priority message routing, delivery confirmation, and information integrity verification when standard communication channels are compromised.

## Usage Examples

### Registering Communication Equipment
```javascript
const equipmentRegistry = await EquipmentRegistrationContract.deployed();
await equipmentRegistry.registerEquipment(
  "SAT-TERM-478",
  "Portable VSAT Terminal",
  "High-bandwidth satellite communication system with autonomous power",
  "https://ipfs.io/ipfs/QmXoypizjW3WknFiJnKLwHCnL72vedxjQkDDP1mXWo6uco/specs.json",
  "OPERATIONAL",
  "ORG-FEMA-12"
);
```

### Coordinating Deployment
```javascript
const deploymentCoordinator = await DeploymentCoordinationContract.deployed();
await deploymentCoordinator.requestDeployment(
  "DEP-2025-04-12",
  [37.7749, -122.4194], // deployment coordinates
  "Wildfire response communications",
  ["SAT-TERM-478", "MESH-NODE-389", "RADIO-HF-142"],
  ["OP-CERT-765", "OP-CERT-921"],
  72 // estimated deployment duration in hours
);
```

## Features

- **Resilient Communication**: Provides infrastructure when traditional networks fail
- **Verified Identity**: Ensures only certified operators handle emergency communications
- **Equipment Tracking**: Maintains real-time location and status of critical assets
- **Secure Messaging**: Preserves message integrity during critical operations
- **Coordinated Response**: Enables strategic deployment of limited resources
- **Offline Capability**: Functions in environments with limited internet connectivity

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please contact: support@disastercommunications.org
