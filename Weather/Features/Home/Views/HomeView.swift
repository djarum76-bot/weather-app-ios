//
//  HomeView.swift
//  Weather
//
//  Created by habil . on 31/01/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    
    var body: some View {
        ZStack{
            Color.activeColor
            
            switch homeVM.networkState {
            case .success:
                HomeBackground()
                    .offset(y: homeVM.imageOffset)
                
                HomeImage()
                    .offset(y: homeVM.imageOffset)
                
                VStack{
                    Spacer().frame(height: homeVM.isDragging ? 82.5 : 90)
                    
                    HomeWeather()
                        .environmentObject(homeVM)
                    
                    Spacer()
                }
                
                HomeModal()
                    .environmentObject(homeVM)
            case .failed:
                ScrollView{
                    Spacer().frame(height: 400)
                    
                    Text("You encountering an error")
                    Text("Pull Down to Refresh")
                }
                .foregroundStyle(.white)
                .refreshable {
                    await homeVM.requestLocationUpdate()
                    await homeVM.getForecast()
                }
            case .loading, .initial:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2.0, anchor: .center)
            }
        }
        .onChange(of: homeVM.address, { oldValue, newValue in
            Task {
                await homeVM.getForecast()
            }
        })
        .alert("Oops...", isPresented: $homeVM.hasError) {} message: {
            Text(homeVM.homeError?.errorDescription ?? "You encountering an error")
        }
        .ignoresSafeArea()
    }
}

private extension HomeView{
    struct HomeBackground: View {
        var body: some View {
            Image(decorative: Assets.background)
                .resizable()
                .overlay(
                    LinearGradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .bgGradient, location: 0.7),
                        .init(color: .activeColor, location: 0.8)
                    ], startPoint: .top, endPoint: .bottom)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    struct HomeImage: View {
        var body: some View {
            VStack{
                Spacer()
                
                Image(decorative: Assets.house)
                    .resizable()
                    .scaledToFit()
                
                Spacer().frame(height: 95)
            }
        }
    }
    
    struct HomeWeather: View {
        @EnvironmentObject private var homeVM: HomeViewModel
        
        var body: some View {
            VStack(spacing: 0){
                Text("\(homeVM.address)")
                    .foregroundStyle(Color.primaryColor)
                    .font(.system(size: 30).weight(.regular))
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .offset(y: homeVM.titleOffset)
                
                Text("\(homeVM.currentTemperature)°")
                    .font(.system(size: homeVM.tempFontSize, weight: homeVM.isDragging ? .semibold : .thin))
                    .foregroundStyle(homeVM.isDragging ? Color.secondaryColor : Color.primaryColor)
                    .offset(x: homeVM.tempOffset, y: 0)
                
                Capsule()
                    .frame(width: 2,height: 20)
                    .foregroundStyle(Color.secondaryColor)
                    .opacity(homeVM.isDragging ? 1 : 0)
                    .offset(x: -40, y: -22)
                
                VStack{
                    Text(homeVM.getWeatherType(from: homeVM.forecast!.current.weatherCode).weatherDesc)
                        .font(.system(size: 20).weight(.semibold))
                        .foregroundStyle(Color.secondaryColor)
                    
                    Text("H:\(homeVM.maxTemperature)° L:\(homeVM.minTemperature)°")
                        .font(.system(size: 20).weight(.semibold))
                        .foregroundStyle(Color.primaryColor)
                        .opacity(homeVM.isDragging ? 0 : 1)
                }
                .offset(x: homeVM.weatherDataOffsetX, y: homeVM.weatherDataOffsetY)
            }
        }
    }
    
    struct HomeModal: View {
        @EnvironmentObject private var homeVM: HomeViewModel
        
        var body: some View {
            VStack(spacing: 0){
                Spacer().frame(height: 16)
                
                Rectangle()
                    .frame(width: 48, height: 5)
                    .background(.black.opacity(0.3))
                    .clipShape(.rect(cornerRadius: 10))
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                homeVM.modalOffset += gesture.translation.height
                                homeVM.imageOffset += gesture.translation.height * 1.5
                                
                                if homeVM.tempOffset < homeVM.tempOffsetMin {
                                    homeVM.titleOffset += gesture.translation.height * 0.1
                                }
                                
                                if homeVM.tempOffset > homeVM.tempOffsetMin {
                                    homeVM.tempFontSize += gesture.translation.height * 0.1
                                }
                                homeVM.tempOffset += gesture.translation.height * 0.1
                                
                                if homeVM.tempOffset > homeVM.tempOffsetMin {
                                    homeVM.weatherDataOffsetX -= gesture.translation.height * 0.1
                                }
                                homeVM.weatherDataOffsetY += gesture.translation.height * 0.1
                            }
                            .onEnded { gesture in
                                homeVM.titleOffset = 0
                                
                                if gesture.translation.height > 0 {
                                    if !(homeVM.modalOffset < homeVM.modalTopPosition) {
                                        withAnimation {
                                            homeVM.isDragging = false
                                            
                                            homeVM.modalOffset = homeVM.modalBottomPosition
                                            homeVM.imageOffset = 0
                                            
                                            homeVM.tempFontSize = homeVM.tempFontMaxSize
                                            homeVM.tempOffset = homeVM.tempOffsetMax
                                            
                                            homeVM.weatherDataOffsetX = 0
                                            homeVM.weatherDataOffsetY = homeVM.weatherDataOffsetMax
                                            
                                            homeVM.scrollView?.scrollTo(homeVM.topModal)
                                        }
                                    } else {
                                        withAnimation {
                                            homeVM.isDragging = true
                                            
                                            homeVM.modalOffset = homeVM.modalTopPosition
                                            homeVM.imageOffset = -1000
                                            
                                            homeVM.tempFontSize = homeVM.tempFontMinSize
                                            homeVM.tempOffset = homeVM.tempOffsetMin
                                            
                                            let weatherDataOffsetX = (24.5 / 12.0) * Double(homeVM.getWeatherType(from: homeVM.forecast!.current.weatherCode).weatherDesc.count)
                                            
                                            homeVM.weatherDataOffsetX = weatherDataOffsetX
                                            homeVM.weatherDataOffsetY = homeVM.weatherDataOffsetMinY
                                        }
                                    }
                                } else {
                                    if !(homeVM.modalOffset > homeVM.modalBottomPosition) {
                                        withAnimation {
                                            homeVM.isDragging = true
                                            
                                            homeVM.modalOffset = homeVM.modalTopPosition
                                            homeVM.imageOffset = -1000
                                            
                                            homeVM.tempFontSize = homeVM.tempFontMinSize
                                            homeVM.tempOffset = homeVM.tempOffsetMin
                                            
                                            let weatherDataOffsetX = (24.5 / 12.0) * Double(homeVM.getWeatherType(from: homeVM.forecast!.current.weatherCode).weatherDesc.count)
                                            
                                            homeVM.weatherDataOffsetX = weatherDataOffsetX
                                            homeVM.weatherDataOffsetY = homeVM.weatherDataOffsetMinY
                                        }
                                    } else {
                                        withAnimation {
                                            homeVM.isDragging = false
                                            
                                            homeVM.modalOffset = homeVM.modalBottomPosition
                                            homeVM.imageOffset = 0
                                            
                                            homeVM.tempFontSize = homeVM.tempFontMaxSize
                                            homeVM.tempOffset = homeVM.tempOffsetMax
                                            
                                            homeVM.weatherDataOffsetX = 0
                                            homeVM.weatherDataOffsetY = homeVM.weatherDataOffsetMax
                                            
                                            homeVM.scrollView?.scrollTo(homeVM.topModal)
                                        }
                                    }
                                }
                            }
                    )
                
                Spacer().frame(height: 20)
                
                Divider()
                
                ScrollView{
                    ScrollViewReader{ scrollView in
                        VStack{
                            ScrollView(.horizontal){
                                LazyHStack(spacing: 12){
                                    ForEach(homeVM.initialIndex..<homeVM.lastIndex, id: \.self){ index in
                                        NeumorphicButton(
                                            isActive: homeVM.selected == index,
                                            time: homeVM.forecast!.hourly.time[index],
                                            degree: homeVM.forecast!.hourly.temperature2M[index],
                                            image: homeVM.getWeatherType(from: homeVM.forecast!.hourly.weatherCode[index]).image
                                        ){
                                            withAnimation {
                                                homeVM.selected = index
                                            }
                                        }
                                        .padding(.leading, index == homeVM.initialIndex ? 20 : 0)
                                        .padding(.trailing, index == homeVM.lastIndex - 1 ? 20 : 0)
                                    }
                                }
                            }
                            .scrollIndicators(.never)
                            .id(homeVM.topModal)
                            
                            Grid(alignment: .center, horizontalSpacing: 14, verticalSpacing: 10) {
                                GridRow{
                                    WeatherDetail(icon: "sun.max.fill", label: "UV INDEX"){
                                        UVIndex(value: homeVM.forecast!.hourly.uvIndex[homeVM.selected])
                                    }
                                    
                                    WeatherDetail(icon: "sunrise.fill", label: "SUNRISE"){
                                        Sunrise(sunrise: homeVM.sunrise, sunset: homeVM.sunset)
                                    }
                                }
                                
                                GridRow{
                                    WeatherDetail(icon: "wind", label: "WIND"){
                                        Wind(
                                            speed: homeVM.forecast!.hourly.windSpeed10M[homeVM.selected],
                                            direction: homeVM.forecast!.hourly.windDirection10M[homeVM.selected]
                                        )
                                    }
                                    
                                    WeatherDetail(icon: "drop.fill", label: "RAINFALL"){
                                        Rainfall(rain: homeVM.forecast!.hourly.rain[homeVM.selected])
                                    }
                                }
                                
                                GridRow{
                                    WeatherDetail(icon: "thermometer", label: "FEELS LIKE"){
                                        ApparentTemperature(degree: homeVM.forecast!.hourly.apparentTemperature[homeVM.selected]
                                        )
                                    }
                                    
                                    WeatherDetail(icon: "humidity.fill", label: "HUMIDITY"){
                                        Humidity(
                                            humidity: homeVM.forecast!.hourly.relativeHumidity2M[homeVM.selected],
                                            dew: homeVM.forecast!.hourly.dewPoint2M[homeVM.selected]
                                        )
                                    }
                                }
                                
                                WeatherDetail(icon: "eye.fill", label: "VISIBILITY"){
                                    Visibility(visibility: homeVM.forecast!.hourly.visibility[homeVM.selected])
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 255)
                        }
                        .onAppear{
                            homeVM.scrollView = scrollView
                        }
                    }
                }
                .scrollIndicators(.never)
                .scrollDisabled(!homeVM.isDragging)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 930)
            .background(.ultraThinMaterial)
            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 36))
            .offset(y: homeVM.modalOffset)
        }
    }
}

private extension HomeView.HomeModal{
    struct WeatherDetail<Content: View>: View {
        let icon: String
        let label: String
        let content: Content
        
        init(icon: String, label: String, @ViewBuilder content: () -> Content) {
            self.icon = icon
            self.label = label
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0){
                HStack{
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.secondaryColor)
                    
                    Text(label)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.secondaryColor)
                }
                .padding(.horizontal)
                
                Spacer()
                
                content
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: 164, alignment: .leading)
            .background(Color.activeColor.opacity(0.3))
            .clipShape(.rect(cornerRadius: 22))
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.tertiaryColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    HomeView()
}
