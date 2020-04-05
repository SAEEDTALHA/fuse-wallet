import 'package:equatable/equatable.dart';
import 'package:fusecash/models/community.dart';
import 'package:fusecash/models/pro/token.dart';
import 'package:fusecash/models/transactions/transfer.dart';
import 'package:fusecash/utils/addresses.dart';
import 'package:redux/redux.dart';
import 'package:fusecash/models/app_state.dart';

class ProWalletViewModel extends Equatable {
  final String walletAddress;
  final List<Token> tokens;
  final bool hasTrasnferdToForeign;

  ProWalletViewModel({
    this.walletAddress,
    this.hasTrasnferdToForeign,
    this.tokens
  });

  static ProWalletViewModel fromStore(Store<AppState> store) {
    List<Token> tokens = List<Token>.from(store.state.proWalletState.erc20Tokens.values);
    Community community = store.state.cashWalletState.communities[defaultCommunityAddress];
    bool hasTrasnferdToForeign = community.transactions.list.any((item) {
        Transfer transfer = item as Transfer;
        return (transfer?.to?.toLowerCase() == community?.homeBridgeAddress?.toLowerCase()) ?? false;
      }) && !tokens.any((token) => token?.address == daiTokenAddress.toLowerCase());
    return ProWalletViewModel(
      hasTrasnferdToForeign: hasTrasnferdToForeign,
      walletAddress: store.state.userState.walletAddress,
      tokens: tokens,
    );
  }

  @override
  List<Object> get props => [
    walletAddress,
    tokens,
    hasTrasnferdToForeign
  ];
}