//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
pragma experimental ABIEncoderV2;

import {BasePaymaster} from "gsn/src/BasePaymaster.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {GsnTypes} from "gsn/src/utils/GsnTypes.sol";
import {GsnUtils} from "gsn/src/utils/GsnUtils.sol";
import {GsnEip712Library} from "gsn/src/utils/GsnEip712Library.sol";

contract RLYVerifyPaymaster is BasePaymaster {
    address public signer;

    struct MethodOptions {
        bool ignoreTrustedForwarder;
    }

    mapping(bytes32 => MethodOptions) public methodWhiteList;

    event RLYPaymasterPreCallValues(
        bytes txHash,
        address relay,
        address from,
        bytes4 method,
        uint256 baseRelayFee,
        uint256 gasLimit,
        bytes approvalData,
        uint256 maxPossibleGas,
        uint256 clientId
    );

    event RLYPaymasterPostCallValues(
        bytes txHash,
        uint256 clientId,
        uint256 gasUsed
    );

    function setMethodOptions(
        address target,
        bytes4 method,
        bool ignoreTrustedForwarder
    ) public onlyOwner {
        bytes32 _hash = keccak256((abi.encode(target, method)));
        methodWhiteList[_hash] = MethodOptions({
            ignoreTrustedForwarder: ignoreTrustedForwarder
        });
    }

    function setSigner(address _signer) public onlyOwner {
        signer = _signer;
    }

    function versionPaymaster()
        external
        view
        virtual
        override
        returns (string memory)
    {
        return "3.0.0-beta.3";
    }

    function _preRelayedCall(
        GsnTypes.RelayRequest calldata relayRequest,
        bytes calldata signature,
        bytes calldata approvalData,
        uint256 maxPossibleGas
    )
        internal
        virtual
        override
        returns (bytes memory context, bool revertOnRecipientRevert)
    {
        require(
            _isValidApprovalSignature(signature, approvalData),
            "approvalData: approval signature mismatch"
        );

        MethodOptions memory methodOptions = _getMethodOptions(relayRequest);

        //verify trusted forwarder if required by method
        if (!methodOptions.ignoreTrustedForwarder) {
            GsnEip712Library.verifyForwarderTrusted(relayRequest);
        }

        //hash request to use as identifier
        bytes memory requestHash = abi.encodePacked(
            keccak256((abi.encode(relayRequest.request)))
        );

        bytes4 method = GsnUtils.getMethodSig(relayRequest.request.data);

        _emitPreCallEvent(
            relayRequest,
            requestHash,
            method,
            approvalData,
            maxPossibleGas
        );

        return (abi.encode(requestHash, method), true);
    }

    function _postRelayedCall(
        bytes calldata context,
        bool success,
        uint256 gasUseWithoutPost,
        GsnTypes.RelayData calldata relayData
    ) internal virtual override {
        (context, success, gasUseWithoutPost, relayData);

        (bytes memory requestHash, bytes4 method) = abi.decode(
            context,
            (bytes, bytes4)
        );

        emit RLYPaymasterPostCallValues(
            requestHash,
            relayData.clientId,
            gasUseWithoutPost
        );

        _checkIfPermitAndTransfer(method, relayData);
        (method, relayData);
    }

    function _emitPreCallEvent(
        GsnTypes.RelayRequest calldata relayRequest,
        bytes memory requestHash,
        bytes4 method,
        bytes calldata approvalData,
        uint256 maxPossibleGas
    ) private {
        emit RLYPaymasterPreCallValues(
            requestHash,
            relayRequest.relayData.relayWorker,
            relayRequest.request.from,
            method,
            relayRequest.relayData.maxFeePerGas,
            relayRequest.request.gas,
            approvalData,
            maxPossibleGas,
            relayRequest.relayData.clientId
        );
    }

    // if the user called permit on the token, check if they included a transferFrom call in the paymaster data and execute

    function _checkIfPermitAndTransfer(
        bytes4 method,
        GsnTypes.RelayData calldata relayData
    ) private {
        if (method == IERC20Permit.permit.selector) {
            bytes calldata paymasterData = relayData.paymasterData;
            require(
                paymasterData.length >= 24,
                "must contain address and method"
            );
            IERC20 token = IERC20(address(bytes20(paymasterData[:20])));

            require(
                IERC20.transferFrom.selector ==
                    GsnUtils.getMethodSig(paymasterData[20:]),
                "invalid method"
            );

            (bool successTx, ) = address(token).call(paymasterData[20:]);
            require(successTx, "transferFrom call reverted");
        }
    }

    function _isValidApprovalSignature(
        bytes calldata signature,
        bytes calldata approvalData
    ) internal view returns (bool) {
        bytes32 prefixedHashMessage = ECDSA.toEthSignedMessageHash(signature);
        address recoveredSigner = ECDSA.recover(
            prefixedHashMessage,
            approvalData
        );
        return (recoveredSigner == signer);
    }

    function _getMethodOptions(
        GsnTypes.RelayRequest calldata relayRequest
    ) internal view returns (MethodOptions memory) {
        address to = relayRequest.request.to;
        bytes4 method = GsnUtils.getMethodSig(relayRequest.request.data);
        return methodWhiteList[keccak256(abi.encode(to, method))];
    }

    function _verifyApprovalData(
        bytes calldata approvalData
    ) internal view virtual override {
        require(
            approvalData.length == 65,
            "approvalData: invalid length for signature"
        );
    }

    function _verifyForwarder(
        GsnTypes.RelayRequest calldata relayRequest
    ) internal view virtual override {
        // We override GNS default behavior as not every call we do requires the recipient contract to trust the forwarder
        // In the case of the default ERC20 contracts executeNativeMetaTransaction on polygon signature checks are done in the contract not in the forawarder
        // This check is now optionally performed in `_preRelayedCall(..)`
    }

    function _verifyPaymasterData(
        GsnTypes.RelayRequest calldata relayRequest
    ) internal view virtual override {
        // we overide default behavior of the GSN Basepaymaster since it verifys that paymasterData length = 0
        /// paymaster data is now used, but only after permit has been called and it is validated at that point.
    }
}
