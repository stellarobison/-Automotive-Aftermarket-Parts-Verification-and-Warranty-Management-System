# Automotive Aftermarket Parts Verification and Warranty Management System

A comprehensive blockchain-based system for managing automotive aftermarket parts verification, warranty tracking, and consumer protection using Clarity smart contracts.

## System Overview

This system provides a decentralized solution for:

- **Parts Authenticity Verification**: Cryptographic verification of genuine aftermarket parts
- **Compatibility Checking**: Ensuring parts are compatible with specific vehicle models
- **Installation Tracking**: Recording professional installation and warranty activation
- **Performance Monitoring**: Tracking part performance and failure analysis
- **Recall Management**: Coordinating recalls and replacement processes
- **Consumer Protection**: Preventing fraud and ensuring warranty compliance

## Smart Contracts

### 1. Parts Registry (`parts-registry.clar`)
- Manages part registration and authenticity verification
- Stores part specifications, compatibility data, and manufacturer information
- Handles part verification and anti-counterfeiting measures

### 2. Warranty Manager (`warranty-manager.clar`)
- Manages warranty registration, activation, and claims
- Tracks warranty periods, terms, and claim history
- Handles warranty transfers and extensions

### 3. Installation Tracker (`installation-tracker.clar`)
- Records professional installations and certifications
- Tracks installer credentials and installation quality
- Links installations to warranty activation

### 4. Performance Monitor (`performance-monitor.clar`)
- Monitors part performance and failure rates
- Collects performance data and failure analysis
- Generates reliability reports and recommendations

### 5. Recall Coordinator (`recall-coordinator.clar`)
- Manages recall notifications and coordination
- Tracks affected parts and replacement processes
- Handles recall compliance and consumer notifications

## Key Features

- **Immutable Records**: All transactions recorded on blockchain
- **Cryptographic Security**: Parts verified using cryptographic signatures
- **Decentralized Trust**: No single point of failure
- **Consumer Protection**: Transparent warranty and recall processes
- **Industry Standards**: Compatible with automotive industry requirements

## Data Types

- **Part ID**: Unique identifier for each part
- **Vehicle Compatibility**: Make, model, year compatibility matrix
- **Warranty Terms**: Duration, coverage, and conditions
- **Installation Records**: Professional installation verification
- **Performance Metrics**: Failure rates, performance data
- **Recall Status**: Active recalls and replacement tracking

## Security Features

- Multi-signature authorization for critical operations
- Role-based access control (manufacturers, installers, consumers)
- Cryptographic part authentication
- Tamper-proof installation records
- Secure warranty claim processing

## Getting Started

1. Deploy contracts to Stacks blockchain
2. Register manufacturers and authorized installers
3. Begin part registration and verification process
4. Activate warranty tracking for installed parts
5. Monitor performance and handle recalls as needed

## Testing

Run the test suite using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover all contract functions, edge cases, and security scenarios.
