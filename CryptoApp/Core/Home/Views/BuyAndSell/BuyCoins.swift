//
//  BuyCoins.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 21/05/23.
//

import SwiftUI
import Kingfisher

struct BuyCoins: View {
    
    @State var backgroundColor: Color
    var coin : Coin
    @Environment(\.presentationMode) var presentationMode
    let Screenwidth = (UIScreen.main.bounds.width) - 30
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var successNotificationManager = SuccessNotificationManager()
    
    @State private var qty = ""
    @State private var isButton1Active = true
    @State private var isButton2Active = false
    @State private var total = 0.0
    @State private var balance = 0.0
    
    var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.black)
                    .ignoresSafeArea()
                
                Rectangle()
                    .fill(.linearGradient(colors: [backgroundColor, .black], startPoint: .top, endPoint: .bottom))
                    .ignoresSafeArea()
                
                
                VStack(alignment: .leading) {
                    // Navigation Header..
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() },
                               label: {
                            Image(systemName: "chevron.backward")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .frame(width: 40, height: 30)
                        })
                        .padding(.leading, -7)
                        Spacer()
                        Text("Buy " + coin.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        
                        Menu {
                            Button(action: {}, label: {
                                Label("Info", systemImage: "info.circle")
                            })
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .offset(x: -7)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                    .foregroundColor(.white)
                    
                    
                    // Stocks Details
                    ZStack {
                        Rectangle()
                            .frame(width: Screenwidth, height: 100)
                            .foregroundColor(.white.opacity(0.09))
                            .cornerRadius(15)
                        Rectangle()
                            .frame(width: Screenwidth, height: 100)
                            .foregroundColor(backgroundColor.opacity(0.3))
                            .cornerRadius(15)
                        
                        HStack {
                            KFImage(URL(string: coin.image))
                                .resizable()
                                .frame(width: 70, height: 70)
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading) {
                                Text(coin.name)
                                    .font( coin.name.count < 10 ? .title2 : .headline)
                                    .fontWeight(.semibold)
                                Text(coin.symbol.uppercased())
                                    .font(.subheadline)
                                    .padding(.leading, 1)
                            }
                            .foregroundColor(.white)
                            .padding(.leading, -5)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(coin.currentPrice.toCurrency())
                                    .font( coin.currentPrice.toCurrency().count <= 10 ? .headline : .subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text(coin.priceChangePercentage24H > 0 ? "+" + coin.priceChangePercentage24H.toPercetString() : coin.priceChangePercentage24H.toPercetString())
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(coin.priceChangePercentage24H > 0 ? .green : .red)
                                    .padding(.leading, 1)
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 5)
                    
                    
                    // Buying Info
                    ZStack {
                        Rectangle()
                            .frame(width: Screenwidth, height: 170)
                            .foregroundColor(.white.opacity(0.09))
                            .cornerRadius(15)
                        Rectangle()
                            .frame(width: Screenwidth, height: 170)
                            .foregroundColor(backgroundColor.opacity(0.3))
                            .cornerRadius(15)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Button(action: {
                                    isButton1Active = true
                                    isButton2Active = false
                                },
                                   label: {
                                    RoundedRectangle(cornerRadius: 50)
                                        .frame(width: Screenwidth/5, height: 30)
                                        .foregroundColor(isButton1Active ? .white.opacity(0.3) : .white.opacity(0.1))
                                        .overlay(
                                            Text("Delivery")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                        )
                                })
                                
                                Button(action: {
                                    isButton1Active = false
                                    isButton2Active = true
                                },
                                   label: {
                                    RoundedRectangle(cornerRadius: 50)
                                        .frame(width: Screenwidth/5, height: 30)
                                        .foregroundColor(isButton2Active ? .white.opacity(0.3) : .white.opacity(0.1))
                                        .overlay(
                                            Text("Intraday")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                        )
                                })
                                Spacer()
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 15)
                            .padding(.bottom, 15)
                            
                            HStack {
                                Text("Qty NSE")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    qty = String((Int(qty) ?? 0) > 0 ? (Int(qty) ?? 0) - 1 : Int(0) )
                                },
                                label: {
                                    Image(systemName: "minus")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 35)
                                })
                                .background(.white.opacity(0.1))
                                .cornerRadius(7)
                                .disabled(qty == "0" || qty == "" ? true : false)
                                .opacity(qty == "0" || qty == "" ? 0.6 : 1.0)
                                
                                InputFieldView(text: $qty, placeholder: "Amount")
                                
                                Button(action: {
                                    qty = String((Int(qty) ?? 0) + 1)
                                },
                                label: {
                                    Image(systemName: "plus")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 35)
                                })
                                .background(.white.opacity(0.1))
                                .cornerRadius(7)
                                .disabled(total >= balance)
                                .opacity(total >= balance ? 0.6 : 1.0)
                            }
                            .padding(.horizontal, 15)
                            
                            HStack {
                                Text("Price")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("At Market")
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(width: (Screenwidth/3) + 45)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(.white.opacity(0.1))
                                    .cornerRadius(7)
                            }
                            .padding(.horizontal, 15)
                            
                            Spacer()
                        }
                        .frame(width: Screenwidth, height: 170)
                        .padding(.horizontal, 15)
                    }

                    
                    // Alert Notification
                    if (Int(qty) ?? 0) >= 1000 {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: Screenwidth, height: 35)
                            .foregroundColor(.red.opacity(0.3))
                            .overlay(
                                HStack
                                {
                                    Image(systemName: "info.circle.fill")
                                        .font(.subheadline)
                                    Text("Quantity should not be greater than 1000")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)

                            )
                            .padding(.top, 7)
                            .padding(.horizontal, 15)
                    }
                    else if total >= balance && (Int((balance)/Double(coin.currentPrice)) == 0)
                    {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: Screenwidth, height: 35)
                            .foregroundColor(.red.opacity(0.5))
                            .overlay(
                                HStack
                                {
                                    Image(systemName: "info.circle.fill")
                                        .font(.subheadline)
                                    Text("Oops! Your account balance is too low.")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                    .foregroundColor(.white)
                                
                            )
                            .padding(.top, 7)
                            .padding(.horizontal, 15)
                        
                    }
                    else if total >= balance
                    {
                        let validQty = (balance)/Double(coin.currentPrice)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: Screenwidth, height: 35)
                            .foregroundColor(.yellow.opacity(0.3))
                            .overlay(
                                HStack {
                                    Image(systemName: "info.circle.fill")
                                        .font(.subheadline)
                                    Text("Available balance is enough to buy \(Int(validQty)) qty")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                            )
                            .padding(.top, 7)
                            .padding(.horizontal, 15)
                    }

                    
                    Spacer()
                    
                
                    // Balance and Required Money...
                    HStack {
                        Text("Balance : ₹\(balance.toNormalString())")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Required : ₹\(total.toNormalString())")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 25)
                    
                    
                    // Buy Button...
                    if (total >= balance) && (Int((balance)/Double(coin.currentPrice)) != 0)
                    {
                        let validQty = (balance)/Double(coin.currentPrice)
                        Button {
                            authViewModel.buyCoin(coinName: coin.name, coinPrice: coin.currentPrice, coinQty: String(Int(validQty)))
                            successNotificationManager.showTick = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                successNotificationManager.showTick = false
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        label: {
                            HStack {
                                Text("BUY \(Int(validQty)) QTY")
                                    .fontWeight(.semibold)
                                Image(systemName: "arrow.right")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width-32, height: 48)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                        }
                        .background(Color(.systemBlue).opacity(0.3))
                        .padding(.horizontal, 15)
                        .padding(.bottom, 10)
                        .disabled(successNotificationManager.showTick == true || coin.currentPrice.toNormalString() == "₹0.00" ? true : false)
                        .opacity(successNotificationManager.showTick == true || coin.currentPrice.toCurrency() == "₹0.00" ? 0.5 : 1)
                        
                    }
                    else {
                        Button {
                            authViewModel.buyCoin(coinName: coin.name, coinPrice: coin.currentPrice, coinQty: qty)
                            
                            successNotificationManager.showTick = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                successNotificationManager.showTick = false
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        label: {
                            HStack {
                                Text("BUY")
                                    .fontWeight(.semibold)
                                Image(systemName: "arrow.right")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width-32, height: 48)
                        }
                        .background(Color(.systemBlue).opacity(0.85))
                        .cornerRadius(10)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 10)
                        .disabled(qty == "0" ||
                                  qty == "" ||
                                  coin.currentPrice.toCurrency() == "₹0.00" ||
                                  (Int(qty) ?? 0) > 1000 ||
                                  total >= balance
                                  ? true : false ||
                                  successNotificationManager.showTick)
                        .opacity(qty == "0" ||
                                 qty == "" ||
                                 coin.currentPrice.toCurrency() == "₹0.00" ||
                                 (Int(qty) ?? 0) > 1000 ||
                                 successNotificationManager.showTick ||
                                 total >= balance
                                 ? 0.7 : 1 )
                    }
                    
                    
                    
                }
                .overlay(
                    SuccessNotificationView(showTick: $successNotificationManager.showTick)
                )
                .onChange(of: qty) { newValue in
                    updateTotal()
                }
                .onAppear {
                    getBalance()
                }
            }
        
        
        
        
        
        
    }
    
    private func updateTotal() {
        self.total = ((Double(qty == "" ? "0" : qty) ?? 0.0) * coin.currentPrice)
        print("TOTAL : ", self.qty)
        }
    
    private func getBalance() {
        authViewModel.getBalance { balance in
            if let balance = balance {
                self.balance = Double(balance) ?? 50.0
            }
            print("BALANCE : ", self.balance)
        }}
        
}

